//
//  Zincfile.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Foundation
import Yams

public typealias YamlDictionary = [String: String]

public class Zincfile: Codable {
    public enum Error: Swift.Error {
        case sourceConflict
    }
    
    public let source: String
    public let sources: YamlDictionary
    public let variables: YamlDictionary
    public let files: [File]
    
    public var allSources: YamlDictionary {
        guard !self.source.isEmpty else {
            return self.sources
        }
        
        return ["default" : source].merging(self.sources, uniquingKeysWith: { (first, _) in first })
    }
    
//    public var description: String {
//        do {
//            return try YAMLEncoder().encode(self)
//        } catch {
//            return String(describing: self)
//        }
//    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? ""
        self.sources = try container.decodeIfPresent(YamlDictionary.self, forKey: .sources) ?? [:]
        self.variables = try container.decodeIfPresent(YamlDictionary.self, forKey: .variables) ?? [:]
        self.files = try container.decodeIfPresent([File].self, forKey: .files) ?? []
    }
    
    public class File: Codable {
        static let defaultSource = "default"
        
        enum CodingKeys: String, CodingKey {
            case destinationPath = "destination_path"
            case name
            case source
            case sourcePath = "source_path"
        }
        
        let destinationPath: String
        let name: String
        let source: String
        let sourcePath: String
        
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
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            
            self.destinationPath = try container.decodeIfPresent(String.self, forKey: .destinationPath) ?? ""
            self.name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
            self.source = try container.decodeIfPresent(String.self, forKey: .source) ?? File.defaultSource
            self.sourcePath = try container.decodeIfPresent(String.self, forKey: .sourcePath) ?? ""
        }
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
