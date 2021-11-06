// Copyright © 2021 SpotHero, Inc. All rights reserved.

import Foundation

struct ConfiguredProcess {
    private let process = Process()
    private let outputPipe = Pipe()
    
    init(
        executable: Executable,
        arguments: [String]? = nil,
        environment: [String: String]? = nil,
        workingDirectory: String? = nil
    ) throws {
        // Set the executable path for the process.
        self.process.executableURL = URL(fileURLWithPath: executable.path)
        
        // Set arguments for the process.
        self.process.arguments = (executable.prependedArguments ?? []) + (arguments ?? [])
        
        // Load environment variables into the process.
        self.process.environment = environment
        
        // Set the working directory for the process.
        if let workingDirectory = workingDirectory {
            self.process.currentDirectoryURL = URL(fileURLWithPath: workingDirectory, isDirectory: true)
        }
        
        // Set the pipe for stdout, and stderr
        self.process.standardOutput = self.outputPipe
    }
    
    func run() throws -> String {
        // Run the process.
        try self.process.run()
        
        // Create variables for our stdout and stderr data.
        let outputData: Data
        
        // Read the stdout, and stderr data.
        if #available(macOS 10.15.4, *) {
            outputData = try self.outputPipe.fileHandleForReading.readToEnd() ?? Data()
        } else {
            outputData = self.outputPipe.fileHandleForReading.readDataToEndOfFile()
        }
        
        // Convert data to strings.
        let output = String(data: outputData, encoding: .utf8)
        
        // If there's no putput, throw an error
        // Successful commands should still return empty output, so treat this as a command failure as well
        guard let unwrappedOutput = output else {
            throw ProcessRunner.Error.noOutput
        }
        
        return unwrappedOutput
    }
}
