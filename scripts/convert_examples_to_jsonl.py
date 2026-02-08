#!/usr/bin/env python3
"""
Convert Csound score examples to JSONL format for fine-tuning.

This script:
1. Categorizes CSD files by size (line count)
2. Auto-generates instructions from filename and content analysis
3. Converts suitable files to JSONL format

Usage:
    python scripts/convert_examples_to_jsonl.py [--dry-run] [--output-dir PATH]
"""

import argparse
import json
import re
from pathlib import Path
from dataclasses import dataclass, field
from typing import Optional


# Opcode to technique/description mapping
OPCODE_DESCRIPTIONS = {
    # Oscillators
    "oscil": "oscillator",
    "oscili": "interpolating oscillator",
    "oscils": "simple sine oscillator",
    "poscil": "high-precision oscillator",
    "vco": "analog-style oscillator",
    "vco2": "bandlimited oscillator",
    "buzz": "buzz/pulse generator",
    "gbuzz": "generalized buzz generator",

    # FM Synthesis
    "foscil": "FM synthesis",
    "foscili": "interpolating FM synthesis",
    "fmbell": "FM bell synthesis",
    "fmrhode": "FM Rhodes piano",
    "fmwurlie": "FM Wurlitzer piano",
    "fmvoice": "FM voice synthesis",
    "fmpercfl": "FM percussion/flute",
    "fmb3": "FM Hammond B3 organ",
    "crossfm": "cross-coupled FM synthesis",
    "crosspm": "cross-coupled phase modulation",

    # Granular
    "grain": "granular synthesis",
    "grain2": "granular synthesis",
    "grain3": "pitch-synchronous granular synthesis",
    "granule": "advanced granular synthesis",
    "syncgrain": "synchronous granular synthesis",
    "syncloop": "looping granular synthesis",
    "sndwarp": "time-stretching/pitch-shifting",
    "sndwarpst": "stereo time-stretching",
    "partikkel": "advanced granular synthesis",
    "fog": "FOG granular synthesis",

    # Physical Models
    "pluck": "Karplus-Strong plucked string",
    "repluck": "enhanced plucked string",
    "wgpluck": "waveguide plucked string",
    "wgpluck2": "waveguide plucked string",
    "wgbow": "waveguide bowed string",
    "wgbowedbar": "waveguide bowed bar",
    "wgflute": "waveguide flute",
    "wgclar": "waveguide clarinet",
    "wgbrass": "waveguide brass",
    "streson": "string resonator",
    "mode": "modal synthesis",
    "marimba": "marimba physical model",
    "vibes": "vibraphone physical model",
    "barmodel": "bar physical model",
    "prepiano": "prepared piano model",
    "mandol": "mandolin physical model",
    "gogobel": "gourd/bell physical model",

    # Filters
    "moogladder": "Moog ladder filter",
    "moogvcf": "Moog VCF filter",
    "moogvcf2": "Moog VCF filter",
    "lowpass2": "resonant lowpass filter",
    "bqrez": "resonant filter",
    "butterlp": "Butterworth lowpass filter",
    "butterhp": "Butterworth highpass filter",
    "butterbp": "Butterworth bandpass filter",
    "butterbr": "Butterworth band-reject filter",
    "resonx": "resonant filter bank",
    "reson": "resonant filter",
    "areson": "anti-resonant filter",
    "lpf18": "3-pole lowpass filter",
    "tbvcf": "TB-303 style filter",
    "statevar": "state-variable filter",
    "svfilter": "state-variable filter",
    "clfilt": "controllable filter",
    "pareq": "parametric equalizer",
    "eqfil": "equalizer filter",
    "tonex": "tone control filter",
    "atonex": "anti-tone control filter",

    # Effects
    "reverb": "reverb effect",
    "nreverb": "natural reverb",
    "freeverb": "Freeverb reverb",
    "reverbsc": "stereo reverb",
    "reverb2": "stereo reverb",
    "delay": "delay effect",
    "delay1": "one-sample delay",
    "delayr": "delay line read",
    "delayw": "delay line write",
    "vdelay": "variable delay",
    "vdelay3": "interpolating variable delay",
    "vdelayx": "high-quality variable delay",
    "flanger": "flanger effect",
    "chorus": "chorus effect",
    "phaser1": "first-order phaser",
    "phaser2": "second-order phaser",
    "distort": "distortion effect",
    "distort1": "modified distortion",
    "clip": "clipping/distortion",
    "powershape": "waveshaping",
    "pdclip": "phase distortion clipping",
    "pdhalf": "phase distortion",
    "compress": "compressor",
    "compress2": "compressor",
    "dam": "dynamics processor",
    "follow": "envelope follower",
    "follow2": "envelope follower",
    "balance": "amplitude balance",
    "pan2": "stereo panning",
    "pan": "panning",
    "locsig": "spatial localization",
    "locsend": "spatial localization send",
    "hrtfer": "HRTF spatialization",
    "hrtfmove": "HRTF movement",
    "vbap": "vector-base amplitude panning",
    "vbaplsinit": "VBAP initialization",
    "doppler": "doppler effect",
    "hilbert": "Hilbert transform",
    "freqshift": "frequency shifting",
    "ringmod": "ring modulation",

    # FOF/Formant
    "fof": "FOF formant synthesis",
    "fof2": "FOF formant synthesis with glissando",
    "fofx5": "five-formant FOF synthesis",

    # Spectral/FFT
    "pvsanal": "FFT analysis",
    "pvsynth": "FFT resynthesis",
    "pvsadsyn": "FFT additive resynthesis",
    "pvscross": "spectral cross-synthesis",
    "pvsmorph": "spectral morphing",
    "pvsfreeze": "spectral freeze",
    "pvshift": "spectral pitch shifting",
    "pvscale": "spectral scaling",
    "pvsblur": "spectral blurring",
    "pvsmooth": "spectral smoothing",
    "pvsfilter": "spectral filtering",

    # Noise
    "rand": "random noise",
    "randi": "interpolating random",
    "randh": "sample-and-hold random",
    "noise": "white noise",
    "pinkish": "pink noise",
    "dust": "random impulses",
    "gausstrig": "Gaussian trigger",

    # Envelopes
    "linen": "linear envelope",
    "linenr": "linear envelope with release",
    "linseg": "linear segments",
    "linsegr": "linear segments with release",
    "expseg": "exponential segments",
    "expsegr": "exponential segments with release",
    "adsr": "ADSR envelope",
    "madsr": "MIDI ADSR envelope",
    "xadsr": "exponential ADSR",
    "mxadsr": "MIDI exponential ADSR",
    "transeg": "transition segments",

    # Scanned Synthesis
    "scanu": "scanned synthesis",
    "scans": "scanned synthesis",
    "scantable": "scanned synthesis table",

    # Waveguide
    "wguide1": "simple waveguide",
    "wguide2": "dual waveguide",
    "streson": "string resonator",

    # Sample Playback
    "loscil": "looping oscillator/sampler",
    "loscil3": "cubic interpolation sampler",
    "flooper": "function table looper",
    "flooper2": "enhanced looper",
    "sndloop": "sound loop recorder",
    "diskin": "disk streaming",
    "diskin2": "enhanced disk streaming",
    "mp3in": "MP3 playback",

    # Additive
    "adsyn": "additive synthesis",
    "adsynt": "additive synthesis",
    "adsynt2": "additive synthesis",
    "hsboscil": "harmonic synthesis",

    # Analysis
    "pitch": "pitch detection",
    "pitchamdf": "AMDF pitch detection",
    "ptrack": "pitch tracking",
    "plltrack": "PLL pitch tracking",
    "pvspitch": "spectral pitch detection",
    "centroid": "spectral centroid",
    "rms": "RMS amplitude",
    "specptrk": "spectral peak tracking",
}

