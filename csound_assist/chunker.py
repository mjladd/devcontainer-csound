"""
Document chunking for the Csound corpus.

Provides intelligent chunking strategies:
- Markdown: split by headers, preserve code blocks, size limits with overlap
- CSD files: structured chunking by instrument/UDO/score with enrichment prefixes
- JSONL: instruction/output pairs from training data
"""

import re
from dataclasses import dataclass, field

from csound_assist.opcode_data import detect_opcodes, infer_techniques


@dataclass
class Chunk:
    """A document chunk with metadata."""
    content: str
    metadata: dict
    chunk_id: str

    @property
    def token_estimate(self) -> int:
        """Rough token count estimate (4 chars per token)."""
        return len(self.content) // 4


# ---------------------------------------------------------------------------
# Markdown chunking (preserved from original with minor improvements)
# ---------------------------------------------------------------------------

def extract_frontmatter(content: str) -> tuple[dict, str]:
    """Extract YAML frontmatter from markdown content."""
    metadata: dict = {}
    if content.startswith("---"):
        parts = content.split("---", 2)
        if len(parts) >= 3:
            frontmatter = parts[1].strip()
            content = parts[2].strip()
            for line in frontmatter.split("\n"):
                if ":" in line:
                    key, value = line.split(":", 1)
                    key = key.strip().strip("-").strip()
                    value = value.strip()
                    if key and value:
                        metadata[key] = value
    return metadata, content


def extract_metadata_block(content: str) -> tuple[dict, str]:
    """Extract metadata from ## Metadata section."""
    metadata: dict = {}
    metadata_match = re.search(
        r'^## Metadata\s*\n(.*?)(?=^## |\Z)',
        content,
        re.MULTILINE | re.DOTALL,
    )
    if metadata_match:
        meta_text = metadata_match.group(1)
        for match in re.finditer(r'\*\*([^*]+)\*\*:\s*(.+?)(?=\n|$)', meta_text):
            key = match.group(1).strip().lower()
            value = match.group(2).strip()
            metadata[key] = value
    return metadata, content


def split_by_headers(content: str, level: int = 2) -> list[tuple[str, str]]:
    """Split content by markdown headers of given level."""
    pattern = rf'^({"#" * level}\s+.+?)$'
    parts = re.split(pattern, content, flags=re.MULTILINE)

    sections: list[tuple[str, str]] = []
    current_header = ""
    current_content = ""

    for part in parts:
        if re.match(pattern, part, re.MULTILINE):
            if current_content.strip():
                sections.append((current_header, current_content.strip()))
            current_header = part.strip()
            current_content = ""
        else:
            current_content += part

    if current_content.strip():
        sections.append((current_header, current_content.strip()))

    return sections


def preserve_code_blocks(content: str) -> list[tuple[str, bool]]:
    """Split content into code and non-code segments."""
    pattern = r'(```[\s\S]*?```)'
    parts = re.split(pattern, content)
    segments: list[tuple[str, bool]] = []
    for part in parts:
        if part.startswith("```"):
            segments.append((part, True))
        elif part.strip():
            segments.append((part, False))
    return segments


def chunk_by_size(
    content: str,
    max_tokens: int = 500,
    overlap_tokens: int = 50,
) -> list[str]:
    """Chunk content by size while preserving code blocks."""
    segments = preserve_code_blocks(content)
    chunks: list[str] = []
    current_chunk = ""
    current_tokens = 0

    for segment, is_code in segments:
        segment_tokens = len(segment) // 4

        if is_code:
            if current_tokens + segment_tokens > max_tokens and current_chunk:
                chunks.append(current_chunk.strip())
                current_chunk = ""
                current_tokens = 0
            current_chunk += segment
            current_tokens += segment_tokens
        else:
            sentences = re.split(r'(?<=[.!?])\s+', segment)
            for sentence in sentences:
                sentence_tokens = len(sentence) // 4
                if current_tokens + sentence_tokens > max_tokens:
                    if current_chunk:
                        chunks.append(current_chunk.strip())
                        overlap_chars = overlap_tokens * 4
                        if len(current_chunk) > overlap_chars:
                            current_chunk = current_chunk[-overlap_chars:]
                            current_tokens = overlap_tokens
                        else:
                            current_chunk = ""
                            current_tokens = 0
                current_chunk += " " + sentence
                current_tokens += sentence_tokens

    if current_chunk.strip():
        chunks.append(current_chunk.strip())

    return chunks


