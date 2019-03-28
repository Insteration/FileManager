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
    static var files = [String]()
    static var filteredFiles = [String]()
    var index = 0
    static var url: URL?
    static var listUrl = [URL]()
    static var lastUrl = [URL]()
    static var temporaryPath = String()
    static var urlSizer = [String]()
}
