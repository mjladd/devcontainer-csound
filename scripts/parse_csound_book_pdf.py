#!/usr/bin/env python3
"""
Parse a PDF of The Csound Book and convert to corpus-friendly markdown.

Usage:
    python3 parse_csound_book_pdf.py /path/to/csound_book.pdf

Requirements:
    pip install pymupdf

This script extracts text from each page, attempts to identify:
- Chapter boundaries
- Section headings
- Code blocks (Csound orchestra/score code)
- Preserves structure for RAG/corpus use
"""

import sys
import re
import json
import argparse
from pathlib import Path
from datetime import datetime
from typing import Optional

try:
    import fitz  # PyMuPDF
except ImportError:
    print("Error: PyMuPDF is required. Install with:")
    print("  pip install pymupdf")
    print("  # or if pip is not found:")
    print("  uv pip install pymupdf")
    sys.exit(1)


def extract_text_from_pdf(pdf_path: Path) -> list[dict]:
    """Extract text from each page of the PDF."""
    doc = fitz.open(pdf_path)
    pages = []

    for page_num in range(len(doc)):
        page = doc[page_num]
        text = page.get_text()
        pages.append({
            "page": page_num + 1,
            "text": text,
        })

    doc.close()
    return pages


def detect_chapter_start(text: str) -> Optional[tuple[str, str]]:
    """Detect if a page starts a new chapter. Returns (chapter_num, title) or None."""
    # Known authors from The Csound Book to filter from titles
    known_authors = {
        'Richard Boulanger', 'Jon Christopher Nelson', 'John fﬁtch', 'John Ffitch',
        'Paris Smaragdis', 'Stephen David Beck', 'Richard W. Dobson', 'Michael Gogins',
        'Russell Pinkston', 'Allan S. C. Lee', 'Michael Clarke', 'Per Byrne Villez',
        'Rajmil Fischman', 'R. Erik Spjut', 'Eric Lyon', 'Hans Mikelson',
        'Marc Resibois', 'Elijah Breder', 'David McIntyre', 'Gabriel Maldonado',
        'Matt Ingalls', 'Richard Karpen', 'Barry Vercoe', 'Max Mathews',
        # Authors from Csound: A Sound and Music Computing System
        'Victor Lazzarini', 'Steven Yi', 'Joachim Heintz', 'Øyvind Brandtsegg',
        'Iain McCurdy',
    }

    lines = text.split('\n')
    if len(lines) < 3:
        return None

    first_line = lines[0].strip()

    # Format 1: "Chapter X" on first line (Csound Computing System book)
    chapter_match = re.match(r'^Chapter\s+(\d+)$', first_line)
    if chapter_match:
        chapter_num = int(chapter_match.group(1))
        if 1 <= chapter_num <= 40:
            # Title is on the next line
            title = lines[1].strip() if len(lines) > 1 else ""
            if title and len(title) > 3 and title[0].isupper():
                return (str(chapter_num), title)

    # Format 2: Just a number on first line (The Csound Book)
    if not re.match(r'^(\d{1,2})$', first_line):
        return None

    chapter_num = int(first_line)
    if chapter_num < 1 or chapter_num > 40:
        return None

    # Check if this is actually a page number, not a chapter number
    # Page numbers are followed by chapter headers like "2 Key System Concepts"
    if len(lines) > 1:
        second_line = lines[1].strip()
        # If second line looks like "N Chapter Title" it's a page number header
        if re.match(r'^\d+\s+[A-Z]', second_line):
            return None

    # Build title from subsequent lines until we hit an author name or content
    title_lines = []

    for i, line in enumerate(lines[1:8], start=1):  # Check next 7 lines
        line = line.strip()
        if not line:
            continue

        # Check if this is a known author
        is_known_author = any(author in line for author in known_authors)

        # Words that appear in titles but not in author names
        title_words = {
            'csound', 'synthesis', 'techniques', 'processing', 'design', 'instruments',
            'data', 'types', 'extending', 'introduction', 'understanding', 'using',
            'modeling', 'implementing', 'working', 'applications', 'extensions',
            'traditional', 'novel', 'classic', 'spectral', 'auditory', 'localization',
            'convolution', 'waveshaping', 'multieffects', 'processor', 'generator',
            'generators', 'signal', 'reverberation', 'delay', 'lines', 'chaos',
            'random', 'numbers', 'noise', 'global', 'meta', 'parameter', 'control',
            'waveguides', 'mathematical', 'morphing', 'percussion', 'brass', 'horn',
            'keyboard', 'electronic', 'wavetable', 'contiguous', 'group', 'legato',
            'viable', 'acoustically', 'macro', 'language', 'function', 'table', 'gen',
            'routines', 'program', 'optimizing', 'survey', 'granular', 'fof', 'fog',
            'samples', 'opcode', 'opcodes', 'adsyn', 'lpread', 'lpreson', 'phase',
            'vocoder', 'analog', 'efficient', 'unit', 'adding', 'new', 'retriggering',
            'constrained', 'event', 'generation', 'french',
        }

        # Check if line contains title-like words (not an author name)
        line_lower_words = set(line.lower().split())
        has_title_words = bool(line_lower_words & title_words)

        # Author patterns: various name formats (must be the whole line)
        # Only use this if it doesn't contain title words
        is_author_pattern = False
        if not has_title_words:
            is_author_pattern = bool(re.match(
                r'^(?:[A-Z]\. )?[A-Z][a-zﬁ]+ (?:[A-Z]\. )?(?:[A-Z]\. )?[A-Z][a-z]+(?:\s+(?:and|,)\s+(?:[A-Z]\. )?[A-Z][a-z]+ (?:[A-Z]\. )?[A-Z][a-z]+)*$',
                line
            ))

        is_author = is_known_author or is_author_pattern

        # Content starts with longer text that looks like a paragraph
        is_content = len(line) > 70 and not line.isupper()

        if is_author:
            break
        elif is_content:
            break
        elif len(line) > 3 and len(line) < 60:
            # Title lines are usually shorter (< 60 chars)
            # First title line must start with uppercase
            # Continuation lines can start with lowercase (e.g., "a Csound Program")
            if len(title_lines) == 0:
                if line[0].isupper():
                    title_lines.append(line)
            else:
                # Continuation line - can start with lowercase
                # But skip if it looks like content (long line, or starts specific ways)
                if not line[0].isdigit():
                    title_lines.append(line)

    if not title_lines:
        return None

    # Join multi-line titles
    title = ' '.join(title_lines)

    # Clean up title - remove line break artifacts
    title = re.sub(r'\s+', ' ', title).strip()

    # Remove any trailing author names that snuck in
    for author in known_authors:
        if title.endswith(author):
            title = title[:-len(author)].strip()
        if title.endswith(author.replace('ﬁ', 'fi')):  # Handle ligature variants
            title = title[:-len(author)].strip()

    # Validate title - at least 2 words
    if len(title.split()) < 2:
        return None

    return (first_line, title)