# Filename keyword to description mapping
FILENAME_KEYWORDS = {
    "fm": "FM synthesis",
    "fmsynth": "FM synthesis",
    "granul": "granular synthesis",
    "grain": "granular synthesis",
    "pluck": "plucked string",
    "string": "string synthesis",
    "bell": "bell sound",
    "organ": "organ sound",
    "piano": "piano sound",
    "pno": "piano sound",
    "bass": "bass sound",
    "pad": "pad sound",
    "lead": "lead sound",
    "synth": "synthesizer",
    "drum": "drum sound",
    "perc": "percussion",
    "kick": "kick drum",
    "snare": "snare drum",
    "hihat": "hi-hat",
    "hat": "hi-hat",
    "clap": "clap sound",
    "noise": "noise generation",
    "filter": "filter processing",
    "reverb": "reverb effect",
    "delay": "delay effect",
    "echo": "echo effect",
    "chorus": "chorus effect",
    "flang": "flanger effect",
    "phas": "phaser effect",
    "distort": "distortion effect",
    "waveshap": "waveshaping",
    "ring": "ring modulation",
    "freq": "frequency",
    "pitch": "pitch",
    "chirp": "frequency sweep/chirp",
    "sweep": "parameter sweep",
    "lfo": "LFO modulation",
    "vibrato": "vibrato effect",
    "tremolo": "tremolo effect",
    "arp": "arpeggio",
    "seq": "sequencer",
    "midi": "MIDI control",
    "vocal": "vocal synthesis",
    "voice": "voice synthesis",
    "vowel": "vowel synthesis",
    "chant": "choral/chant synthesis",
    "fof": "FOF formant synthesis",
    "formant": "formant synthesis",
    "additive": "additive synthesis",
    "subtract": "subtractive synthesis",
    "waveguide": "waveguide synthesis",
    "wg": "waveguide synthesis",
    "physical": "physical modeling",
    "physmod": "physical modeling",
    "modal": "modal synthesis",
    "karplus": "Karplus-Strong synthesis",
    "spectral": "spectral processing",
    "fft": "FFT processing",
    "pvs": "phase vocoder",
    "vocod": "vocoder",
    "morph": "sound morphing",
    "cross": "cross-synthesis",
    "sample": "sample playback",
    "loop": "looping",
    "stretch": "time stretching",
    "space": "spatial audio",
    "pan": "panning",
    "stereo": "stereo processing",
    "surround": "surround sound",
    "ambient": "ambient texture",
    "drone": "drone sound",
    "atmos": "atmospheric sound",
    "fx": "effects processing",
    "effect": "effects processing",
    "test": "test/demonstration",
    "demo": "demonstration",
    "example": "example",
}


