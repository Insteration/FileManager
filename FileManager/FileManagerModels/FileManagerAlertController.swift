//
//  FileManagerAlertController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class Alert {
    
    var textField1: UITextField?
    var textField2: UITextField?
    var fileManagerActions = FileManagerActions()
    lazy var fileManager = FM()
    
     func createFolderAndFileMenu() {
        let alert = UIAlertController(title: "File Manager Menu", message: "Please choose what you need.", preferredStyle: .alert)
        let file = UIAlertAction(title: "File", style: .default, handler: {_ in self.createNewFileAlertController()} )
        let folder = UIAlertAction(title: "Folder", style: .default, handler: {_ in self.createNewFolderAlertController() })
        let copy = UIAlertAction(title: "Copy", style: .default, handler: {_ in self.createCopy() })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(copy)
        alert.addAction(cancel)
        alert.presentInOwnWindow(animated: true, completion: nil)
    }

     func createNewFileAlertController() {
        let alert = UIAlertController(title: "Create new file", message: "Enter file name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.fileManagerActions.createNewFile(self.textField1!.text!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }

//    #warning("Need add creating file with intro text")
     func createNewFolderAlertController() {
        let alert = UIAlertController(title: "Create new folder", message: "Enter folder name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.fileManagerActions.createNewFolder(self.textField1!.text!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }

     func createCopy() {
        let alert = UIAlertController(title: "Copy menu", message: "Enter first name of file and then second name for new file", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.fileManagerActions.getCopy(self.textField1!.text!, (self.textField2?.text!)!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func deleteAllDataInTopFolder() {
        let alert = UIAlertController(title: "Delete all files in folder", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  self.fileManager.removeFile(self.fileManager.getUrl(self.fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))
            self.fileManagerActions.updateTopListsURLS()
        }))
       alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func deleteAllDataInBottomFolder() {
        let alert = UIAlertController(title: "Delete all files in folder", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  self.fileManager.removeFile(self.fileManager.getUrl(self.fileManager.getLocalPathByFull(FileManagerStorage.bottomTemporaryPath)))
            self.fileManagerActions.updateBottomListsURLS()
        }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField1 = textField!        //Save reference to the UITextField
            self.textField1?.placeholder = "Type name here"
            self.textField2 = textField!
            self.textField2?.placeholder = "And here"
        }
    }
}
