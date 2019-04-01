//
//  FileManagerActions.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerActions {
    
    var fileManager = FM()

    func updateTopListsURLS() {
        
        FileManagerStorage.topListUrl = fileManager.getListUrl(FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1])
        FileManagerStorage.myTopFiles.removeAll()

        FileManagerStorage.topListUrl.forEach{ FileManagerStorage.myTopFiles.updateValue($0, forKey: fileManager.getNameByUrl($0)) }

        FileManagerStorage.myTopFilesSorted = FileManagerStorage.myTopFiles.sorted(by: { $0.0 < $1.0 })
        FileManagerStorage.myTopFilesSorted.insert((key: "..", value: URL(string: "..")!), at: 0)
        
//        FileManagerStorage.topUrlSizer = []
//        FileManagerStorage.topUrlSizer.insert(" ", at: 0)
//        FileManagerStorage.myTopFilesSorted.forEach { FileManagerStorage.topUrlSizer.append($1.fileSizeString)}
//        FileManagerStorage.topUrlSizer.forEach {print("URL size - \($0)") }
        
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)

    }
    
    func updateBottomListsURLS() {
  
        FileManagerStorage.bottomListUrl = fileManager.getListUrl(FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1])
        FileManagerStorage.myBottomFiles.removeAll()
        
        
        FileManagerStorage.bottomListUrl.forEach { FileManagerStorage.myBottomFiles.updateValue($0, forKey: fileManager.getNameByUrl($0)) }
        
        FileManagerStorage.myBottomFilesSorted = FileManagerStorage.myBottomFiles.sorted(by: { $0.0 < $1.0 })
        FileManagerStorage.myBottomFilesSorted.insert((key: "..", value: URL(string: "..")!), at: 0)
        
//        FileManagerStorage.bottomUrlSizer = []
//        FileManagerStorage.bottomUrlSizer.insert(" ", at: 0)
//        FileManagerStorage.myBottomFilesSorted.forEach { FileManagerStorage.bottomUrlSizer.append($1.fileSizeString)}
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)
        
    }
    
    func createNewFolder(_ textField: String) {
        FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/" + textField
        fileManager.createDir(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))
        updateTopListsURLS()
        updateBottomListsURLS()
    }
    
    func createNewFile(_ textField: String) {
        FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/" + textField
        fileManager.createFile(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))
        updateTopListsURLS()
        updateBottomListsURLS()
    }
    
    func getCopy(_ textfieldFirst: String, _ textFieldSecond: String) {
        let temporaryCopyPathFirst = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/" + textfieldFirst
        print("Debugger message: - temporaryCopyPathFirst - \(temporaryCopyPathFirst)")
        let temporaryCopyPathSecond = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/" + textFieldSecond
        print("Debugger message: - temporaryCopyPathSecond - \(temporaryCopyPathSecond)")
        fileManager.copyFile(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathFirst)), fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathSecond)))
        updateTopListsURLS()
        updateBottomListsURLS()
    }
}
