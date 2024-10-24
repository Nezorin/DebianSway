#!/bin/bash

# Exit on any error
set -e

# Log all commands
set -x

# Function to ensure directories exist
create_config_dirs() {
    mkdir -p ~/.config/sway
    mkdir -p ~/.config/foot
}

# Function to check if we're running as non-root
check_user() {
    if [ "$(id -u)" -eq 0 ]; then
        echo "This script should not be run as root or with sudo directly."
        echo "It will ask for sudo permissions when needed."
        exit 1
    fi
}

# Function to check if a package is installed
is_package_installed() {
    dpkg -l "$1" &> /dev/null
    return $?
}

# Sway and related packages
swayPackages=(
    sway
    wl-clipboard
    swaylock
    swayidle
    wofi
    waybar
)

# Essential packages
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
    if ! is_package_installed code; then
        echo "Installing Visual Studio Code..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
        sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg
        rm microsoft.gpg
        echo "deb [arch=amd64,arm64,armhf signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
        sudo apt-get update
        sudo apt-get install -y apt-transport-https code
    else
        echo "VS Code is already installed."
    fi
}

configure_sway_autostart() {
    SWAY_CMD='[ "$(tty)" = "/dev/tty1" ] && exec sway'
    BASH_PROFILE="$HOME/.bash_profile"

    # Create .bash_profile if it doesn't exist
    touch "$BASH_PROFILE"

    if ! grep -qF "$SWAY_CMD" "$BASH_PROFILE"; then
        echo "Adding Sway startup command to .bash_profile..."
        echo "$SWAY_CMD" >> "$BASH_PROFILE"
        echo "Sway will now start automatically on tty1."
    else
        echo "Sway startup already configured in .bash_profile"
    fi
}

copy_config_files() {
    local script_dir="$(dirname "$(readlink -f "$0")")"
    
    # Check if config files exist before copying
    if [ -f "$script_dir/.config/sway/config" ]; then
        cp "$script_dir/.config/sway/config" ~/.config/sway/config
    else
        echo "Warning: Sway config file not found in $script_dir/.config/sway/"
    fi

    if [ -f "$script_dir/.config/sway/wallpaper.png" ]; then
        cp "$script_dir/.config/sway/wallpaper.png" ~/.config/sway/
    else
        echo "Warning: Wallpaper file not found in $script_dir/.config/sway/"
    fi

    if [ -f "$script_dir/.config/foot/foot.ini" ]; then
        cp "$script_dir/.config/foot/foot.ini" ~/.config/foot/
    else
        echo "Warning: Foot config file not found in $script_dir/.config/foot/"
    fi
}

main() {
    check_user
    
    # Update package lists
    echo "Updating package lists..."
    sudo apt-get update

    # Install packages
    echo "Installing Sway packages..."
    sudo apt-get install -y "${swayPackages[@]}"
    
    echo "Installing essential packages..."
    sudo apt-get install -y "${essentialPackages[@]}"

    # Create necessary directories
    create_config_dirs

    # Copy configuration files
    copy_config_files

    # Install VS Code
    install_vscode

    # Configure Sway autostart
    configure_sway_autostart

    echo "Installation completed successfully!"
    echo "Please log out and log back in to start using Sway."
}

# Run the main function
main