#!/usr/bin/env python3
"""Generate an HTML tree of all files
"""

import hashlib
import json
import os
import sys
import warnings
from subprocess import check_output as check_cmd_output
from typing import List, Tuple

warnings.filterwarnings("error", category=Warning)

IGNORE_FILES: Tuple[str] = ("netlify.toml",)

INDEX_TEMPLATE: str = f"""<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <meta name="description" content="Ari-web file hosting index">
        <meta name="keywords" content="website, webdev, linux, programming, ari, opensource, free, cdn, file, files, file-hosting, file_hosting, git, github">
        <meta name="robots" content="follow, index, max-snippet:-1, max-video-preview:-1, max-image-preview:large, noimageindex"/>

        <title>Ari::ari -> Files</title>

        <link rel="stylesheet" href="//cdn.jsdelivr.net/npm/hack-font@3/build/web/hack.min.css">
        <link rel="manifest" href="/manifest.json" />

        <meta name="color-scheme" content="dark">

        <style>
            :root {{ color-scheme: dark; }}
            * {{ background-color: #262220; color: #f9f6e8; font-family: Hack, hack, monospace, sans, opensans, sans-serif; }}
            body {{ padding: 2rem; max-width: 1100px; margin: auto; }}
            h1 {{ text-align: center; margin: 1em; }}
            li {{ margin: 0.5em; }}
            a {{ text-decoration: none; text-shadow: 0px 0px 6px white; }}
        </style>
    </head>

    <body>
        <article>
            <h1><a href='https://ari-web.xyz/'>Ari-web</a> file hosting index</h1>

            <header>
                <nav>
                    <p align='center'>
                        <i>Ignored files: {', '.join(IGNORE_FILES)} \
| Last built at {check_cmd_output('date').decode()} \
| <a href='/git'>source code</a> | <b>*download</b></i>
                    </p>
                    <hr/>
                <nav>
            </header>

            <main>
                %s
            </main>
        </article>
    </body>
</html>"""


def generate_tree(path: str, html: str = "") -> Tuple[str, List[str]]:
    """Generate a tree in HTML of files in specified path

    Parameters
    ----------
    path (str): The path
    html (str): Starting HTML

    Returns
    -------
    html (str): The HTML tree
    files l(ist[str]): List of all files
    """

    files: List[str] = []

    for file in os.listdir(path):
        if file.startswith(".") or file in IGNORE_FILES:
            continue

        rel = path + "/" + file

        if os.path.isdir(rel):
            html += f"<li>{file}/</li><ul>"
            _generated: Tuple[str, List[str]] = generate_tree(rel)
            files.extend(_generated[1])
            html += _generated[0]
            html += "</ul>"
        else:
            files.append(rel.removeprefix("./"))
            html += f'<li><a href="{rel}">{file}</a> [<a href="{rel}" download>*{file}</a>]</li>'

    return html, files


def main() -> int:
    """Entry/main function"""

    generated_tree: Tuple[str, List[str]] = generate_tree(".")

    with open("index.html", "w", encoding="utf-8") as index:
        index.write(INDEX_TEMPLATE % (generated_tree[0]))

    with open("files.json", "w") as api_json:
        json.dump(generated_tree[1], api_json)

    with open("files.json", "rb") as api_json:
        with open("files_hash.txt", "w") as api_hash:
            api_hash.write(hashlib.sha256(api_json.read()).hexdigest())

    return 0


if __name__ == "__main__":
    assert main.__annotations__.get("return") is int, "main() should return an integer"
    sys.exit(main())
