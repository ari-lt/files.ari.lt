#!/usr/bin/env sh

set -e

main() {
    export CC=clang CFLAGS='-s -O2 -march=native -pipe'

    ./configure --prefix=/usr --disable-darwin \
        --disable-smack --disable-selinux --disable-xsmp \
        --disable-xsmp-interact --enable-luainterp=dynamic --enable-perlinterp=dynamic \
        --enable-pythoninterp=dynamic --enable-python3interp=dynamic \
        --enable-tclinterp=dynamic --enable-rubyinterp=dynamic \
        --enable-terminal --enable-xim --enable-gui=gtk3 \
        --with-x --enable-pythoninterp=yes --enable-python3interp=yes --with-python-command=python2 \
        --with-python3-command=python3

}

main "$@"
