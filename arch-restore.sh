#!/usr/bin/env bash
set -euo pipefail

desktop="${XDG_CURRENT_DESKTOP:-}"

case "$desktop" in
    KDE*)
        profile="archkde.sh"
        ;;
    GNOME*)
        profile="archgnome.sh"
        ;;
    X-Cinnamon*|Cinnamon*)
        profile="archcinnamon.sh"
        ;;
    COSMIC*)
        profile="archcosmic.sh"
        ;;
    *)
        echo "Unsupported desktop."
        echo "XDG_CURRENT_DESKTOP=${XDG_CURRENT_DESKTOP:-<unset>}"
        echo "XDG_SESSION_DESKTOP=${XDG_SESSION_DESKTOP:-<unset>}"
        echo "DESKTOP_SESSION=${DESKTOP_SESSION:-<unset>}"
        exit 1
        ;;
esac

curl -fsSL "https://raw.githubusercontent.com/Azuko8/arch-restore/main/profiles/$profile" | bash
