#!/usr/bin/env python3
"""
Improve JSONL instructions using an LLM.

This script reads JSONL files with Csound training examples and uses an LLM
to generate better, more descriptive instructions based on the code content.

Usage:
    python scripts/improve_instructions_llm.py [--input FILE] [--output FILE] [--model MODEL]

Requires:
    - Ollama running locally with a model available
    - Or: Set OPENAI_API_KEY for OpenAI API
"""

import argparse
import json
import re
import sys
import time
from pathlib import Path
from typing import Optional

try:
    import ollama
    HAS_OLLAMA = True
except ImportError:
    HAS_OLLAMA = False

try:
    import openai
    HAS_OPENAI = True
except ImportError:
    HAS_OPENAI = False


SYSTEM_PROMPT = """You are an expert Csound programmer. Your task is to generate clear, descriptive instructions for Csound code examples.

Given a Csound instrument/score, write a concise instruction that describes what the code does. The instruction should:
1. Start with "Write a Csound instrument that..." or similar
2. Describe the main synthesis technique or effect
3. Mention key features (e.g., "with ADSR envelope", "using FM synthesis")
4. Be 1-2 sentences, under 100 words
5. Be specific enough that someone could implement it from the instruction

Examples of good instructions:
- "Write a Csound instrument that generates a bell sound using FM synthesis with an inharmonic carrier-to-modulator ratio and exponential amplitude decay"
- "Write a Csound instrument that implements a resonant lowpass filter with cutoff frequency controlled by an LFO"
- "Write a Csound instrument for granular time-stretching of a sound file using syncgrain with variable grain density"

Do NOT:
- Include implementation details like variable names or specific values
- Say "this code does X" - write it as an instruction/request
- Be vague like "Write a Csound instrument" without describing what it does
"""


def extract_code_summary(code: str, max_chars: int = 2000) -> str:
    """Extract a summary of the code for the LLM prompt."""
    # Focus on the instrument section
    instr_match = re.search(r'<CsInstruments>(.*?)</CsInstruments>', code, re.DOTALL)
    if instr_match:
        instr_code = instr_match.group(1)
    else:
        instr_code = code

    # Truncate if too long
    if len(instr_code) > max_chars:
        instr_code = instr_code[:max_chars] + "\n... [truncated]"

    return instr_code


def improve_instruction_ollama(code: str, original_instruction: str, model: str = "llama3.2") -> Optional[str]:
    """Use Ollama to generate a better instruction."""
    if not HAS_OLLAMA:
        return None

    code_summary = extract_code_summary(code)

    prompt = f"""Here is a Csound code example:

```csound
{code_summary}
```

The current instruction is: "{original_instruction}"

Generate a better, more descriptive instruction for this code. Respond with ONLY the new instruction, nothing else."""

    try:
        response = ollama.chat(
            model=model,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt},
            ],
            options={"temperature": 0.3},
        )
        return response["message"]["content"].strip().strip('"')
    except Exception as e:
        print(f"  Ollama error: {e}", file=sys.stderr)
        return None


def improve_instruction_openai(code: str, original_instruction: str, model: str = "gpt-4o-mini") -> Optional[str]:
    """Use OpenAI API to generate a better instruction."""
    if not HAS_OPENAI:
        return None

    import os
    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        return None

    client = openai.OpenAI(api_key=api_key)
    code_summary = extract_code_summary(code)

    prompt = f"""Here is a Csound code example:

```csound
{code_summary}
```

The current instruction is: "{original_instruction}"

Generate a better, more descriptive instruction for this code. Respond with ONLY the new instruction, nothing else."""

    try:
        response = client.chat.completions.create(
            model=model,
            messages=[
                {"role": "system", "content": SYSTEM_PROMPT},
                {"role": "user", "content": prompt},
            ],
            temperature=0.3,
            max_tokens=150,
        )
        return response.choices[0].message.content.strip().strip('"')
    except Exception as e:
        print(f"  OpenAI error: {e}", file=sys.stderr)
        return None


