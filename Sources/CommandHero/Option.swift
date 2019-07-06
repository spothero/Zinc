public struct Option<T> {
    let name: String
    let shortName: String

    var value: T?

    init(_ name: String, _ shortName: String) {
        self.name = name
        self.shortName = shortName
    }
}