// Copyright © 2021 SpotHero, Inc. All rights reserved.

public enum Executable {
    case path(String)
    case shell(Shell)
    
    var path: String {
        switch self {
        case let .path(path):
            return path
        case let .shell(shell):
            return shell.rawValue
        }
    }
    
    var prependedArguments: [String]? {
        switch self {
        case .path:
            return nil
        case .shell:
            return ["-c"]
        }
    }
}

public enum Shell: String {
    case bash = "/bin/bash"
    case sh = "/bin/sh"
    case zsh = "/bin/zsh"
}
