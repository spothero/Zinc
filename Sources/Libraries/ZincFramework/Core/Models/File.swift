// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public struct File: Codable {
    private static let defaultSource = "default"
    
    enum CodingKeys: String, CodingKey {
        case destinationPath = "destination_path"
        case name
        case source
        case sourceBranch = "source_branch"
        case sourcePath = "source_path"
        case sourceTag = "source_tag"
    }
    
    public let destinationPath: String
    public let name: String
    public let source: String
    public let sourceBranch: String?
    public let sourcePath: String
    public let sourceTag: String?
    
    public var fullSourcePath: String {
        return self.sourcePath.isEmpty ? self.source : "./\(self.source)/\(self.sourcePath)"
    }
    
    public var fullDestinationPath: String {
        // set the default destination path to the current directory
        var destinationPath = "./"
        
        // if destination path isn't empty, set it to that value
        if !self.destinationPath.isEmpty {
            destinationPath = "\(self.destinationPath)/"
        }
        
        if !self.name.isEmpty {
            destinationPath += "\(self.name)"
        }
        
        return destinationPath
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.destinationPath = try container.decodeIfPresent(String.self, forKey: .destinationPath) ?? ""
        self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? File.defaultSource
        self.sourceBranch = try container.decodeIfPresent(String.self, forKey: .sourceBranch)
        self.sourcePath = try container.decodeIfPresent(String.self, forKey: .sourcePath) ?? ""
        self.sourceTag = try container.decodeIfPresent(String.self, forKey: .sourceTag)
    }
}