def chunk_markdown_document(
    content: str,
    source_path: str,
    max_chunk_tokens: int = 500,
    min_chunk_tokens: int = 50,
) -> list[Chunk]:
    """
    Chunk a markdown document intelligently.

    Strategy:
    1. Extract metadata from frontmatter/metadata section
    2. Split by ## headers
    3. Preserve code blocks
    4. Apply size limits with overlap
    """
    chunks: list[Chunk] = []

    metadata, content = extract_frontmatter(content)
    section_metadata, content = extract_metadata_block(content)
    metadata.update(section_metadata)
    metadata["source"] = source_path

    sections = split_by_headers(content, level=2)
    if not sections:
        sections = [("", content)]

    for section_idx, (header, section_content) in enumerate(sections):
        sec_meta = metadata.copy()
        if header:
            sec_meta["section"] = header.lstrip("#").strip()

        section_tokens = len(section_content) // 4

        if section_tokens <= max_chunk_tokens:
            full_content = f"{header}\n\n{section_content}" if header else section_content
            if len(full_content) // 4 >= min_chunk_tokens:
                chunk_id = f"{source_path}::section_{section_idx}"
                chunks.append(Chunk(
                    content=full_content.strip(),
                    metadata=sec_meta,
                    chunk_id=chunk_id,
                ))
        else:
            sub_chunks = chunk_by_size(section_content, max_chunk_tokens)
            for sub_idx, sub_content in enumerate(sub_chunks):
                if len(sub_content) // 4 >= min_chunk_tokens:
                    if sub_idx == 0 and header:
                        sub_content = f"{header}\n\n{sub_content}"
                    chunk_id = f"{source_path}::section_{section_idx}::chunk_{sub_idx}"
                    chunks.append(Chunk(
                        content=sub_content.strip(),
                        metadata=sec_meta.copy(),
                        chunk_id=chunk_id,
                    ))

    return chunks


# ---------------------------------------------------------------------------
# CSD chunking with enrichment
# ---------------------------------------------------------------------------

def _extract_header_block(instr_content: str) -> dict:
    """Extract sr, ksmps, nchnls, 0dbfs and global variables from orchestra header."""
    info: dict = {}
    for key in ("sr", "ksmps", "nchnls", "nchnls_i", "0dbfs"):
        match = re.search(rf'\b{re.escape(key)}\s*=\s*(\S+)', instr_content)
        if match:
            info[key] = match.group(1)
    # Global variables
    globals_found = re.findall(r'\bg[afikSw]\w+', instr_content)
    if globals_found:
        info["globals"] = sorted(set(globals_found))
    return info


def _build_enrichment_prefix(
    chunk_type: str,
    source_path: str,
    opcodes: list[str],
    techniques: list[str],
    extra: str = "",
) -> str:
    """Build a natural-language enrichment prefix for a chunk."""
    parts = [f"Csound {chunk_type} from {source_path}."]
    if opcodes:
        parts.append(f"Uses: {', '.join(opcodes[:15])}.")
    if techniques:
        technique_labels = [t.replace("_", " ") for t in techniques]
        parts.append(f"Techniques: {', '.join(technique_labels)}.")
    if extra:
        parts.append(extra)
    return " ".join(parts)


def _extract_instruments(content: str) -> list[tuple[str, str]]:
    """Extract (instr_id, instr_code) pairs from orchestra content."""
    pattern = r'(instr\s+(\S+).*?endin)'
    matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
    return [(m[1], m[0]) for m in matches]


def _extract_udos(content: str) -> list[tuple[str, str]]:
    """Extract (udo_name, udo_code) pairs from orchestra content."""
    pattern = r'(opcode\s+(\w+).*?endop)'
    matches = re.findall(pattern, content, re.DOTALL | re.IGNORECASE)
    return [(m[1], m[0]) for m in matches]


def _extract_score_section(content: str) -> str | None:
    """Extract the <CsScore> section content."""
    match = re.search(
        r'<CsScore>(.*?)</CsScore>',
        content,
        re.DOTALL,
    )
    return match.group(1).strip() if match else None


def _extract_function_tables(score_content: str) -> str | None:
    """Extract f-statements (function tables) from score content."""
    lines = []
    for line in score_content.split("\n"):
        stripped = line.strip()
        if stripped.startswith("f") and not stripped.startswith("f0"):
            lines.append(stripped)
    return "\n".join(lines) if lines else None


