#!/bin/sh

# TODO: Ensure xcrun is installed
# xcrun is installed via xcode-select --install, which requires popup confirmation
# After a user has installed, they can re-run this script. We should prompt them to re-run and exit.

# TODO: Check for a booted device, you can use "booted"

# display booted devices:
# xcrun simctl list | grep Booted

# for swift command-line app:
# xcrun simctl list --json

echo "Creating simulator device..."
UUID=$(xcrun simctl create MySimulatorDevice com.apple.CoreSimulator.SimDeviceType.iPhone-11-Pro com.apple.CoreSimulator.SimRuntime.iOS-13-4)
echo "Simulator device created with UUID '$UUID'."

echo "Booting device..."
xcrun simctl boot $UUID
echo "Device booted."

XCODE_PATH=$(xcode-select --print-path)

echo "Launching Simulator.app..."
open "$XCODE_PATH"

# TODO: When finished, run simctl shutdown and erase. Maybe this is where the Swift command line tool can hang until complete?
# If we decide to hang, it should be an optional property to pass in

# TODO: Cleanup? xcrun simctl delete unavailable
