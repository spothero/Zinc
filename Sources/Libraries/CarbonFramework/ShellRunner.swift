// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation

public class ShellRunner {
    public static let shared = ShellRunner()
    
    public init() {}
    
    public enum Error: Swift.Error {
        case generic(String)
        case noOutput
    }
    
    public enum Shell: String {
        case bash = "/bin/bash"
        case zsh = "/bin/zsh"
    }
    
    @discardableResult
    public func run(_ command: String, from shell: Shell = .bash) throws -> String {
        let task = Process()
        
        switch shell {
        case .bash:
            task.launchPath = "/bin/bash"
            task.arguments = ["-c", command]
        case .zsh:
            task.launchPath = "/bin/zsh"
            task.arguments = ["-c", command]
        }
        
        // Set the pipe for stdout
        let outputPipe = Pipe()
        task.standardOutput = outputPipe
        
        // Set the pipe for stderr
        let errorPipe = Pipe()
        task.standardError = errorPipe
        
        // Runs the task
        task.launch()
        
        // Read the stdout data and convert to a string
        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: outputData, encoding: .utf8)
        
        // Read the stderr data and convert to a string
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
        let error = String(data: errorData, encoding: .utf8)
        
        task.waitUntilExit()
        
        // If there's an error, throw an error
        // Eventually we might want this to be returned for parsing, but for now we'll treat it as a command failure
        if let error = error, !error.isEmpty {
            throw Error.generic(error)
        }
        
        // If there's no putput, throw an error
        // Successful commands should still return empty output, so treat this as a command failure as well
        guard let unwrappedOutput = output else {
            throw Error.noOutput
        }
        
        return unwrappedOutput
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

// https://stackoverflow.com/questions/55678902/attempting-to-clone-a-git-repository-via-swift-encounters-a-protocol-violatio

extension ShellRunner.Error: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .generic(message):
            return message
        case .noOutput:
            return "No output returned!"
        }
    }
}
