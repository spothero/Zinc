// Copyright © 2020 SpotHero, Inc. All rights reserved.

public protocol Subcommand: SubcommandUsageDescribing {
    static var name: String { get }
    
    init(from parser: ArgumentParser) throws
    
    func run() throws
}
