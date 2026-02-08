"""
CSD validation using Csound's syntax checker.

Provides both file-based and text-based validation by running
`csound --syntax-check-only` on CSD content.
"""

import shutil
import subprocess
import tempfile
from pathlib import Path


def _find_csound() -> str | None:
    """Find the csound executable."""
    return shutil.which("csound")


def validate_csd(path: Path | str) -> tuple[bool, str]:
    """
    Validate a CSD file using Csound's syntax checker.

    Args:
        path: Path to the CSD file

    Returns:
        (is_valid, output_message)
    """
    csound = _find_csound()
    if not csound:
        return False, "csound executable not found in PATH"

    path = Path(path)
    if not path.exists():
        return False, f"File not found: {path}"

    try:
        result = subprocess.run(
            [csound, "--syntax-check-only", str(path)],
            capture_output=True,
            text=True,
            timeout=30,
        )
        output = result.stderr or result.stdout or ""
        is_valid = result.returncode == 0
        return is_valid, output.strip()
    except subprocess.TimeoutExpired:
        return False, "Validation timed out (30s)"
    except Exception as e:
        return False, f"Validation error: {e}"


def validate_csd_text(text: str) -> tuple[bool, str]:
    """
    Validate CSD text content using a temporary file.

    Args:
        text: CSD file content

    Returns:
        (is_valid, output_message)
    """
    with tempfile.NamedTemporaryFile(
        suffix=".csd",
        mode="w",
        delete=True,
        encoding="utf-8",
    ) as f:
        f.write(text)
        f.flush()
        return validate_csd(f.name)


def extract_csd_from_response(response: str) -> str | None:
    """
    Extract CSD content from an LLM response.

    Looks for content between ```csound ... ``` or
    <CsoundSynthesizer> ... </CsoundSynthesizer> tags.
    """
    import re

    # Try to find fenced code block
    match = re.search(
        r'```(?:csound|csd)?\s*\n(.*?)```',
        response,
        re.DOTALL,
    )
    if match:
        code = match.group(1).strip()
        if "<CsoundSynthesizer>" in code:
            return code

    # Try to find raw CSD tags
    match = re.search(
        r'(<CsoundSynthesizer>.*?</CsoundSynthesizer>)',
        response,
        re.DOTALL,
    )
    if match:
        return match.group(1).strip()

    return None
