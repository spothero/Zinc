// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

enum ZincError: Error {
    case unexpectedError
}

extension ZincError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .unexpectedError:
            return "An unexpected error occurred!"
        }
    }
}
