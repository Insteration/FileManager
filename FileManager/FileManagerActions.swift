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
        FileManagerStorage.topFiles = []
        FileManagerStorage.topFiles.insert("..", at: 0)
   
        FileManagerStorage.topListUrl.forEach { FileManagerStorage.topFiles.append(fileManager.getNameByUrl($0)) }
        
        //FIXME: - Not working url index with sorted string array
        //        storage.files.sorted()
        
        FileManagerStorage.topUrlSizer = []
        FileManagerStorage.topUrlSizer.insert(" ", at: 0)
        FileManagerStorage.topListUrl.forEach { FileManagerStorage.topUrlSizer.append($0.fileSizeString)}

        print("Debugger message: - TOP url sizer is - \(FileManagerStorage.topUrlSizer)")
        print("Debugger message: - TOP files in array - \(FileManagerStorage.topFiles)")
        

        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)

    }
    
    func updateBottomListsURLS() {
  
        FileManagerStorage.bottomListUrl = fileManager.getListUrl(FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1])
        FileManagerStorage.bottomFiles = []
        FileManagerStorage.bottomFiles.insert("..", at: 0)
        
        FileManagerStorage.bottomListUrl.forEach { FileManagerStorage.bottomFiles.append(fileManager.getNameByUrl($0)) }
        
        //FIXME: - Not working url index with sorted string array
        //        storage.files.sorted()

        FileManagerStorage.bottomUrlSizer = []
        FileManagerStorage.bottomUrlSizer.insert(" ", at: 0)
        FileManagerStorage.bottomListUrl.forEach { FileManagerStorage.bottomUrlSizer.append($0.fileSizeString)}
        
        
        print("Debugger message: - BOTTOM url sizer is - \(FileManagerStorage.bottomUrlSizer)")
        print("Debugger message: - BOTTOM files in array - \(FileManagerStorage.bottomFiles)")
        
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
