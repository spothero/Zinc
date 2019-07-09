
public protocol OptionDescribing {
    var defaultValueDescription: String { get }
    var description: String? { get }
    var name: String { get }
    var shortName: String? { get }
    var usageDisplayName: String { get }
}

public extension OptionDescribing {
    var usageDisplayName: String {
        if let shortName = self.shortName {
            return "--\(self.name), -\(shortName)"
        } else {
            return "--\(self.name)"
        }
    }
}