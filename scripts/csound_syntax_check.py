#!/usr/bin/env python3
import os
import subprocess
import sys


def run_csound_check(path: str) -> tuple[int, str]:
    cmd = [
        "csound",
        "--syntax-check-only",
        "--nosound",
        "--nodisplays",
        "--messagelevel=4",
    ]
    # Use --orc for standalone orchestra files; otherwise Csound expects a CSD
    if path.lower().endswith(".orc"):
        cmd.append("--orc")
    cmd.append(path)
    try:
        proc = subprocess.run(
            cmd,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,
            text=True,
            check=False,
        )
        return proc.returncode, proc.stdout
    except FileNotFoundError:
        return 127, "csound not found on PATH"


def main() -> int:
    warn_as_error = os.getenv("CSOUND_WARNINGS_AS_ERRORS", "0") in {"1", "true", "True"}
    if len(sys.argv) < 2:
        print("No files provided to Csound syntax check.")
        return 0

    exit_code = 0
    for path in sys.argv[1:]:
        rc, out = run_csound_check(path)
        # Csound returns non-zero on syntax errors; warnings still return 0
        has_warning = False
        for line in out.splitlines():
            if "warning" in line.lower():
                has_warning = True
                break

        if rc != 0:
            print(f"Csound syntax errors in: {path}")
            print(out)
            exit_code = 1
        elif has_warning and warn_as_error:
            print(f"Csound warnings treated as errors in: {path}")
            print(out)
            exit_code = 1
        elif has_warning:
            # Show warnings but do not fail (unless CSOUND_WARNINGS_AS_ERRORS is set)
            print(f"Csound warnings in: {path}")
            print(out)
        # Else: clean

    return exit_code


if __name__ == "__main__":
    sys.exit(main())
