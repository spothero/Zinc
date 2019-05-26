// Copyright © 2019 SpotHero. All rights reserved.

class LintCommand: Command {
    func run() throws {
        self.lint()
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

    // public static func lint(_ file: String = "Zincfile") {
    //     guard let text = FileClerk.read(file: file) else {
    //         return
    //     }

    //     print(text)

    //     guard let Zincfile: Zincfile = Farmer.shared.deserialize(text) else {
    //         return
    //     }

    //     // check for warnings
    //     // TODO: Check for duplicate sources

    //     // pretty print the result
    //     do {
    //         let encodedFile = try YAMLEncoder().encode(Zincfile)
    //         print(encodedFile)
    //     } catch {
    //         Lumberjack.shared.log(error)
    //     }
    // }
}
