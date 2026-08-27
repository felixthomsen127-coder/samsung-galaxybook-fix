#!/usr/bin/env fish

set -l MODULE "samsung-galaxybook"
set -l KERNEL (uname -r)
set -l FILE "/lib/modules/$KERNEL/updates/$MODULE.ko"

echo "Samsung Galaxy Book Driver Uninstaller"
echo

sudo modprobe -r "$MODULE" 2>/dev/null

if test -f "$FILE"
    sudo rm "$FILE"
    sudo depmod -a "$KERNEL"
    echo "Driver removed successfully."
else
    echo "Driver module was not found."
end
