// Copyright © 2020 SpotHero, Inc. All rights reserved.

import CommandHero
import Foundation
import Lumberjack

class TestSubcommand: Subcommand {
    // MARK: - Properties
    
    // MARK: Command Metadata
    
    public static var name = "test"
    public static var usageDescription = "This command is used for testing CommandHero in the debug build configuration."
    public static var arguments: [ArgumentDescribing] = [Arguments.name]
    public static var options: [OptionDescribing] = [Options.build, Options.dope, Options.file, Options.version]
    
    // MARK: Arguments
    
    public struct Arguments {
        static let name = Argument<String>(index: 0, name: "name", description: "The name of the test.")
    }
    
    private let name: String?
    
    // MARK: Options
    
    public struct Options {
        static let build = Option<Int>("build", shortName: "b", description: "The build number for the test.")
        static let dope = Option<Bool>("dope", shortName: "d", defaultValue: false, description: "Determines whether or not the test subcommand is dope.")
        static let file = Option<String>("file", shortName: "f", description: "Accepts a file to try to parse.")
        static let version = Option<Double>("version", shortName: "v", description: "The major.minor version number for the test.")
    }
    
    private let build: Int?
    private let isDope: Bool
    private let file: String?
    private let version: Double?
    
    // MARK: - Methods
    
    // MARK: Initializers
    
    public required init(from parser: ArgumentParser) throws {
        self.name = try parser.value(for: Arguments.name)
        
        self.file = try parser.valueIfPresent(for: Options.file)
        self.version = try parser.valueIfPresent(for: Options.version)
        self.build = try parser.valueIfPresent(for: Options.build)
        self.isDope = try parser.value(for: Options.dope)
    }
    
    // MARK: Subcommand
    
    public func run() throws {
        Lumberjack.shared.log([
            String(describing: self.name),
            String(describing: self.file),
            String(describing: self.version),
            String(describing: self.build),
            self.isDope,
        ])
    }
}
