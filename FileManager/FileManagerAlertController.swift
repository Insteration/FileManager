//
//  FileManagerAlertController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class Alert {
    func chek() {
        let alertController = UIAlertController(title: "<Alert Title>", message: "<Alert Message>", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        alertController.presentInOwnWindow(animated: true, completion: {
            print("completed")
        })
    }
    
    func createFolderAndFileMenu() {
        let alertController = UIAlertController(title: "File Manager Menu", message: "lease choose what you need.", preferredStyle: .alert)
//        alertController.addAction(<#T##action: UIAlertAction##UIAlertAction#>)

    }
    
//    private func createFolderAndFileMenu() {
//        let alert = UIAlertController(title: "File Manager Menu", message: "Please choose what you need.", preferredStyle: .alert)
//        let file = UIAlertAction(title: "File", style: .default, handler: {_ in self.createNewFileAlertController()} )
//        let folder = UIAlertAction(title: "Folder", style: .default, handler: {_ in self.createNewFolderAlertController() })
//        let copy = UIAlertAction(title: "Copy", style: .default, handler: {_ in self.createCopy() })
//        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
//        alert.addAction(file)
//        alert.addAction(folder)
//        alert.addAction(copy)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }
//
//    private func createNewFileAlertController() {
//        let alert = UIAlertController(title: "Create new file", message: "Enter file name", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: configurationTextField)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.createNewFile() }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    #warning("Need add creating file with intro text")
//    private func createNewFolderAlertController() {
//        let alert = UIAlertController(title: "Create new folder", message: "Enter folder name", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: configurationTextField)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.createNewFolder() }))
//        self.present(alert, animated: true, completion: nil)
//    }
//
//    private func createCopy() {
//        let alert = UIAlertController(title: "Copy menu", message: "Enter first name of file and then second name for new file", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: configurationTextField)
//        alert.addTextField(configurationHandler: configurationTextField)
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.getCopy() }))
//        self.present(alert, animated: true, completion: nil)
//    }
}
