// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public final class ErrorCleaner {
    public static func cleanedMessage(for error: Error) -> String {
        switch error {
        case let decodingError as DecodingError:
            return self.cleanedMessage(for: decodingError)
        default:
            return error.localizedDescription
        }
    }
    
    public static func cleanedMessage(for decodingError: DecodingError) -> String {
        switch decodingError {
        case let .typeMismatch(type, context):
            return "Type mismatch for key '\(context.codingPath.jsonPath)'. Expected type '\(String(describing: type))'."
        case let .valueNotFound(type, context):
            return "Value not found for key '\(context.codingPath.jsonPath)' of type '\(String(describing: type))'."
        case let .keyNotFound(key, context):
            var allKeys = context.codingPath
            allKeys.append(key)
            
            return "Key '\(allKeys.jsonPath)' not found."
        case .dataCorrupted:
            return "Data corrupted."
        @unknown default:
            return decodingError.localizedDescription
        }
    }
}

extension Array where Element == CodingKey {
    fileprivate var jsonPath: String {
        var path = ""
        
        for key in self {
            if let index = key.intValue {
                path += "[\(index)]"
            } else {
                path += ".\(key.stringValue)"
            }
        }
        
        return path
            .trimmingCharacters(in: CharacterSet(charactersIn: "."))
    }
}
