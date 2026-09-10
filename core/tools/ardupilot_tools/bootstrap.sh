#!/usr/bin/env bash

# Immediately exit on errors
set -e

# Create the logs folder before ardupilot so we prevent a Filebrowser error if the user opens it
# before arming the vehicle for the first time.
if [ -z "$NOSUDO" ]; then
    $SUDO mkdir -p /root/.config/ardupilot-manager/firmware/logs/
fi

# Default firmware is intentionally NOT downloaded at build time.
#
# Upstream fetches ArduSub for Navigator/Navigator64 (and Pixhawk .apj files that
# nothing ever reads) from firmware.ardupilot.org here. That host regularly stalls
# mid-transfer, which made this stage hang for hours under buildx/QEMU.
#
# Consequences of not shipping the defaults:
#   * Serial boards (Pixhawk etc.): none. They never used these files.
#   * Navigator/Navigator64: on first boot with no firmware installed,
#     ardupilot_manager logs NoDefaultFirmwareAvailable and waits; install a
#     firmware from the Autopilot page (it downloads at runtime). The
#     "Restore default firmware" button returns 404 until you set one via
#     "Install and make default".
#
# Set DOWNLOAD_DEFAULT_FIRMWARE=1 at build time to restore the old behaviour
# (best effort, with timeouts, never fails the build).

if [ -n "$DOWNLOAD_DEFAULT_FIRMWARE" ]; then
    AUTOPILOT_DEFAULT_FIRMWARE_PATH="$HOME/blueos-files/ardupilot-manager/default"
    for board in navigator navigator64; do
        dest="$AUTOPILOT_DEFAULT_FIRMWARE_PATH/ardupilot_${board}/ardusub"
        mkdir -p "$(dirname "$dest")"
        wget --timeout=30 --tries=3 \
            "https://firmware.ardupilot.org/Sub/stable-4.5.3/${board}/ardusub" -O "$dest" \
            || { echo "WARNING: default firmware for ${board} not downloaded"; rm -f "$dest"; }
    done
fi

echo "ardupilot_tools bootstrap done."