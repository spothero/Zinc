// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

enum ZincError: Error {
    case invalidCommand(_ command: String)
    case unexpectedError
}

extension ZincError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .invalidCommand(command):
            return "\(command) is not a valid command."
        case .unexpectedError:
            return "An unexpected error occurred!"
        }
    }
}
