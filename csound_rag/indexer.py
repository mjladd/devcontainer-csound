"""
Corpus indexer for Csound RAG Assistant.

Processes markdown files from the corpus and .csd example files,
chunks them intelligently, and stores them in ChromaDB with embeddings.
"""

import re
import yaml
from pathlib import Path
from typing import Iterator

import chromadb
from chromadb.config import Settings
from sentence_transformers import SentenceTransformer


# Opcode categories for classification
OPCODE_CATEGORIES = {
    "oscillators": ["oscil", "oscili", "poscil", "vco", "vco2", "buzz", "gbuzz", "phasor", "lfo"],
    "filters": ["moogladder", "moogvcf", "lowpass", "highpass", "bandpass", "butterlp", "butterhp",
                "butbp", "butbr", "resonz", "reson", "lpf18", "tone", "atone", "biquad", "svfilter"],
    "envelopes": ["adsr", "madsr", "linen", "linenr", "linseg", "expseg", "transeg", "envlpx"],
    "effects": ["reverb", "freeverb", "reverbsc", "delay", "vdelay", "flanger", "phaser", "chorus"],
    "granular": ["grain", "grain2", "grain3", "granule", "partikkel", "fof", "fog", "sndwarp"],
    "physical_models": ["pluck", "repluck", "wgbow", "wgclar", "wgflute", "wgbrass", "mandol", "marimba"],
    "fm_synthesis": ["foscil", "foscili", "fmbell", "fmrhode", "fmwurlie", "fmmetal", "crossfm"],
    "sample_playback": ["diskin", "diskin2", "loscil", "loscil3", "flooper", "sndloop"],
    "analysis": ["ptrack", "pitch", "pitchamdf", "rms", "follow", "spectrum", "pvsanal"],
    "midi": ["notnum", "veloc", "cpsmidi", "ampmidi", "midictrl", "ctrl7", "massign"],
    "noise": ["noise", "rand", "randi", "randh", "pink", "pinker", "dust", "dust2"],
    "math": ["abs", "int", "frac", "pow", "sqrt", "log", "exp", "sin", "cos", "tan"],
}