@dataclass
class CsdFile:
    """Represents a parsed CSD file."""
    path: Path
    content: str
    line_count: int
    char_count: int
    opcodes_found: list = field(default_factory=list)
    category: str = ""

    @property
    def estimated_tokens(self) -> int:
        return self.char_count // 4

    @property
    def is_suitable_for_finetuning(self) -> bool:
        # Small and medium files are suitable
        # Large files are marginal (review individually)
        return self.line_count <= 150 or (self.line_count <= 300 and self.estimated_tokens <= 2500)


def extract_opcodes(content: str) -> list[str]:
    """Extract Csound opcodes from instrument code."""
    found = []
    content_lower = content.lower()

    for opcode in OPCODE_DESCRIPTIONS:
        # Match opcode as a word (not part of another word)
        pattern = rf'\b{re.escape(opcode)}\b'
        if re.search(pattern, content_lower):
            found.append(opcode)

    return found


def extract_instrument_names(content: str) -> list[str]:
    """Extract instrument names/numbers from the code."""
    # Match instrument definitions with comments
    patterns = [
        r'instr\s+(\d+)\s*;?\s*(.+)?',  # instr 1 ; name
        r';\s*(?:INSTRUMENT|Instrument)\s*:?\s*(.+)',  # ; Instrument: name
        r';\s*[-=]+\s*\n;\s*(.+?)\s*\n;\s*[-=]+',  # Comment block headers
    ]

    names = []
    for pattern in patterns:
        matches = re.findall(pattern, content, re.IGNORECASE)
        for match in matches:
            if isinstance(match, tuple):
                # Get the descriptive part
                name = match[1] if len(match) > 1 and match[1] else match[0]
            else:
                name = match
            if name and len(name) > 2 and len(name) < 50:
                names.append(name.strip())

    return names


