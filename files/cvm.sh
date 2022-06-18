#!/usr/bin/env sh

set -e

alias s='${__BASH_RUNAS:-sudo}'

main() {
    # baz

    s apt install git -yqq
    rm -f baz_setup.sh
    wget 'https://files.ari-web.xyz/files/baz_setup.sh'
    bash baz_setup.sh

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
d(){ rm -rf /root/"$1"&&ln -s /home/dartz/"$1" /root/"$1"; }
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
apt install cargo nodejs npm clang gcc ccls python3 python3-pip ruby tcl xorg-dev lua5.4 liblua5.4-dev binutils perl -yqq
git clone https://github.com/vim/vim
cd vim
wget https://files.ari-web.xyz/files/compile_vim.sh
sh compile_vim.sh
make install
EOF

    s bash vim.sh

    # Dotfiles

    git clone https://ari-web.xyz/dotfiles

    rm -rf ~/.vim ~/.vimrc
    cp -r dotfiles/dotfiles/editors/vim ~/.vim
    cp -r dotfiles/dotfiles/config/* ~/.config

    # Tmux

    s apt install tmux

    tee tmux.sh <<EOF
if [ ! "\$TMUX" ] || [ "\$TERM" != 'linux' ]; then
    tmux -2 -l
    exit 127
fi
EOF
}

main "$@"
