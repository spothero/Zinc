// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

enum ZincfileParsingError: Swift.Error {
    case fileNotFound(_ filename: String?)
    case textCouldNotBeRead(_ filename: String)
    case fileCouldNotBeDeserialized(_ filename: String)
}

extension ZincfileParsingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .fileNotFound(.some(filename)):
            return "\(filename) not found."
        case .fileNotFound:
            return ZincfileParsingError.fileNotFound("Zincfile").errorDescription
        case let .textCouldNotBeRead(filename):
            return "Could not read text in \(filename)."
        case let .fileCouldNotBeDeserialized(filename):
            return "\(filename) could not be deserialized."
        }
    }
}
