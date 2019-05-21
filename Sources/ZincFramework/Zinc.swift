//
//  Zinc.swift
//  Zinc
//
//  Created by Brian Drelling on 5/20/2019.
//  Copyright © 2019 Brian Drelling. All rights reserved.
//

import Files
import Foundation
import Yams

public class Zinc {
    public static func sync(_ file: String = "Zincfile") {
        guard
            let text = FileClerk.read(file: file),
            let Zincfile: Zincfile = Farmer.shared.deserialize(text) else {
                Lumberjack.shared.log("Unable to sync \(file).", level: .error)
                return
        }
        
        // create the temporary directory
        FileClerk.createTempDirectory()
        
        // clone the sources
        for (key, repoURL) in Zincfile.allSources {
            Commander.shared.shell("git clone \(repoURL) \(FileClerk.tempDirectory)/\(key)")
        }
        
        // update all files
        for file in Zincfile.files {
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
        
        // delete the temporary directory
        FileClerk.removeTempDirectory()
        
    }
    
    public static func lint(_ file: String = "Zincfile") {
        guard let text = FileClerk.read(file: file) else {
            return
        }
        
        print(text)
        
        guard let Zincfile: Zincfile = Farmer.shared.deserialize(text) else {
            return
        }
        
        // check for warnings
        // TODO: Check for duplicate sources
        
        // pretty print the result
        do {
            let encodedFile = try YAMLEncoder().encode(Zincfile)
            print(encodedFile)
        } catch {
            Lumberjack.shared.log(error)
        }
    }
}
