//
//  Lumberjack.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Foundation
//import os.log

typealias LumberjackCompletion = () throws -> Void

class Lumberjack {
    static let shared = Lumberjack()

    private static let debugPrefix = "⚙"

    var isDebugEnabled = true
    
    enum Color: String {
        case red = "\033[31m"
        case yellow = ""
        
        static var close = "\033[m"
    }
    
    enum LogLevel {
        case message
        case warning
        case error
        case debug
    }
    
    func log(_ message: String, level: LogLevel = .message) {
        guard level != .debug || self.isDebugEnabled else {
            return
        }

        let color = getColor(for: level)
        printColored(message, color: color)
    }
    
    func log(_ error: Error, level: LogLevel = .error) {
        log(error.localizedDescription, level: level)
    }

    func debug(_ message: String) {
        log("\(Lumberjack.debugPrefix) \(message)", level: .debug)
    }

    func warn(_ message: String) {
        log(message, level: .warning)
    }

    func report(_ message: String) {
        log(message, level: .error)
    }

    func report(_ error: Error) {
        log(error)
    }
    
    private func printColored(_ message: String, color: Color?) {
        guard let color = color else {
            print(message)
            return
        }
        
        print("\(color.rawValue)\(message)\(Color.close)")
    }
    
    private func getColor(for level: LogLevel) -> Color? {
        switch level {
        case .message,
             .debug:
            return nil
        case .warning:
            return .yellow
        case .error:
            return .red
        }
    }
    
//    static func handle(_ completion: LumberjackCompletion) {
//        do {
//            try completion()
//        } catch {
//            print(error)
//        }
//    }
}
