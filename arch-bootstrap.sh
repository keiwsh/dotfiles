#!/bin/bash

TITLE="\e[1;35m"
RUNNING="\e[35m"
QUESTION="\e[36m"
SUCCESS="\e[1;32m"
FAILED="\e[1;31m"
END="\e[0m"
LINE="\n"

basePacmanList=(git kitty libinput sddm networkmanager polybar reflector timeshift ufw)

utilsPacmanList=(curl fastfetch flatpak fzf gnome-keyring neovim rofi tar thefuck tldr tmux unrar unzip usbutils vim wget zip zoxide ttf-jetbrains-mono-nerd)

driversPacmanList=(alsa-utils blueman bluez-utils brightnessctl cups cups-pdf hplip linux-headers system-config-printer)

guiPacmanList=(code discord obsidian thunar virtualbox vlc firefox dunst libnotify starship nwg-look)

yayPackagesList=(rofi-lbonn-wayland-git swww tela-circle-icon-theme-dracula catppuccin-gtk-theme-mocha catppuccin-gtk-theme-latte bibata-cursor-theme-bin ttf-maple)

servicesList=(ufw.service cups NetworkManager sddm bluetooth.service)

installPackage() {
    local pacman="sudo pacman -S --noconfirm"
    local yay="yay -S --noconfirm"
    local packageManager="$1"
    shift

    if [ "$packageManager" == "pacman" ]; then
        commandExecutor="$pacman"
    elif [ "$packageManager" == "yay" ]; then
        commandExecutor="$yay"
    fi

    for package in "${@}"; do
        echo -e "${RUNNING}Installing ${END}$package"
        $commandExecutor $package
        if [ $? -eq 0 ]; then
            echo -e "${SUCCESS}The package has been installed correctly${END}"
        else
            echo -e "${FAILED} !WARNING! The following package could not be installed: ${END}$package"
        fi
    done
}

enableService() {
    local enableCommand="sudo systemctl enable"
    shift

    for service in "${@}"; do
        echo -e "${RUNNING}Enabling ${END}$service"
        $enableCommand $service
        if [ $? -eq 0 ]; then
            echo -e "${SUCCESS}The service has been enabled correctly${END}"
        else
            echo -e "${FAILED} !WARNING! The following service could not be enabled: ${END}$service"
        fi
    done
}

askUser() {
    local questionText="$1"
    local action="$2"

    echo -ne "${LINE}${QUESTION}${questionText} (Y/n): ${END}"
    read -r output
    echo ""

    output=${output,,}

    if [[ -z $output ]]; then
        output='y'
    fi

    if [[ $output == 'y' ]]; then
        echo -e "${QUESTION}The installation will begin${END}"
        eval "$action"
    else
        echo -e "${FAILED} !WARNING! The installation will not be executed${END}"
    fi
}

function main() {
    echo -e "${LINE}${TITLE} [========== WELCOME TO KEIWSH'S ARCH LINUX BOOTSTRAP ==========] ${END}${LINE}"

    sysUpdate="sudo pacman -Syu"
    echo -e "First, we will update the system to ensure there are no problems during installation."
    askUser " ► Do you want to update your system?" "$sysUpdate"

    pacmanCategories=("base" "utils" "drivers" "gui")
    for category in "${pacmanCategories[@]}"; do
        pacmanPkgInstallCommand="installPackage \"pacman\" \"\${${category}PacmanList[@]}\""
        echo -e "${LINE}${RUNNING}The following pacman packages will be installed:${END} $(eval echo \${${category}PacmanList[@]})"
        askUser " ► Do you want to install them?" "$pacmanPkgInstallCommand"
    done

    yayInstallCommand="cd && git clone https://aur.archlinux.org/yay.git; cd yay/ && makepkg -si; cd .. && sudo rm -r yay"
    askUser "Do you want to install yay?" "$yayInstallCommand"

    yayPkgInstallCommand="installPackage \"yay\" \"${yayPackagesList[@]}\""
    echo -e "${LINE}${RUNNING}The following packages will be installed:${END} ${yayPackagesList[@]}"
    askUser "Do you want to install them?" "$yayPkgInstallCommand"

    serviceInstallCommand="enableService \"${servicesList[@]}\""
    askUser "Do you want to enable the services?" "$serviceInstallCommand"

    # Install Starship prompt and configure
    starshipInstallCommand="yay -S --noconfirm starship"
    askUser "Do you want to install Starship and set it as your default prompt?" "$starshipInstallCommand"
    
    # Configure Starship in ~/.bashrc
    if [ $? -eq 0 ]; then
        echo "export STARSHIP_CONFIG=~/.config/starship/starship.toml" >> ~/.bashrc
        echo "eval \"\$(starship init bash)\"" >> ~/.bashrc
        rm ~/.config/starship.toml
    fi

    echo -e "${LINE}${TITLE} The script has finished running. Enjoy your system! ${END}"
    echo -e "${TITLE} Made by: github.com/keiwsh${END}${LINE}"
}

main "$@"
