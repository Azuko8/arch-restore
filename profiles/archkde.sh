#!/usr/bin/env bash

set -euo pipefail

echo "=========================================="
echo "Arch Linux Setup Script"
echo "=========================================="
echo ""
echo "OS: Arch Linux - Cinnamon"
echo ""
echo "Software to be installed manually post-script:"
echo "  • Vesktop"
echo "  • osu!"
echo "  • ytm"
echo ""
echo "=========================================="
echo ""
echo ""

echo "Removing bloat"
echo ""

REMOVE_PACKAGES=(
    vim
)

echo "Removing ${#REMOVE_PACKAGES[@]} packages..."
if sudo pacman -R "${REMOVE_PACKAGES[@]}" --noconfirm; then
    echo "Packages removed successfully."
else
    echo "Error: Package removal failed."
    exit 1
fi

echo "Installing pacman packages..."
echo ""

if sudo pacman -S --needed --noconfirm fish git micro obs-studio btrfs-assistant solaar timeshift librewolf kitty flatpak > /dev/null; then
    echo "Packages installed successfully."
else
    echo "Error: Installation failed."
    exit 1
fi

echo ""

echo "Configuring Flatpak..."
echo ""

echo "Checking and adding flathub source if not present..."
if flatpak remote-add --if-not-exists flathub \
    https://dl.flathub.org/repo/flathub.flatpakrepo; then
    echo "Flathub source added."
else
    echo "Error: Flathub configuration failed."
    exit 1
fi

echo ""

echo "Installing Flatpak packages..."
echo ""

if flatpak install -y flathub \
    org.keepassxc.KeePassXC \
    it.mijorus.gearlever \
    net.davidotek.pupgui2 \
    org.localsend.localsend_app \
    org.prismlauncher.PrismLauncher \
    > /dev/null; then
    echo "Flatpak packages installed successfully."
else
    echo "Error: Flatpak installation failed."
    exit 1
fi

echo "Installing Signal..."

mkdir -p "$HOME/.local/bin"

if curl -L -o "$HOME/.local/bin/signal-desktop.AppImage" \
    https://updates.signal.org/desktop/signal-desktop.AppImage > /dev/null; then
    echo "Signal AppImage downloaded successfully."
else
    echo "Error: Signal download failed."
    exit 1
fi

echo "Verifying Signal AppImage..."

if curl -o /tmp/signal-appimage.asc \
    https://updates.signal.org/static/desktop/appimage.asc > /dev/null &&
   curl -L -o /tmp/signal-desktop.AppImage.gpg \
    https://updates.signal.org/desktop/signal-desktop.AppImage.gpg > /dev/null &&
   gpg --import /tmp/signal-appimage.asc > /dev/null &&
   gpg --verify /tmp/signal-desktop.AppImage.gpg \
    "$HOME/.local/bin/signal-desktop.AppImage" > /dev/null; then
    echo "Signal AppImage verified successfully."
else
    echo "Error: Signal AppImage verification failed."
    exit 1
fi

chmod +x "$HOME/.local/bin/signal-desktop.AppImage"

rm -f /tmp/signal-appimage.asc \
      /tmp/signal-desktop.AppImage.gpg

echo "Signal installed successfully."

echo ""

echo "=========================================="
echo "Setup complete."
echo "=========================================="
echo ""
echo "Remember to install these manually:"
echo "  • Vesktop"
echo "  • osu!"
echo "  • ytm"
echo ""
