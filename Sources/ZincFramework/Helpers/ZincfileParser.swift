// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

class ZincfileParser {
    static let shared = ZincfileParser()

    /// Attempts to fetch a Zincfile with the given filename/
    ///
    /// - Parameter filename: The filename of the Zincfile to fetch.
    /// - Returns: The fetched Zincfile if successful or nil if not.
    /// - Throws: A parsing error, if one occurs.
    func fetch(_ filename: String? = nil) throws -> Zincfile? {
        if let filename = filename, !filename.isEmpty {
            // Try to parse the filename that was passed in
            // If it an error is thrown here, report to the user -- don't try default filenames
            return try self.parse(filename)
        } else {
            // Cycle through default filenames and parse the first one that exists
            for filename in Constants.defaultFilenames {
                // We don't care about the errors in this block, so we use try? syntax to suppress them
                if let zincfile = try? self.parse(filename) {
                    return zincfile
                }
            }

            // At this point, no Zincfile has been found, so throw an error
            throw ZincfileParsingError.fileNotFound(filename)
        }
    }

    /// Parses a Zincfile with the given filename.
    ///
    /// - Parameter filename: The filename of the Zincfile to parse.
    /// - Returns: The parsed Zincfile if successful or nil if not.
    /// - Throws: A parsing error, if one occurs.
    private func parse(_ filename: String) throws -> Zincfile? {
        // First, check if the file exists
        guard FileClerk.fileExists(file: filename) else {
            throw ZincfileParsingError.fileNotFound(filename)
        }

        // Second, read text from the file
        guard let text = FileClerk.read(file: filename) else {
            throw ZincfileParsingError.textCouldNotBeRead(filename)
        }

        // Third, attempt to deserialize into a Zincfile
        guard let zincfile: Zincfile = Farmer.shared.deserialize(text) else {
            throw ZincfileParsingError.fileCouldNotBeDeserialized(filename)
        }

        // Finally, return the zincfile if we made it this far!
        return zincfile
    }
}
