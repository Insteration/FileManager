//
//  FileManagerStorage.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/27/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import Foundation

class FileManagerStorage {
    let path = ""
    
    static var topFiles = [String]()
    static var topFilteredFiles = [String]()
    var topIndex = 0
    static var topUrl: URL?
    static var topListUrl = [URL]()
    static var topLastUrl = [URL]()
    static var topTemporaryPath = String()
    static var topUrlSizer = [String]()
    
    static var bottomFiles = [String]()
    static var bottomFilesFilteredFiles = [String]()
    var bottomIndex = 0
    static var bottomUrl: URL?
    static var bottomListUrl = [URL]()
    static var bottomLastUrl = [URL]()
    static var bottomTemporaryPath = String()
    static var bottomUrlSizer = [String]()
}
