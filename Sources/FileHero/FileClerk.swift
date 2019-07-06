// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import Lumberjack

public class FileClerk {
    // MARK: - Shared Instance

    public static let shared = FileClerk()

    // MARK: - Properties

    private static let tempDirectory = "tmp"

    public static var currentDirectory: String {
        return FileManager.default.currentDirectoryPath
    }

    // MARK: - Methods

    // MARK: Lifecycle

    private init() {}

    // MARK: Create

    public func createDirectory(_ path: String, deleteExisting: Bool = false) {
        do {
            if deleteExisting {
                self.removeTempDirectory()
            }

            try FileManager.default.createDirectory(atPath: path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            Lumberjack.shared.log(error)
        }
    }

    public func createTempDirectory(deleteExisting: Bool = false) {
        self.createDirectory(FileClerk.tempDirectory, deleteExisting: deleteExisting)
    }

    // MARK: Copy

    public func copyItem(from source: String, to destination: String, shouldReplace: Bool = true) {
        Lumberjack.shared.log("Copying from \(source) to \(destination)...")

        do {
            if shouldReplace {
                _ = try FileManager.default.replaceItemAt(URL(fileURLWithPath: destination),
                                                          withItemAt: URL(fileURLWithPath: source),
                                                          options: .usingNewMetadataOnly)
            } else {
                try FileManager.default.copyItem(atPath: source, toPath: destination)
            }
        } catch {
            Lumberjack.shared.log(error)
        }
    }

    // MARK: Read

    public func read(file filePath: String) -> String? {
        let fileURL = URL(fileURLWithPath: filePath)
        return self.read(fileURL: fileURL)
    }

    public func read(fileURL: URL?) -> String? {
        guard let fileURL = fileURL else {
            return nil
        }

        do {
            return try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            Lumberjack.shared.log(error)
            return nil
        }
    }

    // MARK: Remove

    public func remove(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            Lumberjack.shared.log(error)
        }
    }

    public func removeTempDirectory() {
        self.remove(FileClerk.tempDirectory)
    }

    // MARK: Utility

    public func fileExists(file filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }

    public func filename(for path: String) -> String {
        return (path as NSString).lastPathComponent
    }
}
