#!/usr/bin/env python3

import re
import sys
import argparse
from pathlib import Path

INCLUDE_PATTERN = re.compile(r'!INCLUDE\s+"([^"]+)"')

def process_file(file_path):
    file_path = Path(file_path)
    base_dir = file_path.parent
    text = file_path.read_text()

    def replace(match):
        include_file = base_dir / match.group(1)

        if not include_file.exists():
            raise FileNotFoundError(f"Include file not found: {include_file}")

        return process_file(include_file)

    return INCLUDE_PATTERN.sub(replace, text)


def main():
    parser = argparse.ArgumentParser(description="Simple spec include processor")
    parser.add_argument("input", help="Main spec file")
    parser.add_argument("-o", "--output", help="Output file")

    args = parser.parse_args()

    result = process_file(args.input)

    if args.output:
        Path(args.output).write_text(result)
    else:
        print(result)


if __name__ == "__main__":
    main()