def generate_instruction(csd: CsdFile) -> str:
    """Generate a natural language instruction for the CSD file."""
    filename = csd.path.stem.lower()

    # Start with filename-based hints
    hints = []
    for keyword, description in FILENAME_KEYWORDS.items():
        if keyword in filename:
            hints.append(description)

    # Add opcode-based descriptions
    for opcode in csd.opcodes_found[:5]:  # Limit to top 5
        if opcode in OPCODE_DESCRIPTIONS:
            desc = OPCODE_DESCRIPTIONS[opcode]
            if desc not in hints:
                hints.append(desc)

    # Extract instrument names from comments
    instrument_names = extract_instrument_names(csd.content)

    # Build the instruction
    if hints:
        unique_hints = list(dict.fromkeys(hints))[:3]  # Dedupe, limit to 3
        techniques = " and ".join(unique_hints)

        if instrument_names:
            instr_desc = instrument_names[0]
            instruction = f"Write a Csound instrument for {instr_desc} using {techniques}"
        else:
            # Use filename as fallback
            clean_name = re.sub(r'[_\d]+', ' ', filename).strip()
            if clean_name and len(clean_name) > 2:
                instruction = f"Write a Csound instrument that creates a {clean_name} sound using {techniques}"
            else:
                instruction = f"Write a Csound instrument demonstrating {techniques}"
    else:
        # Fallback to generic instruction
        clean_name = re.sub(r'[_\d]+', ' ', filename).strip()
        if clean_name and len(clean_name) > 2:
            instruction = f"Write a Csound instrument that creates a {clean_name} sound"
        else:
            instruction = "Write a Csound instrument"

    return instruction


def categorize_file(line_count: int) -> str:
    """Categorize file by line count."""
    if line_count <= 50:
        return "small"
    elif line_count <= 150:
        return "medium"
    elif line_count <= 500:
        return "large"
    else:
        return "very_large"


def parse_csd_file(path: Path) -> Optional[CsdFile]:
    """Parse a CSD file and extract metadata."""
    try:
        content = path.read_text(encoding='utf-8', errors='replace')
    except Exception as e:
        print(f"Error reading {path}: {e}")
        return None

    lines = content.splitlines()
    line_count = len(lines)
    char_count = len(content)

    opcodes = extract_opcodes(content)
    category = categorize_file(line_count)

    return CsdFile(
        path=path,
        content=content,
        line_count=line_count,
        char_count=char_count,
        opcodes_found=opcodes,
        category=category,
    )


def convert_to_jsonl_entry(csd: CsdFile) -> dict:
    """Convert a CSD file to a JSONL training entry."""
    instruction = generate_instruction(csd)

    return {
        "instruction": instruction,
        "input": "",
        "output": csd.content.strip(),
    }


