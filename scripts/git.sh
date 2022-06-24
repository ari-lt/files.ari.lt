#!/usr/bin/env sh

main() {
    git add .
    git commit -sam "update @ $(date)"
    git push -u origin "$(git rev-parse --abbrev-ref HEAD)"

    ./scripts/netlify.sh
}

main "$@"
