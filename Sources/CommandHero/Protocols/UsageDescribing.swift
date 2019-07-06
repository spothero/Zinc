
public protocol UsageDescribing {
    static var usageDescription: String { get }
}

public extension UsageDescribing {
    func printUsageDescription() {
        UsageDescriber.shared.printUsageDescription(for: self)
    }
}