//
//  FileManager+Extensions.swift
//  SwiftPoetry
//
//  Created by Dominic Campbell on 22/10/2024.
//

import Foundation

extension FileManager {
    func createDirectoryIfRequired(_ url: URL) throws {
        let fm = FileManager.default
        var isDir: ObjCBool = true
        if fm.fileExists(atPath: url.path, isDirectory: &isDir) == false {
            if isDir.boolValue == false {
                try fm.removeItem(at: url)
            }
            try fm.createDirectory(at: url, withIntermediateDirectories: true)
        }
    }
    func createRequiredIntermediateDirectories(_ url: URL) throws {
        try createDirectoryIfRequired(url.deletingLastPathComponent())
    }
}
