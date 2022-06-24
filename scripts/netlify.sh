#!/usr/bin/env sh

main() {
    netlify deploy --prod -d .
}

main "$@"
