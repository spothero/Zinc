// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
// import os.log

public typealias LumberjackCompletion = () throws -> Void

// Should we update to use TerminalController for printing colors?
// https://github.com/apple/swift-tools-support-core/blob/master/Sources/TSCBasic/TerminalController.swift

public class Lumberjack {
    public static let shared = Lumberjack()
    
    private static let debugPrefix = "⚙"
    
    public var isDebugEnabled = false
    public var shouldLogFileAndLineNumber = true
    
    /// Represents ANSI color escape codes.
    ///
    /// References:
    ///   - http://www.lihaoyi.com/post/BuildyourownCommandLinewithANSIescapecodes.html
    ///   - https://misc.flogisoft.com/bash/tip_colors_and_formatting
    public enum Color: Int, CaseIterable {
        case `default` = 39
        case black = 30
        case red = 31
        case green = 32
        case yellow = 33
        case blue = 34
        case magenta = 35
        case cyan = 36
        case white = 37
        case reset = 0
        
        // Black: \u001b[30m
        // Red: \u001b[31m
        // Green: \u001b[32m
        // Yellow: \u001b[33m
        // Blue: \u001b[34m
        // Magenta: \u001b[35m
        // Cyan: \u001b[36m
        // White: \u001b[37m
        // Reset: \u001b[0m
        
        // static var close = "\033[m"
        
        // TODO: Determine if this works in all terminals.
        //       Alternatives (via reference above): `\033["`, `\u001b[`
        private static let prefix = "\u{001B}[0;"
        
        private static let suffix = "m"
        private static let boldModifier = ";1"
        
        var code: String {
            return "\(Color.prefix)\(rawValue)\(Color.suffix)"
        }
        
        var brightCode: String {
            // TODO: Throw error if brightCode is used with .reset?
            
            return "\(Color.prefix)\(rawValue)\(Color.boldModifier)\(Color.suffix)"
        }
        
        init?(_ name: String) {
            guard let color = Color.allCases.first(where: { String(describing: $0) == name }) else {
                return nil
            }
            
            self = color
        }
    }
    
    public enum LogLevel {
        case message
        case warning
        case error
        case debug
        case success
    }
    
    public struct LogOption: OptionSet {
        public let rawValue: Int
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
        public static let prettyPrint = LogOption(rawValue: 1 << 0)
        
        public static let all: LogOption = [.prettyPrint]
    }
    
    // MARK: Logging
    
    public func log(_ item: Any,
                    level: LogLevel = .message,
                    options: LogOption = [],
                    file: String = #file,
                    line: UInt = #line) {
        guard level != .debug || self.isDebugEnabled else {
            return
        }
        
        let color = self.color(for: level)
        
        if let jsonObject = item as? Encodable, options.contains(.prettyPrint) {
            self.prettyPrint(jsonObject, inColor: color, file: file, line: line)
        } else {
            let message = String(describing: item)
            self.print(message, inColor: color, file: file, line: line)
        }
    }
    
    private func log(_ error: Error,
                     message: String? = nil,
                     level: LogLevel = .error,
                     options: LogOption = [],
                     file: String = #file,
                     line: UInt = #line) {
        let logMessage: String
        let errorMessage = ErrorCleaner.cleanedMessage(for: error)
        
        if let message = message {
            logMessage = "\(message) \(errorMessage)"
        } else {
            logMessage = errorMessage
        }
        
        self.log(logMessage, level: level, options: options, file: file, line: line)
    }
    
    // MARK: Convenience
    
    public func debug(_ item: Any, options: LogOption = [], file: String = #file, line: UInt = #line) {
        self.log(item, level: .debug, options: options, file: file, line: line)
    }
    
    public func warn(_ item: Any, options: LogOption = [], file: String = #file, line: UInt = #line) {
        self.log(item, level: .warning, options: options, file: file, line: line)
    }
    
    public func report(_ error: Error, message: String? = nil, options: LogOption = [], file: String = #file, line: UInt = #line) {
        self.log(error, message: message, options: options, file: file, line: line)
    }
    