def process_jsonl_file(
    input_path: Path,
    output_path: Path,
    backend: str = "ollama",
    model: str = "llama3.2",
    limit: Optional[int] = None,
    skip_existing: bool = True,
) -> dict:
    """Process a JSONL file and improve instructions."""
    stats = {"processed": 0, "improved": 0, "skipped": 0, "errors": 0}

    # Load existing output if resuming
    existing = {}
    if skip_existing and output_path.exists():
        with open(output_path, 'r', encoding='utf-8') as f:
            for line in f:
                entry = json.loads(line)
                # Use first 100 chars of output as key
                key = entry.get("output", "")[:100]
                existing[key] = entry
        print(f"Loaded {len(existing)} existing entries from {output_path}")

    # Read input
    entries = []
    with open(input_path, 'r', encoding='utf-8') as f:
        for line in f:
            entries.append(json.loads(line))

    if limit:
        entries = entries[:limit]

    print(f"Processing {len(entries)} entries...")

    # Process entries
    improved_entries = []
    for i, entry in enumerate(entries):
        output_key = entry.get("output", "")[:100]

        # Skip if already processed
        if output_key in existing:
            improved_entries.append(existing[output_key])
            stats["skipped"] += 1
            continue

        original_instruction = entry.get("instruction", "")
        code = entry.get("output", "")

        # Improve instruction
        if backend == "ollama":
            new_instruction = improve_instruction_ollama(code, original_instruction, model)
        elif backend == "openai":
            new_instruction = improve_instruction_openai(code, original_instruction, model)
        else:
            new_instruction = None

        if new_instruction:
            entry["instruction"] = new_instruction
            entry["original_instruction"] = original_instruction
            stats["improved"] += 1
        else:
            stats["errors"] += 1

        improved_entries.append(entry)
        stats["processed"] += 1

        # Progress update
        if (i + 1) % 10 == 0:
            print(f"  Processed {i + 1}/{len(entries)} entries...")

        # Rate limiting
        time.sleep(0.1)

    # Write output
    with open(output_path, 'w', encoding='utf-8') as f:
        for entry in improved_entries:
            f.write(json.dumps(entry, ensure_ascii=False) + '\n')

    return stats


def main():
    parser = argparse.ArgumentParser(
        description="Improve JSONL instructions using an LLM"
    )
    parser.add_argument(
        "--input",
        type=Path,
        default=Path(__file__).parent.parent / "csound_corpus" / "converted_examples" / "_all_examples.jsonl",
        help="Input JSONL file",
    )
    parser.add_argument(
        "--output",
        type=Path,
        help="Output JSONL file (default: input with _improved suffix)",
    )
    parser.add_argument(
        "--backend",
        choices=["ollama", "openai"],
        default="ollama",
        help="LLM backend to use",
    )
    parser.add_argument(
        "--model",
        default="llama3.2",
        help="Model name (default: llama3.2 for Ollama, gpt-4o-mini for OpenAI)",
    )
    parser.add_argument(
        "--limit",
        type=int,
        help="Limit number of entries to process (for testing)",
    )
    parser.add_argument(
        "--no-resume",
        action="store_true",
        help="Don't skip already processed entries",
    )
    args = parser.parse_args()

    if not args.input.exists():
        print(f"Error: Input file not found: {args.input}")
        return 1

    if args.output is None:
        args.output = args.input.with_stem(args.input.stem + "_improved")

    # Check backend availability
    if args.backend == "ollama" and not HAS_OLLAMA:
        print("Error: ollama package not installed. Run: pip install ollama")
        return 1
    if args.backend == "openai" and not HAS_OPENAI:
        print("Error: openai package not installed. Run: pip install openai")
        return 1

    print("=" * 60)
    print("Improve JSONL Instructions with LLM")
    print("=" * 60)
    print(f"Input:   {args.input}")
    print(f"Output:  {args.output}")
    print(f"Backend: {args.backend}")
    print(f"Model:   {args.model}")
    if args.limit:
        print(f"Limit:   {args.limit}")
    print()

    # Test backend connectivity
    if args.backend == "ollama":
        try:
            ollama.list()
            print("Ollama connection: OK")
        except Exception as e:
            print(f"Error: Cannot connect to Ollama: {e}")
            print("Make sure Ollama is running: ollama serve")
            return 1

    stats = process_jsonl_file(
        args.input,
        args.output,
        backend=args.backend,
        model=args.model,
        limit=args.limit,
        skip_existing=not args.no_resume,
    )

    print()
    print("=" * 60)
    print("Results")
    print("=" * 60)
    print(f"Processed: {stats['processed']}")
    print(f"Improved:  {stats['improved']}")
    print(f"Skipped:   {stats['skipped']}")
    print(f"Errors:    {stats['errors']}")
    print(f"Output:    {args.output}")

    return 0


if __name__ == "__main__":
    exit(main())
