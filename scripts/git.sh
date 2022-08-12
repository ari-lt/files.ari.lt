#!/usr/bin/env sh

set -e

main() {
    git add .
    git commit -sa
    git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

    ./scripts/netlify.sh
}

main "$@"
