//
//  FileManagerMainViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/29/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerMainViewController: UIViewController {
    
    @IBOutlet weak var fileManagerTopTableView: UITableView!
    @IBOutlet weak var fileManagerBottomTableView: UITableView!
    
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
        
        
        //        createSearchBarController()
        
        // FM Start directory
        print("Debugger message: Home documents directory URL is - \(fileManager.getUrl(storage.path))")
        
        // Get Start URL
        FileManagerStorage.topUrl = fileManager.getUrl(storage.path)
        FileManagerStorage.bottomUrl = fileManager.getUrl(storage.path)
        
        // Add start url path
        FileManagerStorage.topLastUrl.append(FileManagerStorage.topUrl!)
        FileManagerStorage.bottomLastUrl.append(FileManagerStorage.bottomUrl!)
        
        // Get Array of list URLS
        FileManagerStorage.topListUrl = fileManager.getListUrl(FileManagerStorage.topUrl!)
        FileManagerStorage.bottomListUrl = fileManager.getListUrl(FileManagerStorage.bottomUrl!)
        
        
        // Start of List URLS\
        fileManagerActions.updateTopListsURLS()
        fileManagerActions.updateBottomListsURLS()
        
        // Get Temp Path
        fileManagerTopTableView.reloadData()
        fileManagerBottomTableView.reloadData()
        
        fileManagerTopTableView.delegate = self
        fileManagerTopTableView.dataSource = self
        fileManagerBottomTableView.delegate = self
        fileManagerBottomTableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func fileManagerMenuButton(_ sender: UIBarButtonItem) {
        alert.createFolderAndFileMenu()
    }
    
    @IBAction func fileManagerRefreshButton(_ sender: UIBarButtonItem) {
        fileManagerActions.updateTopListsURLS()
        fileManagerActions.updateBottomListsURLS()
    }
    
    @objc func shouldReload() {
        UIView.transition(with: fileManagerTopTableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.fileManagerTopTableView.reloadData() })
        UIView.transition(with: fileManagerBottomTableView, duration: 0.15, options: .transitionCrossDissolve, animations: { self.fileManagerBottomTableView.reloadData() })
    }
    
}