def chunk_csound_code(
    content: str,
    source_path: str,
    max_tokens: int = 2000,
) -> list[Chunk]:
    """
    Chunk a Csound CSD file with enrichment prefixes.

    Produces chunk types:
    - complete_csd: full file if under max_tokens
    - header: sr, ksmps, nchnls, 0dbfs, global variables
    - instrument: each instr/endin block
    - udo: each opcode/endop block
    - score: <CsScore> section
    - function_tables: grouped f-statements
    """
    chunks: list[Chunk] = []
    file_tokens = len(content) // 4

    # If the file is small enough, index as a single complete chunk
    if file_tokens <= max_tokens:
        opcodes = detect_opcodes(content)
        techniques = infer_techniques(opcodes)
        prefix = _build_enrichment_prefix("CSD file", source_path, opcodes, techniques)
        chunks.append(Chunk(
            content=f"{prefix}\n\n{content}",
            metadata={
                "source": source_path,
                "type": "complete_csd",
                "opcodes": ",".join(opcodes[:20]),
                "techniques": ",".join(techniques),
            },
            chunk_id=f"{source_path}::complete_csd",
        ))
        return chunks

    # Extract <CsInstruments> section
    instr_match = re.search(
        r'<CsInstruments>(.*?)</CsInstruments>',
        content,
        re.DOTALL,
    )
    if not instr_match:
        # No instruments section -- index whole file as single chunk
        chunks.append(Chunk(
            content=content,
            metadata={"source": source_path, "type": "csound"},
            chunk_id=f"{source_path}::full",
        ))
        return chunks

    instr_content = instr_match.group(1)

    # Header chunk: everything before first instr/opcode block
    first_block = re.search(r'\b(?:instr|opcode)\b', instr_content, re.IGNORECASE)
    if first_block:
        header_text = instr_content[:first_block.start()].strip()
        if header_text and len(header_text) // 4 >= 20:
            header_info = _extract_header_block(header_text)
            extra = ", ".join(f"{k}={v}" for k, v in header_info.items() if k != "globals")
            prefix = _build_enrichment_prefix("header", source_path, [], [], extra)
            chunks.append(Chunk(
                content=f"{prefix}\n\n{header_text}",
                metadata={
                    "source": source_path,
                    "type": "header",
                    **{k: str(v) for k, v in header_info.items() if k != "globals"},
                },
                chunk_id=f"{source_path}::header",
            ))

    # Instrument chunks
    for instr_id, instr_code in _extract_instruments(instr_content):
        opcodes = detect_opcodes(instr_code)
        techniques = infer_techniques(opcodes)
        prefix = _build_enrichment_prefix(
            f"instrument {instr_id}", source_path, opcodes, techniques,
        )
        chunks.append(Chunk(
            content=f"{prefix}\n\n{instr_code}",
            metadata={
                "source": source_path,
                "type": "instrument",
                "instrument_id": instr_id,
                "opcodes": ",".join(opcodes[:20]),
                "techniques": ",".join(techniques),
            },
            chunk_id=f"{source_path}::instr_{instr_id}",
        ))

    # UDO chunks
    for udo_name, udo_code in _extract_udos(instr_content):
        opcodes = detect_opcodes(udo_code)
        techniques = infer_techniques(opcodes)
        prefix = _build_enrichment_prefix(
            f"UDO {udo_name}", source_path, opcodes, techniques,
        )
        chunks.append(Chunk(
            content=f"{prefix}\n\n{udo_code}",
            metadata={
                "source": source_path,
                "type": "udo",
                "udo_name": udo_name,
                "opcodes": ",".join(opcodes[:20]),
                "techniques": ",".join(techniques),
            },
            chunk_id=f"{source_path}::udo_{udo_name}",
        ))

    # Score chunk
    score_content = _extract_score_section(content)
    if score_content and len(score_content) // 4 >= 20:
        prefix = _build_enrichment_prefix("score section", source_path, [], [])
        chunks.append(Chunk(
            content=f"{prefix}\n\n{score_content}",
            metadata={"source": source_path, "type": "score"},
            chunk_id=f"{source_path}::score",
        ))

        # Function tables as a separate chunk if present
        ftables = _extract_function_tables(score_content)
        if ftables:
            ft_prefix = _build_enrichment_prefix("function tables", source_path, [], [])
            chunks.append(Chunk(
                content=f"{ft_prefix}\n\n{ftables}",
                metadata={"source": source_path, "type": "function_tables"},
                chunk_id=f"{source_path}::ftables",
            ))

    # Fallback: if no chunks were produced, index the whole file
    if not chunks:
        chunks.append(Chunk(
            content=content,
            metadata={"source": source_path, "type": "csound"},
            chunk_id=f"{source_path}::full",
        ))

    return chunks


# ---------------------------------------------------------------------------
# JSONL chunking (instruction/output pairs from training data)
# ---------------------------------------------------------------------------

def chunk_jsonl_entry(
    instruction: str,
    output: str,
    source_path: str,
    entry_idx: int,
) -> Chunk:
    """
    Create a chunk from a JSONL training data entry.

    The instruction is used as an enrichment prefix before the output content.
    """
    opcodes = detect_opcodes(output)
    techniques = infer_techniques(opcodes)

    enrichment = f"Q: {instruction}\n"
    if opcodes:
        enrichment += f"Opcodes: {', '.join(opcodes[:15])}. "
    if techniques:
        technique_labels = [t.replace("_", " ") for t in techniques]
        enrichment += f"Techniques: {', '.join(technique_labels)}."

    content = f"{enrichment}\n\n{output}"

    return Chunk(
        content=content,
        metadata={
            "source": source_path,
            "type": "training_pair",
            "instruction": instruction[:200],
            "opcodes": ",".join(opcodes[:20]),
            "techniques": ",".join(techniques),
        },
        chunk_id=f"{source_path}::entry_{entry_idx}",
    )
