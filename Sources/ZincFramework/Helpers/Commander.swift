// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

class Commander {
    static let shared = Commander()

    @discardableResult
    func bash(_ command: String) -> String {
        let task = Process()
        task.launchPath = "/bin/bash"
        task.arguments = ["-c", command]

        let pipe = Pipe()
        task.standardOutput = pipe
//        task.standardError = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)

        task.waitUntilExit()

        return output!
    }

    @discardableResult
    func gitClone(_ url: String, branch: String? = nil, directory: String? = nil) -> String {
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

        return Commander.shared.bash(command)
    }

    @discardableResult
    func gitClone(_ url: String, tag: String, directory: String? = nil) -> String {
        return self.gitClone(url, branch: tag, directory: directory)
    }

    // TODO: Add clone by commit
    // func gitClone(_ url: String, commit: String, directory: String? = nil) -> String {
    //     // $ git clone $URL
    //     // $ cd $PROJECT_NAME
    //     // $ git reset --hard $SHA1
    // }
}

// https://stackoverflow.com/questions/55678902/attempting-to-clone-a-git-repository-via-swift-encounters-a-protocol-violation
