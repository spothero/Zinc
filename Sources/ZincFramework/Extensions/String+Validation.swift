// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

extension String {
    private var legalRepositoryCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=")
    }
    
    private var legalURLCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=")
    }
    
    var isValidURL: Bool {
        // we only want to do bare minimum validation to understand if the user is trying to enter a URL or not
        
        // if the string contains illegal characters, it's not a valid URL
        guard self.rangeOfCharacter(from: self.legalURLCharacterSet.inverted) == nil else {
            // TODO: throw error
            return false
        }
        
        // if the characters are lega
        guard self.hasPrefix("http://") || self.hasPrefix("https://") else {
            // TODO: throw error
            return false
        }
        
        return true
    }
    
    var isValidRepository: Bool {
        // accepted characters in a repo are: alphanumeric and hyphen
        // all we want are legal characters separated by a slash
        let regex = #"\b^[a-zA-Z0-9\-]+/[a-zA-Z0-9\-]+$\b"#
        
        return self.range(of: regex, options: .regularExpression) != nil
    }
    
    var repositoryName: String {
        let regex = #"([a-zA-Z0-9\-]+/[a-zA-Z0-9\-]+)(?:.git)?$"#
        
        _ = self.range(of: regex, options: .regularExpression)
        
        // TODO: FIX?
        // print(range)
        
        // return self[range]
        return self
    }
    
    var sourceType: SourceType {
        if self.isValidRepository {
            return .repository
        } else if self.isValidURL {
            return .url
        } else if self.isEmpty {
            return .default
        } else {
            return .invalid
        }
    }
}