def detect_section_headings(text: str) -> list[tuple[int, str]]:
    """Detect section headings within text."""
    headings = []

    # Look for numbered sections like "3.1 Title" or "3.1.2 Title"
    pattern = r"^(\d+(?:\.\d+)*)\s+([A-Z][A-Za-z\s]+?)(?:\n|$)"
    for match in re.finditer(pattern, text, re.MULTILINE):
        level = match.group(1).count(".") + 2  # h2, h3, h4...
        title = match.group(2).strip()
        headings.append((level, f"{match.group(1)} {title}"))

    return headings


def identify_code_blocks(text: str) -> str:
    """Attempt to identify and mark Csound code blocks."""
    result = text

    # Patterns that suggest Csound code
    code_indicators = [
        r"(instr\s+\d+.*?endin)",  # Instrument definitions
        r"(<CsoundSynthesizer>.*?</CsoundSynthesizer>)",  # Full CSD
        r"(sr\s*=\s*\d+.*?(?:endin|</CsScore>))",  # Orchestra snippets
        r"(f\d+\s+\d+\s+\d+\s+\d+.*?)(?:\n\n|\n[A-Z])",  # Function tables
        r"(i\d+\s+[\d.]+\s+[\d.]+.*?)(?:\n\n|\n[A-Z])",  # Score lines
    ]

    # This is a simplified approach - real implementation would need more context
    for pattern in code_indicators:
        matches = re.finditer(pattern, result, re.DOTALL | re.IGNORECASE)
        for match in matches:
            code = match.group(1)
            # Only wrap if it looks like actual code (has newlines, semicolons, etc.)
            if "\n" in code or ";" in code:
                wrapped = f"\n```csound\n{code}\n```\n"
                result = result.replace(code, wrapped, 1)

    return result


def clean_text(text: str) -> str:
    """Clean up extracted text."""
    # Remove excessive whitespace
    text = re.sub(r"\n{3,}", "\n\n", text)
    # Remove page numbers that appear alone
    text = re.sub(r"^\d+\s*$", "", text, flags=re.MULTILINE)
    # Fix common OCR/extraction issues
    text = re.sub(r"(?<=[a-z])-\n(?=[a-z])", "", text)  # Hyphenated line breaks
    return text.strip()


