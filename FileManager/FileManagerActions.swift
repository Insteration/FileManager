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

    func updateListsURLS() {
        
        FileManagerStorage.listUrl = fileManager.getListUrl(FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1])
        FileManagerStorage.files = []
        FileManagerStorage.files.insert("..", at: 0)
        
        FileManagerStorage.listUrl.forEach { FileManagerStorage.files.append(fileManager.getNameByUrl($0)) }
        
        //FIXME: - Not working url index with sorted string array
        //        storage.files.sorted()
        
        FileManagerStorage.urlSizer = []
        FileManagerStorage.urlSizer.insert(" ", at: 0)
        FileManagerStorage.listUrl.forEach { FileManagerStorage.urlSizer.append($0.fileSizeString)}
        
        print("Debugger message: - url sizer is - \(FileManagerStorage.urlSizer)")
        print("Debugger message: - files in array - \(FileManagerStorage.files)")
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)
    }
    
    func createNewFolder(_ textField: String) {
        FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/" + textField
        fileManager.createDir(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.temporaryPath)))
        updateListsURLS()
    }
    
    func createNewFile(_ textField: String) {
        FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/" + textField
        fileManager.createFile(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.temporaryPath)))
        updateListsURLS()
    }
    
    func getCopy(_ textfieldFirst: String, _ textFieldSecond: String) {
        let temporaryCopyPathFirst = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/" + textfieldFirst
        print("Debugger message: - temporaryCopyPathFirst - \(temporaryCopyPathFirst)")
        let temporaryCopyPathSecond = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/" + textFieldSecond
        print("Debugger message: - temporaryCopyPathSecond - \(temporaryCopyPathSecond)")
        fileManager.copyFile(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathFirst)), fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathSecond)))
        updateListsURLS()
    }
}
