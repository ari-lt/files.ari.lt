#!/usr/bin/env sh

main() {
    ARI_WEB="shortcmd-baz-plugin coloured-man-pages-plugin better-bash-baz-plugin
             ls-aliases-baz-plugin vifzf-keybinds-baz-plugin yt-dlp-aliases-baz-plugin
             trash-cli-rm-baz bettercmd-baz-plugin cmdutils-baz-plugin"

    COFFEE="coffee.tty-theme coffee.baz-plugin"

    sed 's/BAZP_NO_ASKCHECK=false/BAZP_NO_ASKCHECK=true/g' -i "$HOME/.config/baz/config.env"

    plugins=''

    for ariweb in $ARI_WEB; do
        plugins="$plugins https://ari-web.xyz/gh/$ariweb"
    done

    for coffee in $COFFEE; do
        plugins="$plugins https://github.com/coffee-theme/$coffee"
    done

    python3 -m pip install --user trash-cli
    baz install git $COFFEE
}

main "$@"
