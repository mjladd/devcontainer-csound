#!/usr/bin/env python3
import argparse
import os
import re
from typing import List, Tuple

def find_csd_files(paths: List[str]) -> List[str]:
    files = []
    for p in paths:
        if os.path.isdir(p):
            for root, _, filenames in os.walk(p):
                for fn in filenames:
                    if fn.lower().endswith('.csd'):
                        files.append(os.path.join(root, fn))
        elif os.path.isfile(p) and p.lower().endswith('.csd'):
            files.append(p)
    return sorted(files)

def fix_line_indent(line: str, indent_size: int = 4) -> str:
    # Preserve newline
    newline = ''
    if line.endswith('\r\n'):
        newline = '\n'
        line = line[:-2]
    elif line.endswith('\n'):
        newline = '\n'
        line = line[:-1]
    elif line.endswith('\r'):
        newline = '\n'
        line = line[:-1]

    # Normalize any leading whitespace (spaces/tabs) to spaces
    m = re.match(r'^([ \t]*)', line)
    leading_ws = m.group(1)
    normalized_leading = []
    for ch in leading_ws:
        if ch == '\t':
            normalized_leading.append(' ' * indent_size)
        else:
            normalized_leading.append(' ')
    leading_spaces = ''.join(normalized_leading)
    line = leading_spaces + line[len(leading_ws):]
    count = len(leading_spaces)

    # Normalize to multiple of indent_size by rounding down
    if count % indent_size != 0:
        new_count = count - (count % indent_size)
        line = (' ' * new_count) + line[count:]

    # Trim trailing whitespace (spaces/tabs)
    line = line.rstrip(' \t')

    return line + newline

def process_file(path: str, write: bool) -> Tuple[int, int]:
    try:
        with open(path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except UnicodeDecodeError:
        with open(path, 'r', encoding='latin-1') as f:
            lines = f.readlines()

    changed = 0
    new_lines = []
    for line in lines:
        fixed = fix_line_indent(line)
        if fixed != line:
            changed += 1
        new_lines.append(fixed)

    if write and changed:
        with open(path, 'w', encoding='utf-8', newline='\n') as f:
            f.writelines(new_lines)

    return changed, len(lines)


def main():
    parser = argparse.ArgumentParser(description='Format Csound .csd indentation to 4-space multiples and replace leading tabs.')
    parser.add_argument('paths', nargs='*', default=['scores'], help='Files or directories to process (default: scores)')
    parser.add_argument('--write', action='store_true', help='Apply changes to files (default: dry-run)')
    args = parser.parse_args()

    files = find_csd_files(args.paths)
    if not files:
        print('No .csd files found in given paths.')
        return

    total_changed = 0
    total_files = 0
    for path in files:
        changed, _ = process_file(path, args.write)
        total_files += 1
        if changed:
            total_changed += 1
            print(f'Formatted: {path} ({changed} lines changed)')

    print(f'Processed {total_files} .csd files; formatted {total_changed}.')
    if not args.write:
        print('Dry-run complete. Re-run with --write to apply changes.')

if __name__ == '__main__':
    main()
