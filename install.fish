#!/usr/bin/env fish

set KERNEL (uname -r)
set KDIR /usr/lib/modules/$KERNEL/build

echo "Samsung Galaxy Book ACPI fix"
echo "Kernel: $KERNEL"
echo ""

if not test -d "$KDIR"
    echo "ERROR: Matching kernel headers are not installed."
    exit 1
end

if not type -q clang
    echo "ERROR: clang is not installed."
    echo "Run: sudo pacman -S clang"
    exit 1
end

if not type -q ld.lld
    echo "ERROR: lld is not installed."
    echo "Run: sudo pacman -S lld"
    exit 1
end

printf "%s\n" "#ifndef _FIRMWARE_ATTRIBUTES_CLASS_H_" "#define _FIRMWARE_ATTRIBUTES_CLASS_H_" "#include <linux/device/class.h>" "extern struct class firmware_attributes_class;" "#endif" > firmware_attributes_class.h

echo "Building driver..."
make -C "$KDIR" M="$PWD" clean
or exit 1

make -C "$KDIR" M="$PWD" modules CC=clang LD=ld.lld
or exit 1

if not test -f samsung-galaxybook.ko
    echo "ERROR: samsung-galaxybook.ko was not created."
    exit 1
end

if not modinfo ./samsung-galaxybook.ko | grep -q SAMB430
    echo "ERROR: SAMB430 support was not found in the driver."
    exit 1
end

echo "Installing driver..."
sudo mkdir -p /lib/modules/$KERNEL/updates
or exit 1
sudo cp samsung-galaxybook.ko /lib/modules/$KERNEL/updates/
or exit 1
sudo depmod -a $KERNEL
or exit 1

sudo modprobe -r samsung_galaxybook 2>/dev/null
sudo modprobe samsung_galaxybook
or begin
    echo ""
    echo "Driver installed, but could not be loaded."
    echo "Reboot and it will load automatically."
    exit 0
end

echo ""
echo "DONE!"
echo "SAMB430 support installed for $KERNEL."
echo ""
echo "Keyboard LEDs:"
ls /sys/class/leds/ | grep samsung