def process_pages(pages: list[dict]) -> list[dict]:
    """Process pages into chapters."""
    chapters = []
    current_chapter = None
    current_content = []

    for page_data in pages:
        text = page_data["text"]
        page_num = page_data["page"]

        # Check for new chapter
        chapter_info = detect_chapter_start(text)

        if chapter_info:
            # Save previous chapter if exists
            if current_chapter:
                current_chapter["content"] = "\n\n".join(current_content)
                current_chapter["end_page"] = page_num - 1
                chapters.append(current_chapter)

            # Start new chapter
            current_chapter = {
                "number": chapter_info[0],
                "title": chapter_info[1],
                "start_page": page_num,
                "end_page": None,
            }
            current_content = [text]
        elif current_chapter:
            current_content.append(text)
        else:
            # Before first chapter (front matter)
            if not chapters or chapters[0].get("number") != "0":
                chapters.insert(0, {
                    "number": "0",
                    "title": "Front Matter",
                    "start_page": 1,
                    "end_page": page_num,
                    "content": text,
                })
            else:
                chapters[0]["content"] += "\n\n" + text
                chapters[0]["end_page"] = page_num

    # Don't forget the last chapter
    if current_chapter:
        current_chapter["content"] = "\n\n".join(current_content)
        current_chapter["end_page"] = pages[-1]["page"]
        chapters.append(current_chapter)

    return chapters


def chapter_to_markdown(chapter: dict, source_name: str = "Csound Book") -> str:
    """Convert a chapter to markdown format."""
    content = clean_text(chapter.get("content", ""))
    content = identify_code_blocks(content)

    md = f"""---
source: {source_name}
chapter: {chapter['number']}
title: "{chapter['title']}"
pages: {chapter['start_page']}-{chapter['end_page']}
type: book_chapter
license: Educational/Fair Use - Do Not Redistribute
---

# Chapter {chapter['number']}: {chapter['title']}

{content}
"""
    return md


def create_index(output_dir: Path, chapters: list[dict], pdf_name: str) -> None:
    """Create index file."""
    # Generate a title from the PDF name
    title = pdf_name.replace('.pdf', '').replace('_', ' ')

    index_content = f"""# {title} - Corpus Index

**Source PDF:** {pdf_name}
**Processed:** {datetime.now().strftime("%Y-%m-%d")}
**Total Chapters:** {len(chapters)}
**License:** Educational/Fair Use - Do Not Redistribute

## About

This corpus was extracted from {title}.
This material is for personal/educational use only and should not be redistributed.

## Chapters

| Chapter | Title | Pages |
|---------|-------|-------|
"""
    for ch in chapters:
        index_content += f"| {ch['number']} | [{ch['title']}](chapter_{ch['number']:0>2}.md) | {ch['start_page']}-{ch['end_page']} |\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")

    # JSON index
    index_data = [{
        "number": ch["number"],
        "title": ch["title"],
        "pages": f"{ch['start_page']}-{ch['end_page']}",
        "file": f"chapter_{ch['number']:0>2}.md",
    } for ch in chapters]
    (output_dir / "index.json").write_text(json.dumps(index_data, indent=2), encoding="utf-8")


def main():
    parser = argparse.ArgumentParser(
        description="Parse The Csound Book PDF into corpus-friendly markdown"
    )
    parser.add_argument("pdf_path", help="Path to the PDF file")
    parser.add_argument(
        "-o", "--output",
        help="Output directory (default: corpus/csound_book_pdf)",
        default=None
    )
    args = parser.parse_args()

    pdf_path = Path(args.pdf_path)
    if not pdf_path.exists():
        print(f"Error: PDF file not found: {pdf_path}")
        return 1

    # Determine output directory
    if args.output:
        output_dir = Path(args.output)
    else:
        script_dir = Path(__file__).parent
        project_root = script_dir.parent
        output_dir = project_root / "corpus" / "csound_book_pdf"

    print(f"=== Csound Book PDF Parser ===")
    print(f"Input: {pdf_path}")
    print(f"Output: {output_dir}")
    print()

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Extract text from PDF
    print("Extracting text from PDF...")
    pages = extract_text_from_pdf(pdf_path)
    print(f"  Extracted {len(pages)} pages")

    # Process into chapters
    print("Processing chapters...")
    chapters = process_pages(pages)
    print(f"  Found {len(chapters)} chapters")

    # Write chapter files
    print("Writing markdown files...")
    source_name = pdf_path.stem.replace('_', ' ')  # Use PDF filename as source
    for chapter in chapters:
        num = chapter["number"]
        filename = f"chapter_{num:0>2}.md" if num != "0" else "chapter_00_front_matter.md"
        filepath = output_dir / filename

        md_content = chapter_to_markdown(chapter, source_name)
        filepath.write_text(md_content, encoding="utf-8")
        print(f"  {filename}: {chapter['title']}")

    # Create index
    print("Creating index...")
    create_index(output_dir, chapters, pdf_path.name)

    print()
    print("=== Complete ===")
    print(f"Processed {len(chapters)} chapters from {len(pages)} pages")
    print(f"Output directory: {output_dir}")
    print()
    print("Note: Review the output for formatting issues.")
    print("Code block detection is heuristic and may need manual cleanup.")

    return 0


if __name__ == "__main__":
    sys.exit(main())
