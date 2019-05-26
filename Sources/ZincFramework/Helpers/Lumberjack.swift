// Copyright © 2019 SpotHero. All rights reserved.

import Foundation
// import os.log

typealias LumberjackCompletion = () throws -> Void

class Lumberjack {
    static let shared = Lumberjack()

    private static let debugPrefix = "⚙"

    var isDebugEnabled = true

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
    enum Color: Int, CaseIterable {
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
            return "\(Color.prefix)\(self.rawValue)\(Color.suffix)"
        }

        var brightCode: String {
            return "\(Color.prefix)\(self.rawValue)\(Color.boldModifier)\(Color.suffix)"
        }
    }

    enum LogLevel {
        case message
        case warning
        case error
        case debug
    }

    // MARK: Logging

    func log(_ item: Any, level: LogLevel = .message) {
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

    func debug(_ item: Any) {
        self.log(item, level: .debug)
    }

    func warn(_ item: Any) {
        self.log(item, level: .warning)
    }

    func report(_ error: Error, message: String? = nil) {
        self.log(error, message: message)
    }

    func report(_ messages: String...) {
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

    private func print(_ message: String, inColor color: Color?, bright: Bool = false) {
        guard let color = color else {
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
