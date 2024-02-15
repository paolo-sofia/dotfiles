#!/usr/bin/env python3

import re
import pathlib
import argparse

parser = argparse.ArgumentParser(
    prog='Koreader highlights cleaner',
    description='Clean Koreader highlights'
)
parser.add_argument("-p", "--path", required=True)

TEMPLATE_PATH = pathlib.Path("~/Nextcloud/Note/Templates/Capitolo Libro.md")
PAGE_PATTERN = r"### Page.*"
NEWLINE_PATTERN = r'\n\s*\n'
GENERATED_PATTERN = r'Generated at.*'

def load_template() -> str:
    with TEMPLATE_PATH.expanduser().open("r") as f:
        return f.read()


def main(path: pathlib.Path) -> None:
    path = path.expanduser()

    with path.open("r") as f:
        lines = f.readlines()

    for i, _ in enumerate(lines):
        lines[i] = re.sub(PAGE_PATTERN, repl='', string=lines[i])
        lines[i] = lines[i].replace('*', '')

    text = "".join(lines)
    text = re.sub(NEWLINE_PATTERN, '\n', text)
    text = re.sub(GENERATED_PATTERN, repl='', string=text)

    text = f"{load_template()}\n{text}"

    with path.open("w") as f:
        f.write(text)


if __name__ == "__main__":
    args = parser.parse_args()
    main(pathlib.Path(args.path))
