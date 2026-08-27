# Samsung Galaxy Book Linux ACPI Fix this is all chat gpt i have no clue what this does but now my driver works so i hope it can help someone else

A patched version of the Linux `samsung-galaxybook` driver for Samsung Galaxy Book laptops where the keyboard backlight, Fn hotkeys, or performance controls are not working correctly.

## What this fixes

This patch modifies the Samsung Galaxy Book ACPI driver so that the firmware ACPI features are explicitly enabled before the driver attempts to use them.

Tested functionality:

- Keyboard backlight control
- Keyboard backlight Fn keys
- Fn Lock / related hotkeys
- Keyboard backlight brightness OSD indicator
- Platform performance profiles
- ACPI power-management features

On the tested system, the driver exposes:

```text
samsung-galaxybook::kbd_backlight
