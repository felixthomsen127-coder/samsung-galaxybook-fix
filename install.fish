#!/usr/bin/env fish

set -l MODULE "samsung-galaxybook"
set -l KERNEL (uname -r)
set -l DIR (cd (dirname (status --current-filename)); and pwd)

echo "Samsung Galaxy Book Driver Installer"
echo "Kernel: $KERNEL"
echo

if not test -d "/lib/modules/$KERNEL/build"
    echo "ERROR: Kernel headers are missing for $KERNEL."
    echo "Install the appropriate kernel headers and try again."
    exit 1
end

if not type -q clang
    echo "ERROR: clang is required."
    echo "Arch/CachyOS: sudo pacman -S clang"
    exit 1
end

if not type -q ld.lld
    echo "ERROR: lld is required."
    echo "Arch/CachyOS: sudo pacman -S lld"
    exit 1
end

echo "Building driver..."
make -C "$DIR" clean
or exit 1

make -C "$DIR" CC=clang LD=ld.lld
or begin
    echo "ERROR: Driver compilation failed."
    exit 1
end

if not test -f "$DIR/$MODULE.ko"
    echo "ERROR: Driver module was not created."
    exit 1
end

echo "Installing driver..."
sudo mkdir -p "/lib/modules/$KERNEL/updates"
or exit 1
sudo cp "$DIR/$MODULE.ko" "/lib/modules/$KERNEL/updates/$MODULE.ko"
or exit 1
sudo depmod -a "$KERNEL"
or exit 1

echo "Loading driver..."
if sudo modprobe "$MODULE"
    echo
    echo "Installation complete!"
    echo "A reboot is recommended."
else
    echo
    echo "Driver installed, but could not be loaded immediately."
    echo "Try rebooting the computer."
end
