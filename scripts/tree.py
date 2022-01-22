#!/usr/bin/env python3
"""Generate an HTML tree of all files
"""

import os
import sys
import warnings

warnings.filterwarnings("error", category=Warning)

IGNORE_FILES: tuple[str] = ("netlify.toml",)

INDEX_TEMPLATE: str = f"""
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Ari::ari -> files</title>
    </head>

    <body>
        <h1>Ari web file index</h1>
        <i>Ignored files: {', '.join(IGNORE_FILES)}</i>
        <hr/>
        %s
    </body>
</html>
"""


def generate_tree(path: str, html: str = "") -> str:
    """Generate a tree in HTML of files in specified path

    Parameters
    ----------
    path (str): The path
    html (str): Starting HTML

    Returns
    -------
    str:The HTML tree
    """

    for file in os.listdir(path):
        if file.startswith(".") or file in IGNORE_FILES:
            continue

        rel = path + "/" + file

        if os.path.isdir(rel):
            html += f"<li>{file}/</li><ul>"
            html += generate_tree(rel)
            html += "</ul>"
        else:
            html += f"<li><a href='{rel}'>{file}</a></li>"

    return html


def main() -> int:
    """Entry/main function"""

    with open("index.html", "w", encoding="utf-8") as index:
        index.write(INDEX_TEMPLATE % (generate_tree(".")))

    return 0


if __name__ == "__main__":
    assert main.__annotations__.get("return") is int, "main() should return an integer"
    sys.exit(main())
