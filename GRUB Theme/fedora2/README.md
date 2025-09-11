# GRUB Theme

### Paste this in /etc/default/grub

```bash
GRUB_THEME="/usr/share/grub/themes/fedora2/theme.txt"
```

```bash
sudo cp -r fedora2/ /usr/share/grub/themes			# Copy Theme to grub themes folder
sudo grub2-mkconfig -o /boot/grub2/grub.cfg			# Update GRUB
```
