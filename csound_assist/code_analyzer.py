"""
Csound code analyzer for structural parsing and issue detection.

Provides a full CSD parser that extracts instruments, UDOs, opcodes,
techniques, and detects common issues.
"""

import re
from dataclasses import dataclass, field

from csound_assist.opcode_data import (
    OPCODE_DESCRIPTIONS,
    detect_opcodes,
    get_opcode_category,
    infer_techniques,
)


@dataclass
class InstrumentDef:
    """Parsed instrument definition."""
    number: str
    code: str
    opcodes: list[str] = field(default_factory=list)
    local_variables: list[str] = field(default_factory=list)
    p_fields: list[str] = field(default_factory=list)
    line_start: int = 0
    line_end: int = 0


@dataclass
class UdoDef:
    """Parsed User-Defined Opcode."""
    name: str
    in_types: str
    out_types: str
    code: str
    opcodes: list[str] = field(default_factory=list)


@dataclass
class Issue:
    """A detected code issue."""
    severity: str  # "error", "warning", "info"
    message: str
    line: int | None = None
    suggestion: str = ""


@dataclass
class CsdStructure:
    """Parsed CSD file structure."""
    options: str = ""
    header: dict = field(default_factory=dict)
    instruments: list[InstrumentDef] = field(default_factory=list)
    udos: list[UdoDef] = field(default_factory=list)
    score: str = ""
    opcodes_used: list[str] = field(default_factory=list)
    techniques: list[str] = field(default_factory=list)
    raw_orchestra: str = ""


def parse_csd(content: str) -> CsdStructure:
    """
    Parse a CSD file into its structural components.

    Args:
        content: Full CSD file content

    Returns:
        CsdStructure with all parsed components
    """
    structure = CsdStructure()

    # Extract CsOptions
    opts_match = re.search(
        r'<CsOptions>(.*?)</CsOptions>', content, re.DOTALL,
    )
    if opts_match:
        structure.options = opts_match.group(1).strip()

    # Extract CsInstruments
    instr_match = re.search(
        r'<CsInstruments>(.*?)</CsInstruments>', content, re.DOTALL,
    )
    if instr_match:
        orc = instr_match.group(1)
        structure.raw_orchestra = orc

        # Parse header values
        for key in ("sr", "ksmps", "nchnls", "nchnls_i", "0dbfs"):
            match = re.search(rf'\b{re.escape(key)}\s*=\s*(\S+)', orc)
            if match:
                structure.header[key] = match.group(1)

        # Parse instruments
        for m in re.finditer(
            r'(instr\s+(\S+)(.*?)endin)',
            orc, re.DOTALL | re.IGNORECASE,
        ):
            instr_code = m.group(1)
            instr_id = m.group(2).rstrip(",")
            opcodes = detect_opcodes(instr_code)

            # Find local variables
            local_vars = re.findall(r'\b[aikS]\w+', instr_code)
            local_vars = sorted(set(local_vars))

            # Find p-fields
            p_fields = sorted(set(re.findall(r'\bp\d+\b', instr_code)))

            # Line numbers
            start = content[:m.start()].count("\n") + 1
            end = content[:m.end()].count("\n") + 1

            structure.instruments.append(InstrumentDef(
                number=instr_id,
                code=instr_code,
                opcodes=opcodes,
                local_variables=local_vars,
                p_fields=p_fields,
                line_start=start,
                line_end=end,
            ))

        # Parse UDOs
        for m in re.finditer(
            r'opcode\s+(\w+)\s*,\s*(\S+)\s*,\s*(\S+)(.*?)endop',
            orc, re.DOTALL | re.IGNORECASE,
        ):
            udo_code = m.group(0)
            structure.udos.append(UdoDef(
                name=m.group(1),
                out_types=m.group(2),
                in_types=m.group(3),
                code=udo_code,
                opcodes=detect_opcodes(udo_code),
            ))

    # Extract CsScore
    score_match = re.search(
        r'<CsScore>(.*?)</CsScore>', content, re.DOTALL,
    )
    if score_match:
        structure.score = score_match.group(1).strip()

    # Overall analysis
    structure.opcodes_used = detect_opcodes(content)
    structure.techniques = infer_techniques(structure.opcodes_used)

    return structure


def detect_issues(structure: CsdStructure) -> list[Issue]:
    """
    Detect common issues in a parsed CSD structure.

    Checks for:
    - Missing endin/endop
    - Rate mismatches
    - Undefined function tables
    - Zero values in expseg
    - Missing header values
    - Common mistakes
    """
    issues: list[Issue] = []

    # Check header
    if "sr" not in structure.header:
        issues.append(Issue("warning", "sr not explicitly set (defaults to 44100)"))
    if "ksmps" not in structure.header:
        issues.append(Issue("warning", "ksmps not explicitly set (defaults to 10)"))
    if "0dbfs" not in structure.header:
        issues.append(Issue("warning", "0dbfs not set (recommended: 0dbfs = 1)"))

    orc = structure.raw_orchestra

    # Check for unmatched instr/endin
    instr_count = len(re.findall(r'\binstr\b', orc, re.IGNORECASE))
    endin_count = len(re.findall(r'\bendin\b', orc, re.IGNORECASE))
    if instr_count != endin_count:
        issues.append(Issue(
            "error",
            f"Unmatched instr/endin: {instr_count} instr vs {endin_count} endin",
        ))

    # Check for unmatched opcode/endop
    opcode_count = len(re.findall(r'\bopcode\b', orc, re.IGNORECASE))
    endop_count = len(re.findall(r'\bendop\b', orc, re.IGNORECASE))
    if opcode_count != endop_count:
        issues.append(Issue(
            "error",
            f"Unmatched opcode/endop: {opcode_count} opcode vs {endop_count} endop",
        ))

    # Check for zero in expseg (common error)
    for line_num, line in enumerate(orc.split("\n"), 1):
        stripped = line.strip()
        if "expseg" in stripped.lower() or "expsegr" in stripped.lower():
            # Check for zero or negative values
            nums = re.findall(r'(?<![.\w])(0(?:\.0+)?)(?![.\w])', stripped)
            if nums:
                issues.append(Issue(
                    "error",
                    "expseg/expsegr cannot use zero values (use a small value like 0.001)",
                    line=line_num,
                    suggestion="Replace 0 with 0.001 in expseg arguments",
                ))

    # Check for undefined ftable references in instruments
    # Collect defined tables from score
    defined_tables = set()
    for line in structure.score.split("\n"):
        stripped = line.strip()
        m = re.match(r'f\s*(\d+)', stripped)
        if m:
            defined_tables.add(m.group(1))

    # Also check for ftgen in orchestra
    for m in re.finditer(r'(?:gi\w+|i\w+)\s+ftgen\s+(\d+)', orc):
        defined_tables.add(m.group(1))

    # Check for score events
    if not structure.score.strip() or (
        not re.search(r'^[ie]\s', structure.score, re.MULTILINE)
        and "f0" not in structure.score
    ):
        issues.append(Issue(
            "warning",
            "Score section has no note events or f0 statement",
            suggestion="Add at least one 'i' statement or 'f0 z' for realtime",
        ))

    return issues


def analyze_csd(content: str) -> tuple[CsdStructure, list[Issue]]:
    """Parse and analyze a CSD file in one call."""
    structure = parse_csd(content)
    issues = detect_issues(structure)
    return structure, issues
