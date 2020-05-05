// Copyright © 2020 SpotHero, Inc. All rights reserved.

import Foundation
// import os.log

public typealias LumberjackCompletion = () throws -> Void

public class Lumberjack {
    public static let shared = Lumberjack()
    
    private static let debugPrefix = "⚙"
    
    public var isDebugEnabled = true
    
//    Black: \u001b[30m
//    Red: \u001b[31m
//    Green: \u001b[32m
//    Yellow: \u001b[33m
//    Blue: \u001b[34m
//    Magenta: \u001b[35m
//    Cyan: \u001b[36m
//    White: \u001b[37m
//    Reset: \u001b[0m
    
    /// ANSI color escape codes
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
        
//        static var close = "\033[m"
        
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
    }
    
    // MARK: Logging
    
    public func log(_ item: Any, level: LogLevel = .message) {
        guard level != .debug || self.isDebugEnabled else {
            return
        }
        
        let message = String(describing: item)
        let color = self.color(for: level)
        
        self.print(message, inColor: color)
    }
    
    private func log(_ error: Error, message: String? = nil, level: LogLevel = .error) {
        let logMessage: String
        
        if let message = message {
            logMessage = "\(message) \(error.localizedDescription)"
        } else {
            logMessage = error.localizedDescription
        }
        
        self.log(logMessage, level: level)
    }
    
    // MARK: Convenience
    
    public func debug(_ item: Any) {
        self.log(item, level: .debug)
    }
    
    public func warn(_ item: Any) {
        self.log(item, level: .warning)
    }
    
    public func report(_ error: Error, message: String? = nil) {
        self.log(error, message: message)
    }
    
    public func report(_ messages: String...) {
        self.log(messages, level: .error)
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
    
    private func print(_ message: String, inColor color: Color?, bright: Bool = false) {
        // If color and brightness aren't set, just print the message normally
        guard let color = color, bright == false else {
            Swift.print(message)
            return
        }
        
        let colorCode = bright ? color.brightCode : color.code
        
        Swift.print("\(colorCode)\(message)\(Color.reset.code)")
    }
    
    private func print(_ messages: [String], inColor color: Color?) {
        for message in messages {
            self.print(message, inColor: color)
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
        }
    }
    
    // MARK: Testing
    
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
    
//    static func handle(_ completion: LumberjackCompletion) {
//        do {
//            try completion()
//        } catch {
//            print(error)
//        }
//    }
}
