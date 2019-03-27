//
//  ViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/26/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerTableViewController: UITableViewController {
    
    var textField1: UITextField?
    var textField2: UITextField?
    
    var fileManager = FM()
    var storage = FileMangerStorage()
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    fileprivate func updateListsURLS() {
        
        storage.listUrl = fileManager.getListUrl(storage.lastUrl[storage.lastUrl.count - 1])
        print("Debugger message: func updateListsURLS() - \(storage.listUrl)")
        
        storage.files = []
        storage.files.insert("..", at: 0)
        
        
        for i in storage.listUrl {
            storage.files.append(fileManager.getNameByUrl(i))
        }
        
        storage.files.sort()
        
        print("Debugger message: - files in array - \(storage.files)")
        
        UIView.transition(with: tableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
    }
    
    fileprivate func createSearchBarController() {
        // Add searchbar
        searchController = {
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.obscuresBackgroundDuringPresentation = false
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search"
            controller.searchBar.barStyle = .default
            controller.searchBar.sizeToFit()
            navigationItem.searchController = controller
            definesPresentationContext = true
            return controller
        }()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        createSearchBarController()
        
        // FM Start directory
        print("Debugger message: Home documents directory URL is - \(fileManager.getUrl(storage.path))")
        
        // Get Start URL
        storage.url = fileManager.getUrl(storage.path)
        
        // Add start url path
        storage.lastUrl.append(storage.url!)
        
        // Get Array of list URLS
        storage.listUrl = fileManager.getListUrl(storage.url!)
        
        // Start of List URLS
        updateListsURLS()
        
        
    }
    
    // MARK: - Actions
    
    @IBAction func refreshButtonAction(_ sender: UIBarButtonItem) {
        updateListsURLS()
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        createFolderAndFileMenu()
    }
    
    @IBAction func sizeAction(_ sender: UIBarButtonItem) {
        for i in storage.listUrl {
            print("Filesize is - \(i.fileSize), \(i.fileSizeString) ")
        }
    }
}

extension FileManagerTableViewController {
    
    //MARK: - Create new fodler or file or copy
    
    private func createFolderAndFileMenu() {
        let alert = UIAlertController(title: "File Manager Menu", message: "Please choose what you need.", preferredStyle: .alert)
        let file = UIAlertAction(title: "File", style: .default, handler: {_ in self.createNewFileAlertController()} )
        let folder = UIAlertAction(title: "Folder", style: .default, handler: {_ in self.createNewFolderAlertController() })
        let copy = UIAlertAction(title: "Copy", style: .default, handler: {_ in self.createCopy() })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(file)
        alert.addAction(folder)
        alert.addAction(copy)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    private func createNewFileAlertController() {
        let alert = UIAlertController(title: "Create new file", message: "Enter file name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.createNewFile() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    #warning("Need add creating file with intro text")
    private func createNewFolderAlertController() {
        let alert = UIAlertController(title: "Create new folder", message: "Enter folder name", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in self.createNewFolder() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    private func createCopy() {
        let alert = UIAlertController(title: "Copy menu", message: "Enter first name of file and then second name for new file", preferredStyle: .alert)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in self.getCopy() }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Create new file and folder
    
    func createNewFolder() {
        storage.temporaryPath = storage.lastUrl[storage.lastUrl.count - 1].path + "/" + (self.textField1!.text ?? "Folder")
        fileManager.createDir(fileManager.getUrl(fileManager.getLocalPathByFull(storage.temporaryPath)))
        updateListsURLS()
    }
    
    func createNewFile() {
        storage.temporaryPath = storage.lastUrl[storage.lastUrl.count - 1].path + "/" + (self.textField1?.text ?? "File.txt")
        fileManager.createFile(fileManager.getUrl(fileManager.getLocalPathByFull(storage.temporaryPath)))
        updateListsURLS()
    }
    
    func getCopy() {
        let temporaryCopyPathFirst = storage.lastUrl[storage.lastUrl.count - 1].path + "/" + (self.textField1?.text ?? "Copy.txt")
        print("FIRST - \(temporaryCopyPathFirst)")
        let temporaryCopyPathSecond = storage.lastUrl[storage.lastUrl.count - 1].path + "/" + (self.textField2?.text ?? "Copy2.txt")
        print("SECOND - \(temporaryCopyPathSecond)")
        
        fileManager.copyFile(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathFirst)), fileManager.getUrl(fileManager.getLocalPathByFull(temporaryCopyPathSecond)))
        updateListsURLS()
    }
    
    //MARK: - Add TextField Delegate for UIAlertController
    
    private func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField1 = textField!        //Save reference to the UITextField
            self.textField1?.placeholder = "Type name here"
            self.textField2 = textField!
            self.textField2?.placeholder = "And here"
        }
    }
    
}

extension FileManagerTableViewController {
    
    // MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File list"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return storage.filteredFiles.count
        } else {
            return storage.files.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = .blue
        
        if searchController.isActive {
            cell.textLabel?.text = storage.filteredFiles[indexPath.row]
            return cell
        } else {
            
            // Convert URL to string
            cell.textLabel?.text = storage.files[indexPath.row]
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take text form didSelectRowAt indexPath
        let cell = self.tableView.cellForRow(at: indexPath)
                
        // Create id for Jump
        let id = fileManager.getIdUrlByName(fileManager.getListUrl(storage.lastUrl[storage.lastUrl.count - 1]), ((cell?.textLabel!.text)!))
        print("Debugger message: - ID is \(id)")
        
        if (cell?.textLabel!.text)! == ".." && storage.lastUrl.count > 1 {
            storage.lastUrl.remove(at: storage.lastUrl.count - 1)
            updateListsURLS()
            
        } else if id != -1 {
            storage.lastUrl.append(storage.listUrl[id])
            updateListsURLS()
            
            print("Debugger message: - Last URL is \(storage.lastUrl)")
        }
        
    }
    
    //MARK: - Delete files and folders
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if editingStyle == .delete {
            storage.temporaryPath = storage.lastUrl[storage.lastUrl.count - 1].path + "/" + ((cell?.textLabel!.text)!)
            
            if (cell?.textLabel!.text)! == ".." {
                storage.temporaryPath = storage.lastUrl[storage.lastUrl.count - 1].path + "/"
                
                let alert = UIAlertController(title: "Delete all files in folder", message: "Are you sure?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ _ in  self.fileManager.removeFile(self.fileManager.getUrl(self.fileManager.getLocalPathByFull(self.storage.temporaryPath)))
                    self.updateListsURLS()
                }))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                
                
                fileManager.removeFile(fileManager.getUrl(fileManager.getLocalPathByFull(storage.temporaryPath)))
                print("Debugger message: - Delete is \((cell?.textLabel!.text)!)")
                updateListsURLS()
            }
            
        }
    }
    
}


extension FileManagerTableViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        storage.filteredFiles.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (storage.files as NSArray).filtered(using: searchPredicate)
        storage.filteredFiles = array as! [String]
        self.tableView.reloadData()
    }
}

extension FileManagerTableViewController {
    
    // MARK: - accessoryButtonTappedForRowWith
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        storage.index = indexPath.row
        print(indexPath.row)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetInfo" {
            guard let infoVC = segue.destination as? InfoViewController else {
                return
            }
            infoVC.storage = storage
        }
    }
}