def main():
    parser = argparse.ArgumentParser(
        description="Convert Csound examples to JSONL for fine-tuning"
    )
    parser.add_argument(
        "--input-dir",
        type=Path,
        default=Path(__file__).parent.parent / "csound_score_examples",
        help="Input directory containing CSD files",
    )
    parser.add_argument(
        "--output-dir",
        type=Path,
        default=Path(__file__).parent.parent / "csound_corpus" / "converted_examples",
        help="Output directory for JSONL files",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without writing files",
    )
    parser.add_argument(
        "--max-tokens",
        type=int,
        default=3000,
        help="Maximum estimated tokens for fine-tuning suitability",
    )
    parser.add_argument(
        "--include-large",
        action="store_true",
        help="Include large files (151-500 lines) in conversion",
    )
    args = parser.parse_args()

    if not args.input_dir.exists():
        print(f"Error: Input directory not found: {args.input_dir}")
        return 1

    # Find all CSD files
    csd_files = list(args.input_dir.glob("*.csd"))
    print(f"Found {len(csd_files)} CSD files in {args.input_dir}")

    # Parse and categorize files
    parsed_files: dict[str, list[CsdFile]] = {
        "small": [],
        "medium": [],
        "large": [],
        "very_large": [],
    }

    skipped_errors = 0

    for path in csd_files:
        csd = parse_csd_file(path)
        if csd:
            parsed_files[csd.category].append(csd)
        else:
            skipped_errors += 1

    # Print statistics
    print("\n" + "=" * 60)
    print("File Categorization Summary")
    print("=" * 60)
    for category, files in parsed_files.items():
        total_tokens = sum(f.estimated_tokens for f in files)
        avg_tokens = total_tokens // len(files) if files else 0
        print(f"  {category:12}: {len(files):4} files, ~{avg_tokens:,} avg tokens")

    if skipped_errors:
        print(f"  Skipped (errors): {skipped_errors}")

    # Determine which files to convert
    files_to_convert = []
    files_to_convert.extend(parsed_files["small"])
    files_to_convert.extend(parsed_files["medium"])

    if args.include_large:
        # Filter large files by token count
        for csd in parsed_files["large"]:
            if csd.estimated_tokens <= args.max_tokens:
                files_to_convert.append(csd)

    print(f"\nFiles suitable for fine-tuning: {len(files_to_convert)}")
    print(f"Files too large (RAG candidates): {len(parsed_files['large']) + len(parsed_files['very_large'])}")

    if args.dry_run:
        print("\n[DRY RUN] Would convert the following files:")
        for csd in files_to_convert[:10]:
            instruction = generate_instruction(csd)
            print(f"  {csd.path.name}: {instruction[:60]}...")
        if len(files_to_convert) > 10:
            print(f"  ... and {len(files_to_convert) - 10} more")
        return 0

    # Create output directory
    args.output_dir.mkdir(parents=True, exist_ok=True)

    # Group files by detected technique for organization
    technique_groups: dict[str, list[CsdFile]] = {}

    for csd in files_to_convert:
        # Determine primary technique
        if csd.opcodes_found:
            primary_opcode = csd.opcodes_found[0]
            if primary_opcode in OPCODE_DESCRIPTIONS:
                technique = OPCODE_DESCRIPTIONS[primary_opcode]
            else:
                technique = "general"
        else:
            technique = "general"

        # Normalize technique name for filename
        technique_key = re.sub(r'[^a-z0-9]+', '-', technique.lower()).strip('-')

        if technique_key not in technique_groups:
            technique_groups[technique_key] = []
        technique_groups[technique_key].append(csd)

    # Write JSONL files by technique group
    print("\n" + "=" * 60)
    print("Writing JSONL Files")
    print("=" * 60)

    total_written = 0
    for technique, files in sorted(technique_groups.items()):
        output_path = args.output_dir / f"{technique}.jsonl"

        entries = []
        for csd in files:
            entry = convert_to_jsonl_entry(csd)
            entries.append(entry)

        with open(output_path, 'w', encoding='utf-8') as f:
            for entry in entries:
                f.write(json.dumps(entry, ensure_ascii=False) + '\n')

        print(f"  {output_path.name}: {len(entries)} entries")
        total_written += len(entries)

    # Also create a combined file
    combined_path = args.output_dir / "_all_examples.jsonl"
    with open(combined_path, 'w', encoding='utf-8') as f:
        for csd in files_to_convert:
            entry = convert_to_jsonl_entry(csd)
            f.write(json.dumps(entry, ensure_ascii=False) + '\n')

    print(f"\n  Combined file: {combined_path.name} ({total_written} entries)")

    # Create a report of files too large for fine-tuning
    large_files = parsed_files["large"] + parsed_files["very_large"]
    if large_files:
        report_path = args.output_dir / "_large_files_for_rag.txt"
        with open(report_path, 'w', encoding='utf-8') as f:
            f.write("# Files too large for fine-tuning\n")
            f.write("# Consider adding these to RAG corpus or chunking into smaller pieces\n\n")
            for csd in sorted(large_files, key=lambda x: x.line_count, reverse=True):
                opcodes_str = ", ".join(csd.opcodes_found[:5]) if csd.opcodes_found else "none detected"
                f.write(f"{csd.path.name}\n")
                f.write(f"  Lines: {csd.line_count}, Tokens: ~{csd.estimated_tokens}\n")
                f.write(f"  Opcodes: {opcodes_str}\n\n")
        print(f"  Large files report: {report_path.name}")

    print("\n" + "=" * 60)
    print("Conversion Complete")
    print("=" * 60)
    print(f"Total entries written: {total_written}")
    print(f"Output directory: {args.output_dir}")

    return 0


if __name__ == "__main__":
    exit(main())
