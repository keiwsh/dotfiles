After running arch-bootstrap.sh and install-dotfiles.sh
```
git clone --depth=1 https://github.com/JaKooLit/Arch-Hyprland.git ~/Arch-Hyprland
cd ~/Arch-Hyprland
chmod +x install.sh
./install.sh
```


Chroot 
```
pacman -Sy grub efibootmgr dosfstools mtools
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg
```

Adding Windows and other OS's to GRUB
```
- nano /etc/default/grub
Uncomment #GRUB_DISABLE_OS_PROBER=false
- pacman -Sy os-prober
- grub-mkconfig -o /boot/grub/grub.cfg
```
