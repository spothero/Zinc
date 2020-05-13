// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
import Logging

public class FileClerk {
    // MARK: - Shared Instance
    
    public static let shared = FileClerk()
    
    // MARK: - Properties
    
    public static let tempDirectory = "tmp"
    
    public static var currentDirectory: String {
        return FileManager.default.currentDirectoryPath
    }
    
    private static let logger = Logger(label: "com.spothero.zinc.fileclerk")
    
    // MARK: - Methods
    
    // MARK: Lifecycle
    
    private init() {}
    
    // MARK: Create
    
    public func createDirectory(_ path: String, deleteExisting: Bool = false) {
        Self.logger.debug("Creating directory \(path)...")
        
        do {
            if deleteExisting {
                self.removeTempDirectory()
            }
            
            try FileManager.default.createDirectory(atPath: path,
                                                    withIntermediateDirectories: true,
                                                    attributes: nil)
        } catch {
            Self.logger.error("\(error.localizedDescription)")
        }
    }
    
    public func createTempDirectory(deleteExisting: Bool = false) {
        self.createDirectory(FileClerk.tempDirectory, deleteExisting: deleteExisting)
    }
    
    // MARK: Copy
    
    public func copyItem(from source: String, to destination: String, shouldReplace: Bool = true) {
        Self.logger.debug("Copying from \(source) to \(destination)...")
        
        // Convert destination into a URL
        let destinationURL = URL(fileURLWithPath: destination)
        
        // Remove the file from the destination path to get the destination directory
        let destinationDirectory = destinationURL.deletingLastPathComponent().relativePath
        
        // If the directory isn't empty and doesn't already exist, create it
        if !destinationDirectory.isEmpty, !self.directoryExists(destinationDirectory) {
            self.createDirectory(destinationDirectory)
        }
        
        do {
            if shouldReplace, self.fileExists(destination) {
                _ = try FileManager.default.replaceItemAt(destinationURL,
                                                          withItemAt: URL(fileURLWithPath: source),
                                                          options: .usingNewMetadataOnly)
            } else {
                try FileManager.default.copyItem(atPath: source, toPath: destination)
            }
        } catch {
            Self.logger.error("\(error.localizedDescription)")
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
            Self.logger.error("\(error.localizedDescription)")
            return nil
        }
    }
    
    // MARK: Remove
    
    public func remove(_ path: String) {
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            let error = error as NSError
            let underlyingError = error.userInfo[NSUnderlyingErrorKey] as? NSError
            
            // The following error codes indicate there is no such file or directory,
            // so we can safely ignore the error and treat it as successful (nothing to remove)
            // NSCocoaErrorDomain 4: File couldn't be removed
            // NSPOSIXErrorDomain 2: No such file or directory
            if error.code == 4, underlyingError?.code == 2 {
                // Don't log the error
                return
            }
            
            Self.logger.error("\(error.localizedDescription)")
        }
    }
    
    public func removeTempDirectory() {
        self.remove(FileClerk.tempDirectory)
    }
    
    // MARK: Utility
    
    public func directoryExists(_ path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
    
    public func fileExists(_ path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    public func filename(for path: String) -> String {
        return (path as NSString).lastPathComponent
    }
}
