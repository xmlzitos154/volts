#!/usr/bin/env bash

REAL_HOME=$(getent passwd "$REAL_USER" 2>/dev/null | cut -d: -f6)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$SCRIPT_DIR/main.sh"

title() { clear; echo -e "VOLTS SETUP "; echo -e "──────────────────────────────"; }

if [[ ! -f "$SOURCE" ]]; then
    echo -e "${R}Error: File 'main' not found.${NC}"
    exit 1
fi

[[ $EUID -ne 0 ]] && { echo -e "Soliciting root..."; exec sudo "$0" "$@"; }

BIN_NAME="volts"
INSTALL_PATH="/usr/bin/$BIN_NAME"

installer() {
    echo "installing volts..."
    install -Dm755 $SOURCE $INSTALL_PATH
    chmod +x $INSTALL_PATH
    echo "Done."
    exit 0
}

remover() {
    echo "uninstalling volts..."
    rm "$INSTALL_PATH"
    echo "Done."
    exit 0
}

while true; do
    title
    echo -e "  ${C}1.${NC} Install / Update"
    echo -e "  ${C}2.${NC} Remove"
    echo -e "  ${C}3.${NC} Exit"
    echo ""
    echo -n " > "
    read -r DO
    
    case "$DO" in
        1) installer ;;
        2) remover ;;
        3) exit 0 ;;
        *) echo -e "${R}Invalid option.${NC}"; sleep 0.5 ;;
    esac
done
