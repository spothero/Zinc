// Copyright © 2019 SpotHero, Inc. All rights reserved.

import Foundation
import Lumberjack

class FileClerk {
    // MARK: - Properties

    static let tempDirectory = "tmp"

    static var currentDirectory: String {
        return FileManager.default.currentDirectoryPath
    }

    // MARK: - Methods

    // MARK: Create

    static func createDirectory(_ path: String, deleteExisting: Bool = false) {
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

    static func createTempDirectory(deleteExisting: Bool = false) {
        self.createDirectory(self.tempDirectory, deleteExisting: deleteExisting)
    }

    // MARK: Copy

    static func copyItem(from source: String, to destination: String, shouldReplace: Bool = true) {
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

    static func read(file filePath: String) -> String? {
        let fileURL = URL(fileURLWithPath: filePath)
        return self.read(fileURL: fileURL)
    }

    static func read(fileURL: URL?) -> String? {
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

    static func remove(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            Lumberjack.shared.log(error)
        }
    }

    static func removeTempDirectory() {
        self.remove(self.tempDirectory)
    }

    // MARK: Utility

    static func fileExists(file filePath: String) -> Bool {
        return FileManager.default.fileExists(atPath: filePath)
    }

    static func filename(for path: String) -> String {
        return (path as NSString).lastPathComponent
    }
}
