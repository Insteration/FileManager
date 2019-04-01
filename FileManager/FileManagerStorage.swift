//
//  FileManagerStorage.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/27/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import Foundation

struct FileManagerStorage {
    
    let path = ""
    var topFilteringOrNot = false
    
    //  MARK: - Top File Manager Column
    
    static var myTopFiles = [String : URL]()
    static var myTopFilesSorted = [(key: String, value: URL)]()

    var topIndex = 0
    
    static var topUrl: URL?
    static var topListUrl = [URL]()
    static var topLastUrl = [URL]()
    static var topUrlSort = [URL]()
    static var topTemporaryPath = String()
    static var topUrlSizer = [String]()
    
    
    // MARK: - Bottom File Manager Column
    
    static var myBottomFiles = [String : URL]()
    static var myBottomFilesSorted = [(key: String, value: URL)]()
    
    var bottomIndex = 0
    
    static var bottomUrl: URL?
    static var bottomListUrl = [URL]()
    static var bottomLastUrl = [URL]()
    static var bottomTemporaryPath = String()
    static var bottomUrlSizer = [String]()
}