extension FileManagerMainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File list"
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case fileManagerTopTableView:
            numberOfRow = FileManagerStorage.topFiles.count
        case fileManagerBottomTableView:
            numberOfRow = FileManagerStorage.bottomFiles.count
        default:
            ()
        }
        return numberOfRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        switch tableView {
        case fileManagerTopTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "Top", for: indexPath)
            cell.textLabel?.text = FileManagerStorage.topFiles[indexPath.row]
            cell.detailTextLabel?.text = FileManagerStorage.topUrlSizer[indexPath.row]
        case fileManagerBottomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "Bottom", for: indexPath)
            cell.textLabel?.text = FileManagerStorage.bottomFiles[indexPath.row]
            cell.detailTextLabel?.text = FileManagerStorage.bottomUrlSizer[indexPath.row]
        default:
            ()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch tableView {
        case fileManagerTopTableView:
            let topCell = self.fileManagerTopTableView.cellForRow(at: indexPath)
            let topId = fileManager.getIdUrlByName(fileManager.getListUrl(FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1]), ((topCell?.textLabel!.text)!))
            print("Debugger message: - TOPID is \(topId)")
            
            // Top
            if (topCell?.textLabel!.text)! == ".." && FileManagerStorage.topLastUrl.count > 1 {
                FileManagerStorage.topLastUrl.remove(at: FileManagerStorage.topLastUrl.count - 1)
                FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getTopPath"), object: nil)
                fileManagerActions.updateTopListsURLS()
            } else if topId != -1 {
                FileManagerStorage.topLastUrl.append(FileManagerStorage.topListUrl[topId])
                FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getTopPath"), object: nil)
                fileManagerActions.updateTopListsURLS()
                print("Debugger message: - Last TOP URL is \(FileManagerStorage.topLastUrl)")
            } else if topId == -1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getTopHomePath"), object: nil)
            }
            
        case fileManagerBottomTableView:
            let bottomCell = self.fileManagerBottomTableView.cellForRow(at: indexPath)
            let bottomId = fileManager.getIdUrlByName(fileManager.getListUrl(FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1]), ((bottomCell?.textLabel!.text)!))
            print("Debugger message: - BOTTOMID is \(bottomId)")
            
            // Bottom
            if (bottomCell?.textLabel!.text)! == ".." && FileManagerStorage.bottomLastUrl.count > 1 {
                FileManagerStorage.bottomLastUrl.remove(at: FileManagerStorage.bottomLastUrl.count - 1)
                FileManagerStorage.bottomTemporaryPath = FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1].path
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getBottomPath"), object: nil)
                fileManagerActions.updateBottomListsURLS()
            } else if bottomId != -1 {
                FileManagerStorage.bottomLastUrl.append(FileManagerStorage.bottomListUrl[bottomId])
                FileManagerStorage.bottomTemporaryPath = FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1].path
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getBottomPath"), object: nil)
                fileManagerActions.updateBottomListsURLS()
                print("Debugger message: - Last BOTTOM URL is \(FileManagerStorage.bottomLastUrl)")
            } else if bottomId == -1 {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getBottomHomePath"), object: nil)
            }
        default:
            ()
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    //MARK: - Delete files and folders
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch tableView {
        case fileManagerTopTableView:
            let cell = fileManagerTopTableView.cellForRow(at: indexPath)
            
            if editingStyle == .delete {
                FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/" + ((cell?.textLabel!.text)!)
                
                if (cell?.textLabel!.text)! == ".." {
                    FileManagerStorage.topTemporaryPath = FileManagerStorage.topLastUrl[FileManagerStorage.topLastUrl.count - 1].path + "/"
                    alert.deleteAllDataInTopFolder()
                } else {
                    fileManager.removeFile(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))
                    print("Debugger message: - TOP Delete is \((cell?.textLabel!.text)!)")
                    fileManagerActions.updateTopListsURLS()
                    fileManagerActions.updateBottomListsURLS()
                }
            }
            
        case fileManagerBottomTableView:
            let cell = self.fileManagerBottomTableView.cellForRow(at: indexPath)
            
            if editingStyle == .delete {
                FileManagerStorage.bottomTemporaryPath = FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1].path + "/" + ((cell?.textLabel!.text)!)
                
                if (cell?.textLabel!.text)! == ".." {
                    FileManagerStorage.bottomTemporaryPath = FileManagerStorage.bottomLastUrl[FileManagerStorage.bottomLastUrl.count - 1].path + "/"
                    alert.deleteAllDataInBottomFolder()
                } else {
                    fileManager.removeFile(fileManager.getUrl(fileManager.getLocalPathByFull(FileManagerStorage.bottomTemporaryPath)))
                    print("Debugger message: - BOTTOM Delete is \((cell?.textLabel!.text)!)")
                    fileManagerActions.updateTopListsURLS()
                    fileManagerActions.updateBottomListsURLS()
                }
            }
            
        default:
            ()
        }
    }
    
    
}

extension FileManagerMainViewController: UISearchResultsUpdating {
    
    // MARK: - Update search results
    
    #warning("Fix perehod in next folder from filtered array")
    func updateSearchResults(for searchController: UISearchController) {
        //        FileManagerStorage.topFilteredFiles.removeAll(keepingCapacity: false)
        //        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        //        let array = (FileManagerStorage.topFiles as NSArray).filtered(using: searchPredicate)
        //        FileManagerStorage.topFilteredFiles = array as! [String]
        //        self.tableView.reloadData()
    }
    
}

extension FileManagerMainViewController {
    
    // MARK: - accessoryButtonTappedForRowWith
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        
        switch tableView {
        case fileManagerTopTableView:
            storage.topIndex = indexPath.row
        case fileManagerBottomTableView:
            storage.bottomIndex = indexPath.row
        default:
            ()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetTopInfo" {
            guard let infoVC = segue.destination as? FileManagerTopInfoViewController else {
                return
            }
            infoVC.storage = storage
        } else if segue.identifier == "GetBottomInfo" {
            guard let infoVC = segue.destination as? FileManagerBottomInfoViewController else {
                return
            }
            infoVC.storage = storage
        }
    }
}