    public func report(_ messages: String..., options: LogOption = [], file: String = #file, line: UInt = #line) {
        self.log(messages, level: .error, options: options, file: file, line: line)
    }
    
    public func success(_ item: Any, options: LogOption = [], file: String = #file, line: UInt = #line) {
        self.log(item, level: .success, options: options, file: file, line: line)
    }
    
    // MARK: Measuring
    
//    @discardableResult
//    func measure(_ closure: () -> Void) -> TimeInterval? {
//        // If debugging is not enabled, just fire the closure immediately
//        guard isDebugEnabled else {
//            closure()
//            return nil
//        }
//
//        // Start the stopwatch
//        let start = DispatchTime.now()
//
//        closure()
//
//        // End the stopwatch
//        let end = DispatchTime.now()
//
//        // Get the difference in nanoseconds
//        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
//
//        // Get the time interval in seconds
//        let seconds: TimeInterval = Double(nanoTime) / 1_000_000_000
//
//        self.debug("Time elapsed: \(seconds) seconds!")
//
//        return seconds
//    }
    
    // MARK: Utilities
    
    public func printFormatted(_ message: String) {
        var message = message
        
        for color in Color.allCases {
            let name = String(describing: color)
            
            // Opening tags for bold and color, in any order
            message = message.replacingOccurrences(of: "{\(name)}{bold}", with: color.brightCode)
            message = message.replacingOccurrences(of: "{bold}{\(name)}", with: color.brightCode)
            
            // Opening tag for ONLY color
            message = message.replacingOccurrences(of: "{\(name)}", with: color.code)
        }
        
        // If any standalone bold tags are left, use white bold
        message = message.replacingOccurrences(of: "{bold}", with: Color.default.brightCode)
        
        // Reset tag
        message = message.replacingOccurrences(of: "{reset}", with: Color.reset.code)
        
        Swift.print(message)
    }
    
    private func prettyPrint(_ jsonObject: Encodable, inColor color: Color?, bright: Bool = false, file: String = #file, line: UInt = #line) {
        do {
            let message = try jsonObject.toPrettyPrintedJSON() ?? String(describing: jsonObject)
            self.print(message, inColor: color, bright: bright, file: file, line: line)
        } catch {
            self.report(error)
        }
    }
    
    private func print(_ message: String, inColor color: Color?, bright: Bool = false, file: String = #file, line: UInt = #line) {
        // Make message mutable
        var message = message
        
        // Check if the log should include file and line number
        if self.isDebugEnabled, self.shouldLogFileAndLineNumber {
            // Try to strip the path and only get the filename
            let filename = file.split(separator: "/").last ?? ""
            
            // If the filename isn't empty, prepend the file and line number information
            if !filename.isEmpty {
                message = "[\(filename):\(line)] \(message)"
            }
        }
        
        // If color and brightness aren't set, just print the message normally
        guard let color = color, bright == false else {
            Swift.print(message)
            return
        }
        
        let colorCode = bright ? color.brightCode : color.code
        
        Swift.print("\(colorCode)\(message)\(Color.reset.code)")
    }
    
    private func print(_ messages: [String], inColor color: Color?, file: String = #file, line: UInt = #line) {
        for message in messages {
            self.print(message, inColor: color, file: file, line: line)
        }
    }
    
    private func color(for level: LogLevel) -> Color? {
        switch level {
        case .debug:
            return .blue
        case .message:
            return nil
        case .warning:
            return .yellow
        case .error:
            return .red
        case .success:
            return .green
        }
    }
    
    // MARK: Testing
    
    // TODO: Hide behind testing macro
    public func testColors() {
        for color in Color.allCases {
            self.print("Wow!", inColor: color)
        }
    }
    
    public func testBrightColors() {
        for color in Color.allCases {
            self.print("Wow!", inColor: color, bright: true)
        }
    }
}

private extension Encodable {
    func toPrettyPrintedJSON() throws -> String? {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let jsonData = try encoder.encode(self)
        return String(data: jsonData, encoding: .utf8)
    }
}
