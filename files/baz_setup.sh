#!/usr/bin/env bash

set -e

main() {
    echo 'Setting up baz'
    export PREFIX="${PREFIX:-/usr/bin}"

    echo 'Pre-cleanup'
    rm -rf -- baz

    echo 'Cloning git repository'
    git clone https://ari-web.xyz/gh/baz
    cd baz

    if [ ! -x 'baz' ]; then
        echo 'Making baz executable'
        chmod a+rx baz
    fi

    echo 'Installing baz'
    ${__BASH_RUNAS:-sudo} install -Dm755 baz "$PREFIX"

    echo 'Setting baz up'
    ./baz setup

    [ ! "$yn" ] && read -rp 'Do you want to add lines to bashrc? [y/n] >>> ' yn

    if [ "$yn" = 'y' ]; then
        echo 'Adding lines to bashrc'
        tee -a ~/.bashrc <<EOF
# Load baz
export BAZ_LOADER_ENABLED=true
_baz_loader="$HOME/.local/share/baz/loader.sh"

[ ! -f "\$_baz_loader" ] || source "\$_baz_loader"
EOF
    fi

    echo 'Adding completions'
    bash ./scripts/comp.sh

    echo 'Cleaning up'
    cd ..
    rm -rf -- baz

    echo "Done setting up baz, make sure '$PREFIX' is in \$PATH"
}

main "$@"
