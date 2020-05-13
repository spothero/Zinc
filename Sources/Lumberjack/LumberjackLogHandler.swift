// Copyright © 2020 SpotHero, Inc. All rights reserved.

#if canImport(Logging)
    
    import Logging
    
    public struct LumberjackLogHandler: LogHandler {
        public var metadata: Logger.Metadata = [:]
        public var logLevel: Logger.Level = .debug
        
        public subscript(metadataKey key: String) -> Logger.Metadata.Value? {
            get {
                return self.metadata[key]
            }
            set {
                self.metadata[key] = newValue
            }
        }
        
        public func log(level: Logger.Level,
                        message: Logger.Message,
                        metadata: Logger.Metadata?,
                        file: String,
                        function: String,
                        line: UInt) {
            switch level {
            case .trace:
                Lumberjack.shared.log(message, file: file, line: line)
            case .debug:
                Lumberjack.shared.debug(message, file: file, line: line)
            case .info:
                Lumberjack.shared.log(message, file: file, line: line)
            case .notice:
                Lumberjack.shared.log(message, file: file, line: line)
            case .warning:
                Lumberjack.shared.warn(message, file: file, line: line)
            case .error:
                Lumberjack.shared.report(message, file: file, line: line)
            case .critical:
                Lumberjack.shared.report(message, file: file, line: line)
            }
        }
        
        public init() {}
    }
    
#endif
