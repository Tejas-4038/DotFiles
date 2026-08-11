# Spinning Tux Theme

### Remove old logo

```bash
rm logo.png
```

### Copy Distro logo

```bash
cp /usr/share/pixmaps/[distro_name]-logo-text-dark.png logo.png
```

### Symlink theme using GNU Stow

```bash
cd ../../../../../../
sudo stow plymouth -t /
```

### Apply Theme

```bash
sudo plymouth-set-default-theme tuxspin
```

### Rebuild initramfs

```bash
sudo mkinitcpio -P                  # On Arch/CachyOS (anything that uses mkinitcpio)
sudo dracut-rebuild                 # On Fedora/EndeavourOS
```

