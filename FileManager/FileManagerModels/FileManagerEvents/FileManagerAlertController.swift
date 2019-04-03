//
//  FileManagerAlertController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class Alert {
    
    var textField1:  UITextField?
    var textField2: UITextField?
    var fileManagerActions = FileManagerActions()
    lazy var fileManager = FM()
    
    func darkThemeForAlertController(_ alert: UIAlertController) {
        
        let subview :UIView = alert.view.subviews.first! as UIView
        let alertContentView = subview.subviews.first! as UIView
        alertContentView.layer.cornerRadius = 10
        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            alert.view.tintColor = .black
            alertContentView.backgroundColor = .gray
        } else {
            alertContentView.backgroundColor = .white
            alert.view.tintColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        }
    }
    
//    func darkThemeDisable(_ alert: UIAlertController) {
//
//        let subview :UIView = alert.view.subviews.first! as UIView
//        let alertContentView = subview.subviews.first! as UIView
//        alertContentView.layer.cornerRadius = 10
//
//        if FileManagerUserDefaultsSettings.useDarkTheme {
//            alertContentView.backgroundColor = .lightGray
//            alert.view.tintColor = .white
//            alert.view.tintColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
//        } else {
//            alert.view.tintColor = .white
//            alertContentView.backgroundColor = .lightGray
//        }
//    }
    
    func fileManagerQuickMenu() {
        
        
        let alert = UIAlertController(title: "File Manager Menu", message: "Please choose what you need.", preferredStyle: .alert)
//        darkThemeForAlertController(alert)

        let file = UIAlertAction(title: "File", style: .default, handler: {_ in self.createNewFileAlertController()} )
        let folder = UIAlertAction(title: "Folder", style: .default, handler: {_ in self.createNewFolderAlertController() })
        let copy = UIAlertAction(title: "Copy", style: .default, handler: {_ in self.createCopy() })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        darkThemeForAlertController(alert)

        
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(copy)
        alert.addAction(cancel)
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func createNewFileAlertController() {
        let alert = UIAlertController(title: "Create new file", message: "Enter file name", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.fileManagerActions.createNewFile(self.textField1!.text!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    //    #warning("Need add creating file with intro text")
    func createNewFolderAlertController() {
        let alert = UIAlertController(title: "Create new folder", message: "Enter folder name", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.fileManagerActions.createNewFolder(self.textField1!.text!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func createCopy() {
        let alert = UIAlertController(title: "Copy menu", message: "Enter first name of file and then second name for new file", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.fileManagerActions.getCopy(self.textField1!.text!, (self.textField2?.text!)!) }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func deleteAllDataInTopFolder() {
        let alert = UIAlertController(title: "Delete all files in folder", message: "Are you sure?", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  self.fileManager.removeFile(self.fileManager.getUrl(self.fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))
            self.fileManagerActions.updateTopListsURLS()
        }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func deleteAllDataInBottomFolder() {
        let alert = UIAlertController(title: "Delete all files in folder", message: "Are you sure?", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  self.fileManager.removeFile(self.fileManager.getUrl(self.fileManager.getLocalPathByFull(FileManagerStorage.bottomTemporaryPath)))
            self.fileManagerActions.updateBottomListsURLS()
        }))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
    
    func restartApp() {
        let alert = UIAlertController(title: "For the changes to take effect, application must restart", message: "Are you sure?", preferredStyle: .alert)
        
        darkThemeForAlertController(alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  Restart.restartApp()}))
        alert.presentInOwnWindow(animated: true, completion: nil)
    }
 
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField1 = textField!        //Save reference to the UITextField
            self.textField2 = textField!
            
            if FileManagerUserDefaultsSettings.useDarkTheme {
                self.textField1?.keyboardAppearance = .dark
                self.textField2?.keyboardAppearance = .dark
                self.textField1?.backgroundColor = .lightGray
                self.textField2?.backgroundColor = .lightGray
                self.textField1?.textColor = .white
                self.textField2?.textColor = .white
                self.textField1?.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
                self.textField2?.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])


            } else {
                self.textField1?.keyboardAppearance = .default
                self.textField2?.keyboardAppearance = .default
                self.textField1?.backgroundColor = .white
                self.textField2?.backgroundColor = .white
                self.textField1?.textColor = .black
                self.textField2?.textColor = .black
                self.textField1?.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
                self.textField2?.attributedPlaceholder = NSAttributedString(string: "Enter name", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
            }
        }
    }
}
