#!/bin/bash

git clone https://github.com/keiwsh/dotfiles.git ~/dotfiles_temp

cp -r ~/dotfiles_temp/.config/* ~/.config/

rm -rf ~/dotfiles_temp

echo "Dotfiles copied successfully."

# Make the Script Executable:
# chmod +x install_dotfiles.sh

# Run the Script:
# ./install_dotfiles.sh
