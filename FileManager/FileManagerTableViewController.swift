//
//  ViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/26/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerTableViewController: UITableViewController {
    
    var fileManager = FM()
    var storage = FileManagerStorage()
    var alert = Alert()
    var fileManagerActions = FileManagerActions()
    lazy var searchController = UISearchController(searchResultsController: nil)
    
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)
        
        createSearchBarController()
        
        // FM Start directory
        print("Debugger message: Home documents directory URL is - \(fileManager.getUrl(storage.path))")
        
        // Get Start URL
        FileManagerStorage.url = fileManager.getUrl(storage.path)
        
        // Add start url path
        FileManagerStorage.lastUrl.append(FileManagerStorage.url!)
        
        // Get Array of list URLS
        FileManagerStorage.listUrl = fileManager.getListUrl(FileManagerStorage.url!)
        
        // Start of List URLS\
        fileManagerActions.updateListsURLS()
        
        // Get Temp Path
        tableView.reloadData()
    }
    
    @objc func shouldReload() {
        UIView.transition(with: tableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
    }
    // MARK: - Actions
    
    @IBAction func refreshButtonAction(_ sender: UIBarButtonItem) {
        fileManagerActions.updateListsURLS()
    }
    
    @IBAction func addButtonAction(_ sender: UIBarButtonItem) {
        alert.createFolderAndFileMenu()
    }
    
}

extension FileManagerTableViewController {
    
    // MARK: - Data Source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File list"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive {
            return FileManagerStorage.filteredFiles.count
        } else {
            return FileManagerStorage.files.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.selectionStyle = .blue
        
        if searchController.isActive {
            cell.textLabel?.text = FileManagerStorage.filteredFiles[indexPath.row]
            return cell
        } else {
            cell.textLabel?.text = FileManagerStorage.files[indexPath.row]
            cell.detailTextLabel?.text = FileManagerStorage.urlSizer[indexPath.row]
            
            
            cell.imageView?.image = UIImage(named: "cloud-computing")
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Take text form didSelectRowAt indexPath
        let cell = self.tableView.cellForRow(at: indexPath)
        
        // Create id for Jump
        let id = fileManager.getIdUrlByName(fileManager.getListUrl(FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1]), ((cell?.textLabel!.text)!))
        print("Debugger message: - ID is \(id)")
        
        if (cell?.textLabel!.text)! == ".." && FileManagerStorage.lastUrl.count > 1 {
            FileManagerStorage.lastUrl.remove(at: FileManagerStorage.lastUrl.count - 1)
            FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getPath"), object: nil)
            fileManagerActions.updateListsURLS()
        } else if id != -1 {
            FileManagerStorage.lastUrl.append(FileManagerStorage.listUrl[id])
            FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getPath"), object: nil)
            fileManagerActions.updateListsURLS()
            print("Debugger message: - Last URL is \(FileManagerStorage.lastUrl)")
        } else if id == -1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getHomePath"), object: nil)
        }
        
    }
    
    //MARK: - Delete files and folders
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let cell = self.tableView.cellForRow(at: indexPath)
        
        if editingStyle == .delete {
            FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/" + ((cell?.textLabel!.text)!)
            
            if (cell?.textLabel!.text)! == ".." {
                FileManagerStorage.temporaryPath = FileManagerStorage.lastUrl[FileManagerStorage.lastUrl.count - 1].path + "/"
                alert.deleteAllDataInFolder()
            } else {
                fileManager.removeFile(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.temporaryPath)))
                print("Debugger message: - Delete is \((cell?.textLabel!.text)!)")
                fileManagerActions.updateListsURLS()
            }
        }
    }
}

extension FileManagerTableViewController: UISearchResultsUpdating {
    
    // MARK: - Update search results
    #warning("Fix perehod in next folder from filtered array")
    func updateSearchResults(for searchController: UISearchController) {
        FileManagerStorage.filteredFiles.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (FileManagerStorage.files as NSArray).filtered(using: searchPredicate)
        FileManagerStorage.filteredFiles = array as! [String]
        self.tableView.reloadData()
    }
}

extension FileManagerTableViewController {
    
    // MARK: - accessoryButtonTappedForRowWith
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        storage.index = indexPath.row
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetInfo" {
            guard let infoVC = segue.destination as? FileManagerInfoViewController else {
                return
            }
            infoVC.storage = storage
        } 
    }
}
