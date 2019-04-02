//
//  FileManagerUserDefaultsSettings.swift
//  FileManager
//
//  Created by Artem Karmaz on 4/2/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import Foundation

class FileManagerUserDefaultsSettings {
    
    var userDefaults = UserDefaults.standard
    
    var entryPoint = true
    let entryPointKey = "entryPointKey"
    
    func writeToUserDefaultsEntryPoint() {
        userDefaults.set(entryPoint, forKey: entryPointKey)
    }
    
    func readFormUserDefaults() {
        entryPoint = userDefaults.bool(forKey: entryPointKey)
    }

}
