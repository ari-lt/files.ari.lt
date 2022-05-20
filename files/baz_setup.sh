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
# Load baz
export BAZ_LOADER_ENABLED=true
_baz_loader="$HOME/.local/share/baz/loader.sh"

[ ! -f "\$_baz_loader" ] || source "\$_baz_loader"
EOF

    echo 'Adding completions'
    bash ./scripts/comp.sh

    echo 'Done'
}

main "$@"
