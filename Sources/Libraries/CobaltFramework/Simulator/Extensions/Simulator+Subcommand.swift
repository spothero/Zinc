// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension SimulatorController {
    /// Subcommands of `simctl`.
    public enum Subcommand: String {
        // MARK: Device Commands
        
        /// Boot a device.
        case boot
        /// Clone an existing device.
        case clone
        /// Create a new device.
        case create
        /// Delete spcified devices, unavailable devices, or all devices.
        case delete
        /// Erase a device's contents and settings.
        case erase
        /// List available devices, device types, runtimes, or device pairs.
        case list
        /// Rename a device.
        case rename
        /// Shutdown a device.
        case shutdown
        /// Upgrade a device to a newer runtime.
        case upgrade
        
        // MARK: Device Pairing Commands
        
        /// Create a new watch and phone pair.
        case pair
        /// Set a given pair as active.
        case pairActivate = "pair_activate"
        /// Unpair a watch and phone pair.
        case unpair
        
        // MARK: App Commands
        
        /// Print the path of the installed app's container.
        case getAppContainer = "get_app_container"
        /// Install an app on a device.
        case install
        /// Launch an application by identifier on a device.
        case launch
        /// Terminate an application by identifier on a device.
        case terminate
        /// Uninstall an app from a device.
        case uninstall
        
        // MARK: Pasteboard Commands
        
        /// Sync the pasteboard content from one pasteboard to another.
        case pasteboardSync = "pbsync"
        /// Copy standard input onto the device pasteboard.
        case pasteboardCopy = "pbcopy"
        /// Print the contents of the device's pasteboard to standard output.
        case pasteboardPaste = "pbpaste"
        
        // MARK: Proxy Commands
        
        /// Add photos, live photos, videos, or contacts to the library of a device.
        case addMedia
        /// Trigger iCloud sync on a device.
        case iCloudSync = "icloud_sync"
        /// Set up a device IO operation, such as recording video or taking a screenshot.
        case io // swiftlint:disable:this identifier_name
        /// Manipulate a device's keychain.
        case keychain
        /// Open a URL in a device.
        case openURL = "openurl"
        /// Grant, revoke, or reset privacy and permissions.
        case privacy
        /// Send a simulated push notification.
        case push
        /// Set or clear status bar overrides.
        case statusBar = "status_bar"
        /// Get or set user interface appearance.
        case ui // swiftlint:disable:this identifier_name
        
        // MARK: Diagnostic Commands
        
        /// Collect diagnostic information and logs.
        case diagnose
        /// Print an environment variable from a running device.
        case getEnv = "getenv"
        /// Enable or disable verbose logging for a device
        case logVerbose = "logverbose"
        
        // MARK: Other Commands
        
        /// Prints the usage for a given subcommand.
        case help
        /// Spawn a process by executing a given executable on a device.
        case spawn
    }
}
