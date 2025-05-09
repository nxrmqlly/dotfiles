#!/usr/bin/env bash

THEME_DIR="$HOME/.config/waybar/colorschemes"

case $1 in
    --nightowl)
        waybar -s "$THEME_DIR/nightowl.css"
        ;;
    --carppuccin)
        waybar -s "$THEME_DIR/catppuccin-mocha.css"
        ;;
    *)
        waybar -s "$THEME_DIR/everforest.css"
        ;;
esac
