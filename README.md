# devcontainer-csound

Containerized environment to run csound.

## TODO

- [ ] fix failed instruments in reders/failed_instruments.txt
- [ ] fix failed instruments in reders/failed_missing_files.txt

## Assume

- requires VSCode Dev Container Extension

## Helper

Installing git credential manager is helpful

## Setup

- scores: contains CSound scores
- analysis: contains pvoc style analysis files
- compositions: contains complete compositions
- instruments: contains individual instruments

## Refs

- <https://code.visualstudio.com/remote/advancedcontainers/sharing-git-credentials>
- <https://docs.github.com/en/get-started/getting-started-with-git/caching-your-github-credentials-in-git>

## CSound References

- The CSound Book
- CSound A Sound and Music Computing System

## Pre-commit Hooks

- This repo ships with a pre-commit config to enforce basic formatting and run Csound syntax checks on `.csd`, `.orc`, and `.sco` files.
- Setup:

```bash
pip install -e .
pre-commit install
pre-commit run --all-files
```

- To treat Csound warnings as errors during commits, set:

```bash
export CSOUND_WARNINGS_AS_ERRORS=1
```

### Format CSD files in scores (dry-run)

python3 scripts/format_csd_indent.py scores

### Apply changes

python3 scripts/format_csd_indent.py --write scores

### Run hooks on all files

pre-commit run --all-files
