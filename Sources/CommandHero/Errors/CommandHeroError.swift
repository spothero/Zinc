// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

enum CommandHeroError: Error {
    case exception(_ message: String)
    case invalidCommand(_ command: String)
    case unexpectedError
}

extension CommandHeroError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case let .exception(message):
            return message
        case let .invalidCommand(command):
            return "\(command) is not a valid command."
        case .unexpectedError:
            return "An unexpected error occurred!"
        }
    }
}
