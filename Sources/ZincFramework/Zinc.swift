//
//  Zinc.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Foundation
import Yams

extension String {
    private var legalRepositoryCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=")
    }

    private var legalURLCharacterSet: CharacterSet {
        return CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~:/?#[]@!$&'()*+,;=")
    }

    var isValidURL: Bool {
        // we only want to do bare minimum validation to understand if the user is trying to enter a URL or not

        // if the string contains illegal characters, it's not a valid URL
        guard self.rangeOfCharacter(from: legalURLCharacterSet.inverted) == nil else {
            // TODO: throw error
            return false
        }

        // if the characters are lega
        guard self.hasPrefix("http://") || self.hasPrefix("https://") else {
            // TODO: throw error
            return false
        }
        
        return true
    }

    var isValidRepository: Bool {
        // accepted characters in a repo are: alphanumeric and hyphen
        // all we want are legal characters separated by a slash
        let regex = #"\b^[a-zA-Z0-9\-]+/[a-zA-Z0-9\-]+$\b"#

        return self.range(of: regex, options: .regularExpression) != nil
    }

    var repositoryName: String {
        let regex = #"([a-zA-Z0-9\-]+/[a-zA-Z0-9\-]+)(?:.git)?$"#

        let range = self.range(of: regex, options: .regularExpression)

        print(range)

        // return self[range]
        return self
    }

    var sourceType: SourceType {
        if self.isValidRepository {
            return .repository
        } else if self.isValidURL {
            return .url
        } else if self.isEmpty {
            return .default
        } else {
            return .invalid
        }
    }
}

public enum SourceType {
    case `default`
    case repository
    case url
    case invalid
}

public class Zinc {
    public static let shared = Zinc()

    public func sync(_ file: String = "Zincfile") {
        guard
            let text = FileClerk.read(file: file),
            let zincfile: Zincfile = Farmer.shared.deserialize(text) else {
                Lumberjack.shared.log("Unable to sync \(file).", level: .error)
                return
        }
        
        // create the temporary directory
        FileClerk.createTempDirectory(deleteExisting: true)
        
        // // clone the sources
        // for (key, repoURL) in Zincfile.allSources {
        //     // --branch can specify a branch or tag
        //     // --single-branch 
        //     var branch = ""
        //     Commander.shared.shell("git clone --branch \(branch) --single-branch \(repoURL) \(FileClerk.tempDirectory)/\(key)")
        // }

        // clone the default repo first
        self.cloneDefaultRepository(zincfile)

        // aggregate the sources into a master dictionary
        self.cloneFileRepositories(zincfile)

        // sync all the files
        self.syncFiles(zincfile)
        
        // delete the temporary directory
        FileClerk.removeTempDirectory()
        
    }

    private func cloneDefaultRepository(_ zincfile: Zincfile) {
        guard !zincfile.source.isEmpty else {
            Lumberjack.shared.debug("No default repository to sync.")
            return
        }

        Lumberjack.shared.debug("Syncing default source...")

            var url: String

            switch zincfile.source.sourceType {
                case .default:
                    // it should be impossible to reach this point
                    Lumberjack.shared.report("Default source is empty.")
                    return 
                case .repository:
                    url = "https://github.com/\(zincfile.source).git"
                case .url:
                    url = zincfile.source
                case .invalid:
                    // TODO: throw error
                    return
            }

            var directory = "\(FileClerk.tempDirectory)/default"

            Lumberjack.shared.debug("Cloning default (\(url)) into \(directory)...")

            Commander.shared.gitClone(url, 
                                      branch: zincfile.sourceBranch ?? zincfile.sourceTag, 
                                      directory: directory)
    }

    private func cloneFileRepositories(_ zincfile: Zincfile) {
        guard !zincfile.files.isEmpty else {
            Lumberjack.shared.report("Error: Files not found.")
            return
        }

        Lumberjack.shared.debug("Cloning sources for \(zincfile.files.count) files...")

        for file in zincfile.files {
            var name: String
            var url: String

            switch file.source.sourceType {
                case .default:
                    // nothing to do here if we use the default source for this file
                    continue 
                case .repository:
                    name = file.source
                    url = "https://github.com/\(file.source).git"
                case .url:
                    name = file.source.repositoryName
                    url = file.source
                case .invalid:
                    Lumberjack.shared.report("Invalid source: \(file.source)")
                    continue
            }

            var directory = "\(FileClerk.tempDirectory)/\(name)"

            if let branch = file.sourceBranch ?? file.sourceTag, !branch.isEmpty {
                directory += "/\(branch)"
            }

            Lumberjack.shared.debug("Cloning \(name) (\(url)) into \(directory)...")

            Commander.shared.gitClone(url, 
                                      branch: file.sourceBranch ?? file.sourceTag, 
                                      directory: directory)
        }
    }

    private func syncFiles(_ zincfile: Zincfile) {
        Lumberjack.shared.debug("Syncing \(zincfile.files.count) files...")
        
        // update all files
        for file in zincfile.files {
            // get full source path
            let fullSourcePath = "\(FileClerk.tempDirectory)/\(file.fullSourcePath)"
            
            // get full destination path
            var fullDestinationPath = file.fullDestinationPath
            
            // if there's no file name property, use the filename from the source path
            if file.name.isEmpty {
                let filename = FileClerk.filename(for: fullSourcePath)
                fullDestinationPath += "\(filename)"
            }
            
            // copy file into destination location
            FileClerk.copyItem(from: fullSourcePath, to: fullDestinationPath)
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
