#!/usr/bin/env sh

set -e

s() { ${__BASH_RUNAS:-sudo} "$@"; }

main() {
    # baz

    s apt install git -yqq
    rm -f baz_setup.sh
    wget 'https://files.ari-web.xyz/files/baz_setup.sh'
    yn=y bash baz_setup.sh

    # Baz plugins

    s apt install python3-pip -yqq
    wget 'https://files.ari-web.xyz/files/cvm_baz.sh'
    sh cvm_baz.sh

    # Furryfox

    tee firefox.sh <<EOF
apt purge snapd -yqq
apt-mark hold snapd
add-apt-repository -y ppa:mozillateam/ppa
echo -ne 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' >>/etc/apt/preferences.d/mozilla-firefox
echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:\${distro_codename}";' >>/etc/apt/apt.conf.d/51unattended-upgrades-firefox
apt install firefox -yqq
EOF
    s bash firefox.sh

    # Links

    tee ln.sh <<EOF
d(){ rm -rf /root/"\$1"&&ln -s /home/dartz/"\$1" /root/"\$1"; }
d .local
d .bashrc
d .config
d .vim
EOF
    s bash ln.sh

    # Vim

    tee vim.sh <<EOF
rm -rf vim
apt purge vim vim-runtime -yqq
apt install cargo nodejs npm clang gcc ccls python3 python3-pip ruby tcl xorg-dev lua5.4 liblua5.4-dev binutils perl shfmt -yqq
git clone https://github.com/vim/vim
cd vim
wget https://files.ari-web.xyz/files/compile_vim.sh
sh compile_vim.sh
make install
EOF

    s bash vim.sh

    # Dotfiles and vim

    git clone https://ari-web.xyz/dotfiles

    rm -rf ~/.vim ~/.vimrc
    cp -r dotfiles/dotfiles/editors/vim ~/.vim
    cp -r dotfiles/dotfiles/config/* ~/.config

    # Vim packages

    sed '/colorscheme/d' -i "$HOME/.vim/vimrc"
    vim +PlugUpgrade +PlugUpdate +CocUpdate +qa
    echo 'colorscheme coffee' >>"$HOME/.vim/vimrc"

    # Tmux

    s apt install tmux -yqq

    tee -a head.sh <<EOF
if [ ! "\$TMUX" ] && [ "\$TERM" != 'linux' ]; then
    tmux -2 -l
    exit 127
fi
export EDITOR=vim
export __BASH_RUNAS=kos

sudo() {
    echo 'Use kos:'
    echo "kos \$@"
}
EOF

    # Misc

    s apt purge update-notifier-common muon -yqq

    # Kos

    tee kos.sh <<EOF
groupadd kos
usermod -aG kos dartz
export SUDO_FORCE_REMOVE=yes
a(){ apt -yqq "\$@"; }
a update --fix-missing -yqq
a purge sudo -yqq
a -yqq install clang pkgconf
rm -rf kos
git clone 'https://ari-web.xyz/gh/kos'
cd kos
sed '/HAVE_ARG/d; /HAVE_PIPE/d' -i src/config.h
INSTALL_BCOMP=1 INSTALL_MAN=1 USER=root ./scripts/setup.sh
a autopurge -yqq
exit 0
EOF
    s bash kos.sh

    # Bashrc

    sed '1s/^/source \~\/head.sh\n/' -i "$HOME/.bashrc"
}

main "$@"
