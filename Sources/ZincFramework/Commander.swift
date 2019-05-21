//
//  Commander.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Foundation

class Commander {
    static let shared = Commander()
    
    @discardableResult
    func shell(_ command: String) -> String {
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
}

// https://stackoverflow.com/questions/55678902/attempting-to-clone-a-git-repository-via-swift-encounters-a-protocol-violation
