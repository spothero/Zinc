

public struct CommandContext {
    let command: String?
    let subcommand: String?
    let arguments: [String]?
    let options: [String: String]?
}