#!/usr/bin/env sh

set -e

main() {
    echo 'Setting up baz'

    echo 'Pre-cleanup'
    rm -rf baz

    echo 'Cloning repository'
    git clone https://ari-web.xyz/gh/baz
    cd baz

    echo 'Installing baz'
    ${__BASH_RUNAS:-sudo} install -Dm755 baz /usr/bin

    echo 'Setting baz up'
    baz setup

    echo 'Adding lines to bashrc'
    tee -a ~/.bashrc <<EOF
export BAZ_LOADER_ENABLED=true
[ -f "\$HOME/.local/share/baz/loader.sh" ] && source "\$HOME/.local/share/baz/loader.sh"
EOF

    echo 'Adding completions'
    bash ./scripts/comp.sh

    echo 'Done'
}

main "$@"
