// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

public class ProcessRunner {
    // MARK: Shared Instance
    
    public static let shared = ProcessRunner()
    
    // MARK: Enums
    
    public enum Error: Swift.Error {
        case generic(String)
        case noOutput
    }
    
    // MARK: Methods
    
    public init() {}
    
    @discardableResult
    public func run(
        _ executable: Executable,
        arguments: [String]? = nil,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) throws -> String {
        try ConfiguredProcess(
            executable: executable,
            arguments: arguments,
            environment: environment,
            workingDirectory: workingDirectory
        ).run()
    }
    
    @discardableResult
    public func run(
        _ command: String,
        with executable: Executable = .shell(.bash),
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) throws -> String {
        return try self.run(
            executable,
            arguments: [command],
            environment: environment,
            workingDirectory: workingDirectory
        )
    }
    
    @discardableResult
    public func gitClone(_ url: String, branch: String? = nil, directory: String? = nil) throws -> String {
        var command = "git clone"
        
        if let branch = branch, branch.isEmpty == false {
            // --branch can specify a branch or tag
            // --single-branch
            command += " --branch \(branch) --single-branch"
        }
        
        command += " \(url)"
        
        if let directory = directory, directory.isEmpty == false {
            command += " \(directory)"
        }
        
        Lumberjack.shared.debug("Executing `bash \(command)`")
        
        return try self.run(command)
    }
    
    @discardableResult
    public func gitClone(_ url: String, tag: String, directory: String? = nil) throws -> String {
        return try self.gitClone(url, branch: tag, directory: directory)
    }
    
    // TODO: Add clone by commit
    // func gitClone(_ url: String, commit: String, directory: String? = nil) -> String {
    //     // $ git clone $URL
    //     // $ cd $PROJECT_NAME
    //     // $ git reset --hard $SHA1
    // }
}

// MARK: - Extensions

// https://stackoverflow.com/questions/55678902/attempting-to-clone-a-git-repository-via-swift-encounters-a-protocol-violatio

extension ProcessRunner.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .generic(message):
            return message
        case .noOutput:
            return "No output returned!"
        }
    }
}
