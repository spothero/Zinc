//
//  Zincfile.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Foundation

public typealias YamlDictionary = [String: String]

public class Zincfile: Codable {
    public enum Error: Swift.Error {
        case sourceConflict
    }

    enum CodingKeys: String, CodingKey {
        case files
        case source
        case sourceBranch = "source_branch"
        case sourceTag = "source_tag"
        case variables
    }

    public let files: [File]
    public let source: String
    public let sourceBranch: String?
    public let sourceTag: String?
    public let variables: YamlDictionary

    // public var allSources: YamlDictionary {
    //     guard !self.source.isEmpty else {
    //         return self.sources
    //     }

    //     return ["default" : source].merging(self.sources, uniquingKeysWith: { (first, _) in first })
    // }

//    public var description: String {
//        do {
//            return try YAMLEncoder().encode(self)
//        } catch {
//            return String(describing: self)
//        }
//    }

    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.files = try container.decodeIfPresent([File].self, forKey: .files) ?? []
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.sourceBranch = try container.decodeIfPresent(String.self, forKey: .sourceBranch) ?? ""
        self.sourceTag = try container.decodeIfPresent(String.self, forKey: .sourceTag) ?? ""
        self.variables = try container.decodeIfPresent(YamlDictionary.self, forKey: .variables) ?? [:]
    }
}

extension Zincfile.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .sourceConflict:
            return "Unable to parse source(s). 'source' and 'sources' cannot both be specificed."
        }
    }
}
