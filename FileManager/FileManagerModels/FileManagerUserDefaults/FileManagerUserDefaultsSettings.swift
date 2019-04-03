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
    static var useDarkTheme = false
    let entryPointKey = "entryPointKey"
    let useDarkThemeKey = "useDarkTheme"
    
    func writeToUserDefaultsEntryPoint() {
        userDefaults.set(entryPoint, forKey: entryPointKey)
        userDefaults.set(FileManagerUserDefaultsSettings.useDarkTheme, forKey: useDarkThemeKey)
    }
    
    func readFormUserDefaults() {
        entryPoint = userDefaults.bool(forKey: entryPointKey)
        FileManagerUserDefaultsSettings.useDarkTheme = userDefaults.bool(forKey: useDarkThemeKey)
    }

}
