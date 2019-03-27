//
//  ViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/26/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var textField1: UITextField?
    var textField2: UITextField?
    
    var fileManager = FM()
    var url: URL?
    var listUrl = [URL]()
    var lastUrl = [URL]()
    
    var files = [String]()
    var filteredFiles = [String]()
    var temporaryPath = String()
    
    lazy var searchController = UISearchController(searchResultsController: nil)
    
    #warning("Main method for get list of URLS")
    func updateListsURLS() {
        
        listUrl = fileManager.getListUrl(lastUrl[lastUrl.count - 1])
        print("Debugger message: func updateListsURLS() - \(listUrl)")
        
        files = []
        files.insert("..", at: 0)
        
        for i in listUrl {
            files.append(fileManager.getNameByUrl(i))
        }
        
        files.sort()
        
        print("Debugger message: - files in array - \(files)")
        
        UIView.transition(with: tableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() }) // left out the unnecessary syntax in the completion block a
        //        tableView.reloadData()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        
        createSearchBarController()
        
        // FM Start directory
        print("Debugger message: Home documents directory URL is - \(fileManager.getUrl(fileManager.path))")
        
        // Get Start URL
        url = fileManager.getUrl(fileManager.path)
        
        // Add start url path
        lastUrl.append(url!)
        
        // Get Array of list URLS
        listUrl = fileManager.getListUrl(url!)
        
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
    
}

extension ViewController {
    
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
        temporaryPath = lastUrl[lastUrl.count - 1].path + "/" + (self.textField1!.text ?? "Folder")
        fileManager.createDir(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryPath)))
        updateListsURLS()
    }
    
    #warning("Need fix to create files in all directories")
    func createNewFile() {
        temporaryPath = lastUrl[lastUrl.count - 1].path + "/" + (self.textField1?.text ?? "File.txt")
        fileManager.createFile(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryPath)))
        updateListsURLS()
    }
    
    func getCopy() {
        let temporaryCopyPathFirst = lastUrl[lastUrl.count - 1].path + "/" + (self.textField1?.text ?? "Copy.txt")
        print("FIRST - \(temporaryCopyPathFirst)")
        let temporaryCopyPathSecond = lastUrl[lastUrl.count - 1].path + "/" + (self.textField2?.text ?? "Copy2.txt")
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

extension ViewController {
    
    // MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return filteredFiles.count
        } else {
            return files.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = .blue
        
        if searchController.isActive {
            cell.textLabel?.text = filteredFiles[indexPath.row]
            return cell
        } else {
        
        // Convert URL to string
        cell.textLabel?.text = files[indexPath.row]
        return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take text form didSelectRowAt indexPath
        let cell = self.tableView.cellForRow(at: indexPath)
        
        #warning("Add spacebar for folders and jumping it")
        
        // Create id for Jump
        let id = fileManager.getIdUrlByName(fileManager.getListUrl(lastUrl[lastUrl.count - 1]), ((cell?.textLabel!.text)!))
        print("Debugger message: - ID is \(id)")
        
        if (cell?.textLabel!.text)! == ".." && lastUrl.count > 1 {
            lastUrl.remove(at: lastUrl.count - 1)
            updateListsURLS()
            
        } else if id != -1 {
            lastUrl.append(listUrl[id])
            updateListsURLS()
            
            print("Debugger message: - Last URL is \(lastUrl)")
        }
        
    }
    
    //MARK: - Delete files and folders
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if editingStyle == .delete {
            temporaryPath = lastUrl[lastUrl.count - 1].path + "/" + ((cell?.textLabel!.text)!)
            fileManager.removeFile(fileManager.getUrl(fileManager.getLocalPathByFull(temporaryPath)))
            updateListsURLS()
        }
        
    }
    
}


extension ViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        filteredFiles.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (files as NSArray).filtered(using: searchPredicate)
        filteredFiles = array as! [String]
        self.tableView.reloadData()
    }
}
