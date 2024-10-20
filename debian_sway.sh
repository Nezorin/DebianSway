#!/bin/bash

swayPackages=(
    sway
    wl-clipboard
    swaylock
    swayidle
)

essentialPackages=(
    git
    curl
    wget
    foot
    micro
    firefox-esr
    telegram-desktop
    vlc
    nodejs
    neofetch
    thunar
)

install_vscode() {
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list'

    sudo apt-get install apt-transport-https -y
    sudo apt-get update
    sudo apt-get install code -y
}

sudo apt install -y "${swayPackages[@]}"
sudo apt install -y "${essentialPackages[@]}"

cp .config/sway/config  ~/.config/sway/config
cp .config/sway/wallpaper.png  ~/.config/sway/
cp .config/foot/foot.ini  ~/.config/foot/foot.ini

install_vscode
# Make sway start after login
# Define the content to add to .bash_profile
SWAY_CMD='[ "$(tty)" = "/dev/tty1" ] && exec sway'

# The file to modify
BASH_PROFILE="$HOME/.bash_profile"

# Check if the command is already in .bash_profile
if grep -qF "$SWAY_CMD" "$BASH_PROFILE"; then
    echo "Sway startup already configured in .bash_profile"
else
    # Append the sway start command to .bash_profile
    echo "Adding Sway startup command to .bash_profile..."
    echo "$SWAY_CMD" >> "$BASH_PROFILE"
    echo "Sway will now start automatically on tty1."
fi