// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public typealias YamlDictionary = [String: String]

public struct Zincfile: Codable {
    // MARK: Enums
    
    enum CodingKeys: String, CodingKey {
        case files
        case source
        case sourceBranch = "source_branch"
        case sourceTag = "source_tag"
        case tools
        case variables
    }
    
    // MARK: Parsed Properties
    
    public let files: [File]
    public let source: String
    public let sourceBranch: String?
    public let sourceTag: String?
    public let tools: [Tool]
    public let variables: YamlDictionary
    
    // MARK: Methods
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.files = try container.decodeIfPresent([File].self, forKey: .files) ?? []
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.sourceBranch = try container.decodeIfPresent(String.self, forKey: .sourceBranch) ?? ""
        self.sourceTag = try container.decodeIfPresent(String.self, forKey: .sourceTag) ?? ""
        self.tools = try container.decodeIfPresent([Tool].self, forKey: .tools) ?? []
        self.variables = try container.decodeIfPresent(YamlDictionary.self, forKey: .variables) ?? [:]
    }
}