class CsoundIndexer:
    """Indexes Csound corpus into ChromaDB."""

    EMBEDDING_MODEL = "all-MiniLM-L6-v2"
    COLLECTION_NAME = "csound_corpus"
    MAX_CHUNK_SIZE = 1500  # characters, roughly 300-400 tokens
    MAX_CSD_CHUNK_SIZE = 2500  # larger for code to keep instruments intact

    def __init__(self, db_path: str | Path):
        """Initialize indexer with database path."""
        self.db_path = Path(db_path)
        self.db_path.mkdir(parents=True, exist_ok=True)

        self.client = chromadb.PersistentClient(
            path=str(self.db_path),
            settings=Settings(anonymized_telemetry=False),
        )
        self.embedding_model = SentenceTransformer(self.EMBEDDING_MODEL)

    def get_or_create_collection(self):
        """Get or create the ChromaDB collection."""
        return self.client.get_or_create_collection(
            name=self.COLLECTION_NAME,
            metadata={"description": "Csound programming corpus"},
        )

    def reset_collection(self):
        """Delete and recreate the collection."""
        try:
            self.client.delete_collection(self.COLLECTION_NAME)
        except Exception:
            pass  # Collection may not exist
        return self.get_or_create_collection()

    def load_corpus(self, corpus_dir: Path) -> Iterator[dict]:
        """
        Walk corpus directory and yield documents with metadata.

        Yields:
            dict with keys: content, source, title, path
        """
        corpus_dir = Path(corpus_dir)

        for md_file in corpus_dir.rglob("*.md"):
            # Skip index files
            if md_file.name.lower() in ("index.md", "readme.md"):
                continue

            try:
                content = md_file.read_text(encoding="utf-8", errors="replace")
            except Exception as e:
                print(f"  Warning: Could not read {md_file}: {e}")
                continue

            # Skip very short files
            if len(content) < 100:
                continue

            # Extract metadata from YAML front matter
            metadata = self._extract_front_matter(content)
            content_body = self._remove_front_matter(content)

            # Determine source from path
            rel_path = md_file.relative_to(corpus_dir)
            source = rel_path.parts[0] if rel_path.parts else "unknown"

            yield {
                "content": content_body,
                "source": source,
                "title": metadata.get("title", md_file.stem),
                "path": str(rel_path),
                "metadata": metadata,
            }

    def _extract_front_matter(self, content: str) -> dict:
        """Extract YAML front matter from markdown content."""
        if not content.startswith("---"):
            return {}

        try:
            end_idx = content.index("---", 3)
            yaml_content = content[3:end_idx].strip()
            return yaml.safe_load(yaml_content) or {}
        except (ValueError, yaml.YAMLError):
            return {}

    def _remove_front_matter(self, content: str) -> str:
        """Remove YAML front matter from markdown content."""
        if not content.startswith("---"):
            return content

        try:
            end_idx = content.index("---", 3)
            return content[end_idx + 3:].strip()
        except ValueError:
            return content

    def load_csd_examples(self, examples_dir: Path) -> Iterator[dict]:
        """
        Walk examples directory and yield .csd files with metadata.

        Yields:
            dict with keys: content, source, title, path, metadata
        """
        examples_dir = Path(examples_dir)

        for csd_file in examples_dir.rglob("*.csd"):
            try:
                content = csd_file.read_text(encoding="utf-8", errors="replace")
            except Exception as e:
                print(f"  Warning: Could not read {csd_file}: {e}")
                continue

            # Skip very short files
            if len(content) < 50:
                continue

            # Parse the CSD file to extract metadata
            metadata = self._parse_csd_metadata(content, csd_file.stem)

            # Determine relative path
            try:
                rel_path = csd_file.relative_to(examples_dir)
            except ValueError:
                rel_path = csd_file.name

            yield {
                "content": content,
                "source": "csd_examples",
                "title": metadata.get("title", csd_file.stem),
                "path": str(rel_path),
                "metadata": metadata,
                "is_csd": True,
            }

    def _parse_csd_metadata(self, content: str, filename: str) -> dict:
        """
        Parse a .csd file and extract metadata.

        Extracts:
        - Title from filename or comments
        - Detected opcodes
        - Categorized techniques
        - Instrument count
        - Description from comments
        """
        metadata = {
            "title": self._clean_filename_to_title(filename),
            "opcodes": [],
            "categories": [],
            "instruments": [],
            "description": "",
        }

        # Extract description from comments at the top
        description_lines = []
        in_header = True
        for line in content.split('\n')[:30]:  # Check first 30 lines
            line = line.strip()
            if line.startswith(';'):
                comment = line[1:].strip()
                if comment and in_header:
                    # Skip separator lines
                    if not re.match(r'^[-=*]+$', comment):
                        description_lines.append(comment)
            elif line.startswith('<') or not line:
                continue
            else:
                in_header = False

        if description_lines:
            metadata["description"] = ' '.join(description_lines[:3])

        # Extract instrument numbers
        instr_pattern = r'^\s*instr\s+(\d+(?:\s*,\s*\d+)*|\w+)'
        for match in re.finditer(instr_pattern, content, re.MULTILINE | re.IGNORECASE):
            instr_ids = match.group(1)
            metadata["instruments"].append(instr_ids.strip())

        # Detect opcodes used
        detected_opcodes = set()
        content_lower = content.lower()

        for category, opcodes in OPCODE_CATEGORIES.items():
            for opcode in opcodes:
                # Match opcode as a word boundary
                pattern = rf'\b{opcode}\b'
                if re.search(pattern, content_lower):
                    detected_opcodes.add(opcode)
                    if category not in metadata["categories"]:
                        metadata["categories"].append(category)

        metadata["opcodes"] = sorted(list(detected_opcodes))

        return metadata

    def _clean_filename_to_title(self, filename: str) -> str:
        """Convert a filename to a readable title."""
        # Remove common prefixes like numbers
        title = re.sub(r'^\d+[-_]?', '', filename)
        # Replace underscores and hyphens with spaces
        title = re.sub(r'[-_]+', ' ', title)
        # Capitalize words
        title = title.title()
        # Handle CamelCase
        title = re.sub(r'([a-z])([A-Z])', r'\1 \2', title)
        return title.strip() or filename

    def chunk_csd_document(self, doc: dict) -> list[dict]:
        """
        Split a .csd file into chunks for embedding.

        Strategy:
        - Keep small files intact
        - Split larger files by instrument definitions
        - Create a summary chunk with opcodes and description
        """
        content = doc["content"]
        metadata = doc.get("metadata", {})
        chunks = []

        # Create a summary/searchable chunk
        summary_parts = [f"# {doc['title']}", ""]

        if metadata.get("description"):
            summary_parts.append(f"Description: {metadata['description']}")
            summary_parts.append("")

        if metadata.get("categories"):
            summary_parts.append(f"Techniques: {', '.join(metadata['categories'])}")

        if metadata.get("opcodes"):
            summary_parts.append(f"Opcodes used: {', '.join(metadata['opcodes'])}")

        if metadata.get("instruments"):
            summary_parts.append(f"Instruments: {', '.join(metadata['instruments'])}")

        summary_text = '\n'.join(summary_parts)

        chunks.append({
            "text": summary_text,
            "section": "Summary",
            "source": doc["source"],
            "title": doc["title"],
            "path": doc["path"],
            "has_code": False,
            "chunk_type": "csd_summary",
            "opcodes": metadata.get("opcodes", []),
            "categories": metadata.get("categories", []),
        })

        # If file is small enough, add as single code chunk
        if len(content) <= self.MAX_CSD_CHUNK_SIZE:
            chunks.append({
                "text": content,
                "section": "Complete Code",
                "source": doc["source"],
                "title": doc["title"],
                "path": doc["path"],
                "has_code": True,
                "chunk_type": "csd_code",
                "opcodes": metadata.get("opcodes", []),
                "categories": metadata.get("categories", []),
            })
        else:
            # Split by instrument definitions
            instrument_chunks = self._split_csd_by_instruments(content)

            for i, (instr_name, instr_code) in enumerate(instrument_chunks):
                # Detect opcodes in this specific instrument
                instr_opcodes = self._detect_opcodes_in_text(instr_code)

                chunks.append({
                    "text": instr_code,
                    "section": f"Instrument {instr_name}" if instr_name else f"Part {i+1}",
                    "source": doc["source"],
                    "title": doc["title"],
                    "path": doc["path"],
                    "has_code": True,
                    "chunk_type": "csd_instrument",
                    "opcodes": instr_opcodes,
                    "categories": metadata.get("categories", []),
                })

        return chunks

    def _split_csd_by_instruments(self, content: str) -> list[tuple[str, str]]:
        """Split CSD content by instrument definitions."""
        chunks = []

        # Extract the header (everything before first instr)
        header_match = re.search(
            r'(<CsInstruments>.*?)(?=\s*instr\s+)',
            content,
            re.DOTALL | re.IGNORECASE,
        )

        # Find all instrument blocks
        instr_pattern = r'(\s*instr\s+(\d+(?:\s*,\s*\d+)*|\w+).*?endin)'
        instruments = list(re.finditer(instr_pattern, content, re.DOTALL | re.IGNORECASE))

        if not instruments:
            # No instruments found, return the whole content
            return [("", content)]

        # Add header + first instrument
        if header_match:
            header = header_match.group(1)
        else:
            header = ""

        current_chunk = header
        current_instr = ""

        for match in instruments:
            instr_block = match.group(1)
            instr_id = match.group(2)

            # If adding this instrument exceeds limit, save current and start new
            if len(current_chunk) + len(instr_block) > self.MAX_CSD_CHUNK_SIZE:
                if current_chunk.strip():
                    chunks.append((current_instr, current_chunk))
                current_chunk = instr_block
                current_instr = instr_id
            else:
                current_chunk += instr_block
                if not current_instr:
                    current_instr = instr_id
                else:
                    current_instr = f"{current_instr}, {instr_id}"

        # Add remaining
        if current_chunk.strip():
            chunks.append((current_instr, current_chunk))

        # Add the score section if present
        score_match = re.search(r'(<CsScore>.*?</CsScore>)', content, re.DOTALL | re.IGNORECASE)
        if score_match and len(score_match.group(1)) > 100:
            score_content = score_match.group(1)
            if len(score_content) <= self.MAX_CSD_CHUNK_SIZE:
                chunks.append(("score", score_content))

        return chunks if chunks else [("", content)]

    def _detect_opcodes_in_text(self, text: str) -> list[str]:
        """Detect opcodes present in a text snippet."""
        detected = set()
        text_lower = text.lower()

        for category, opcodes in OPCODE_CATEGORIES.items():
            for opcode in opcodes:
                if re.search(rf'\b{opcode}\b', text_lower):
                    detected.add(opcode)

        return sorted(list(detected))

    def chunk_document(self, doc: dict) -> list[dict]:
        """
        Split document into chunks for embedding.

        Strategy:
        - Split on markdown headers (##, ###)
        - Keep code blocks intact
        - Respect max chunk size
        """
        content = doc["content"]
        chunks = []

        # Split on headers while preserving them
        sections = self._split_on_headers(content)

        for section_title, section_content in sections:
            # If section is small enough, keep as one chunk
            if len(section_content) <= self.MAX_CHUNK_SIZE:
                chunks.append({
                    "text": section_content,
                    "section": section_title,
                    "source": doc["source"],
                    "title": doc["title"],
                    "path": doc["path"],
                    "has_code": "```" in section_content or "<CsoundSynthesizer>" in section_content,
                })
            else:
                # Split large sections, preserving code blocks
                sub_chunks = self._split_large_section(section_content)
                for i, sub_chunk in enumerate(sub_chunks):
                    chunks.append({
                        "text": sub_chunk,
                        "section": f"{section_title} (part {i+1})" if len(sub_chunks) > 1 else section_title,
                        "source": doc["source"],
                        "title": doc["title"],
                        "path": doc["path"],
                        "has_code": "```" in sub_chunk or "<CsoundSynthesizer>" in sub_chunk,
                    })

        return chunks

    def _split_on_headers(self, content: str) -> list[tuple[str, str]]:
        """Split content on markdown headers, returning (title, content) pairs."""
        # Pattern matches ## or ### headers
        pattern = r'^(#{2,3})\s+(.+?)$'

        sections = []
        current_title = "Introduction"
        current_content = []

        for line in content.split('\n'):
            header_match = re.match(pattern, line)
            if header_match:
                # Save previous section
                if current_content:
                    sections.append((current_title, '\n'.join(current_content).strip()))
                current_title = header_match.group(2).strip()
                current_content = [line]
            else:
                current_content.append(line)

        # Save final section
        if current_content:
            sections.append((current_title, '\n'.join(current_content).strip()))

        return sections

    def _split_large_section(self, content: str) -> list[str]:
        """Split a large section while preserving code blocks."""
        chunks = []
        current_chunk = []
        current_size = 0
        in_code_block = False
        code_block_content = []

        for line in content.split('\n'):
            # Track code blocks
            if line.strip().startswith('```') or '<CsoundSynthesizer>' in line:
                if not in_code_block:
                    in_code_block = True
                    code_block_content = [line]
                else:
                    code_block_content.append(line)
                    in_code_block = False
                    # Add complete code block
                    block = '\n'.join(code_block_content)
                    if current_size + len(block) > self.MAX_CHUNK_SIZE and current_chunk:
                        chunks.append('\n'.join(current_chunk))
                        current_chunk = [block]
                        current_size = len(block)
                    else:
                        current_chunk.append(block)
                        current_size += len(block)
                    code_block_content = []
                continue

            if in_code_block:
                code_block_content.append(line)
                continue

            # Handle end of CSD files
            if '</CsoundSynthesizer>' in line:
                if code_block_content:
                    code_block_content.append(line)
                    block = '\n'.join(code_block_content)
                    current_chunk.append(block)
                    current_size += len(block)
                    code_block_content = []
                    in_code_block = False
                continue

            # Regular line
            if current_size + len(line) > self.MAX_CHUNK_SIZE and current_chunk:
                chunks.append('\n'.join(current_chunk))
                current_chunk = [line]
                current_size = len(line)
            else:
                current_chunk.append(line)
                current_size += len(line) + 1

        # Add remaining content
        if current_chunk:
            chunks.append('\n'.join(current_chunk))

        return chunks if chunks else [content]

    def index_corpus(self, corpus_dir: Path, reset: bool = False, examples_dir: Path | None = None) -> dict:
        """
        Index entire corpus into ChromaDB.

        Args:
            corpus_dir: Path to corpus directory
            reset: If True, delete existing index first
            examples_dir: Optional path to .csd examples directory

        Returns:
            dict with indexing statistics
        """
        corpus_dir = Path(corpus_dir)

        if reset:
            collection = self.reset_collection()
        else:
            collection = self.get_or_create_collection()

        stats = {
            "documents": 0,
            "chunks": 0,
            "sources": set(),
            "csd_files": 0,
        }

        all_chunks = []
        all_ids = []
        all_metadatas = []

        print(f"Loading corpus from {corpus_dir}...")

        for doc in self.load_corpus(corpus_dir):
            stats["documents"] += 1
            stats["sources"].add(doc["source"])

            chunks = self.chunk_document(doc)

            for i, chunk in enumerate(chunks):
                chunk_id = f"{doc['path']}#{i}"
                all_chunks.append(chunk["text"])
                all_ids.append(chunk_id)
                all_metadatas.append({
                    "source": chunk["source"],
                    "title": chunk["title"],
                    "section": chunk["section"],
                    "path": chunk["path"],
                    "has_code": chunk["has_code"],
                })
                stats["chunks"] += 1

            if stats["documents"] % 50 == 0:
                print(f"  Processed {stats['documents']} documents, {stats['chunks']} chunks...")

        # Index .csd examples if directory provided
        if examples_dir and Path(examples_dir).exists():
            print(f"\nLoading .csd examples from {examples_dir}...")

            for doc in self.load_csd_examples(examples_dir):
                stats["csd_files"] += 1
                stats["sources"].add(doc["source"])

                chunks = self.chunk_csd_document(doc)

                for i, chunk in enumerate(chunks):
                    chunk_id = f"csd:{doc['path']}#{i}"
                    all_chunks.append(chunk["text"])
                    all_ids.append(chunk_id)

                    # Build metadata
                    chunk_metadata = {
                        "source": chunk["source"],
                        "title": chunk["title"],
                        "section": chunk["section"],
                        "path": chunk["path"],
                        "has_code": chunk["has_code"],
                        "chunk_type": chunk.get("chunk_type", "csd"),
                    }

                    # Add opcodes as comma-separated string (ChromaDB doesn't support lists)
                    if chunk.get("opcodes"):
                        chunk_metadata["opcodes"] = ",".join(chunk["opcodes"])
                    if chunk.get("categories"):
                        chunk_metadata["categories"] = ",".join(chunk["categories"])

                    all_metadatas.append(chunk_metadata)
                    stats["chunks"] += 1

                if stats["csd_files"] % 100 == 0:
                    print(f"  Processed {stats['csd_files']} .csd files, {stats['chunks']} total chunks...")

        if not all_chunks:
            print("No documents found to index.")
            return stats

        print(f"Embedding {len(all_chunks)} chunks...")
        embeddings = self.embedding_model.encode(
            all_chunks,
            show_progress_bar=True,
            convert_to_numpy=True,
        )

        print("Adding to ChromaDB...")
        # Add in batches to avoid memory issues
        batch_size = 500
        for i in range(0, len(all_chunks), batch_size):
            end = min(i + batch_size, len(all_chunks))
            collection.add(
                ids=all_ids[i:end],
                documents=all_chunks[i:end],
                embeddings=embeddings[i:end].tolist(),
                metadatas=all_metadatas[i:end],
            )

        stats["sources"] = list(stats["sources"])
        print(f"Indexed {stats['documents']} documents into {stats['chunks']} chunks")
        return stats

    def get_stats(self) -> dict:
        """Get statistics about the current index."""
        try:
            collection = self.client.get_collection(self.COLLECTION_NAME)
            count = collection.count()
            return {
                "indexed": True,
                "chunks": count,
                "db_path": str(self.db_path),
            }
        except Exception:
            return {
                "indexed": False,
                "chunks": 0,
                "db_path": str(self.db_path),
            }
