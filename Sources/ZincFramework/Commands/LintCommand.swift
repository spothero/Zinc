// Copyright © 2019 SpotHero. All rights reserved.

import Foundation

class LintCommand: Command {
    typealias Options = LintOptions
    
    func run(with options: Options) throws {
        self.lint()
    }
    
    func run(with args: [String]) {
        let options = LintOptions()
        
//        Lumberjack.shared.log("Properties: \(options.properties)")
    }

    public func lint(_ filename: String? = nil) {
        do {
            guard let zincfile = try ZincfileParser.shared.fetch(filename) else {
                return
            }

            Lumberjack.shared.log("\(String(describing: zincfile.filename)) linted successfully.")
        } catch {
            Lumberjack.shared.report(error, message: "Unable to lint Zincfile.")
        }
    }
}

struct LintOptions: CommandOptions {
    var file: Option<String> = Option(key: "file",
                                      usage: "Specifies the Zincfile to parse.",
                                      abbreviation: "f",
                                      isRequired: true)
}

protocol CommandOptions: PropertyReflecting {
    
}

//protocol CommandOption {
//    var key: String { get }
//    var abbreviation: String? { get }
//    var description: String { get }
//    var defaultValue: T? { get }
//}

class Option<T>: NSObject {
    let key: String
    let abbreviation: Character?
    let defaultValue: T?
    let usage: String
    let isRequired: Bool
    
    var value: T?
    
    init(key: String,
         usage: String,
         abbreviation: Character? = nil,
         defaultValue: T? = nil,
         isRequired: Bool = false) {
        self.key = key
        self.usage = usage
        self.abbreviation = abbreviation
        self.defaultValue = defaultValue
        self.isRequired = isRequired
    }
    
    func set(value: Any?, forKey key: String) {
//        self.setValue(value, forKey: key)
    }
    
}
