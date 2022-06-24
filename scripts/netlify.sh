#!/usr/bin/env sh

main() {
    python3 scripts/tree.py
    netlify deploy --prod -d .
}

main "$@"
