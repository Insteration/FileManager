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
    @IBOutlet weak var leftMenuButton: UIButton!
    @IBOutlet weak var fileMenuButton: UIButton!
    @IBOutlet weak var commandMenuButton: UIButton!
    @IBOutlet weak var optionsMenuButton: UIButton!
    @IBOutlet weak var rightMenuButton: UIButton!
    
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
        
//        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
//        imageView.contentMode = .scaleAspectFit
//        let image = UIImage(named: "diskette.png")
//        imageView.image = image
//        navigationItem.titleView = imageView
        
        navigationItem.hidesSearchBarWhenScrolling = true
        navigationController?.navigationBar.prefersLargeTitles = false
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.shouldReload), name: NSNotification.Name(rawValue: "tableView.reloadRows"), object: nil)
        
        setupLeftMenuButton()
        setupFileMenuButton()
        setupCommandMenuButton()
        setupOptionsMenuButton()
        setupRightMenuButton()
        
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
        var headerName = ""
        switch tableView {
        case fileManagerTopTableView:
            headerName = "File list #1"
        case fileManagerBottomTableView:
            headerName = "File list #2"
        default:
            ()
        }
        return headerName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRow = 1
        switch tableView {
        case fileManagerTopTableView:
            if searchController.isActive {
//                numberOfRow = FileManagerStorage.topFilteredFiles.count
            } else {
                numberOfRow = FileManagerStorage.myTopFilesSorted.count
            }
        case fileManagerBottomTableView:
            numberOfRow = FileManagerStorage.myBottomFilesSorted.count
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
            
            if searchController.isActive {
//
//                //                cell.detailTextLabel?.isHidden = true
//                cell.textLabel?.text = FileManagerStorage.topFilteredFiles[indexPath.row]
//                //                cell.detailTextLabel?.text = FileManagerStorage.topUrlSizer[indexPath.row]
//                //                cell.detailTextLabel
//                if cell.textLabel?.text == ".." {
//                    cell.accessoryType = .none
//                    cell.detailTextLabel?.isEnabled = false
//                } else {
//                    cell.accessoryType = .detailButton
//                }
            } else {

                cell.textLabel?.text = FileManagerStorage.myTopFilesSorted[indexPath.row].0
                
                cell.detailTextLabel?.text = FileManagerStorage.myTopFilesSorted[indexPath.row].1.fileSizeString
                
                if cell.textLabel?.text == ".." {
                    cell.accessoryType = .none
                    cell.detailTextLabel?.isHidden = true
                } else {
                    cell.accessoryType = .detailButton
                }
            }
            
        case fileManagerBottomTableView:
            cell = tableView.dequeueReusableCell(withIdentifier: "Bottom", for: indexPath)
            cell.textLabel?.text = FileManagerStorage.myBottomFilesSorted[indexPath.row].0
            cell.detailTextLabel?.text = FileManagerStorage.myBottomFilesSorted[indexPath.row].1.fileSizeString
            if cell.textLabel?.text == ".." {
                cell.accessoryType = .none
                cell.detailTextLabel?.isHidden = true
            } else {
                cell.accessoryType = .detailButton
            }
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
    
//    #warning("Fix perehod in next folder from filtered array")
    func updateSearchResults(for searchController: UISearchController) {
//        FileManagerStorage.topFilteredFiles.removeAll(keepingCapacity: false)
//        FileManagerStorage.topFilteredUrls.removeAll(keepingCapacity: false)
//        
//        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        //        let searchUrls = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
//        
//        let array = (FileManagerStorage.topFiles as NSArray).filtered(using: searchPredicate)
//        
//        
//        FileManagerStorage.topFilteredFiles = array as! [String]
//        FileManagerStorage.topFilteredFiles.insert("..", at: 0)
//        
//        //        FileManagerStorage.topFilteredUrls = urlArray as! [URL]
//        //        FileManagerStorage.topFilteredUrls.forEach { print ("URL ---------------------------------- \($0)")}
//        //
//        fileManagerTopTableView.reloadData()
    }
    
}

extension FileManagerMainViewController {
    
    // MARK: - accessoryButtonTappedForRowWith
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if searchController.isActive {
//            storage.topFilteringOrNot = true
//            storage.topSortIndex = indexPath.row
//            print("storage index set up on - \(storage.topSortIndex)")
        } else {
            storage.topFilteringOrNot = false
            switch tableView {
            case fileManagerTopTableView:
                storage.topIndex = indexPath.row
                print("Main View Controller index = \(storage.topIndex)")
            case fileManagerBottomTableView:
                storage.bottomIndex = indexPath.row
            default:
                ()
            }
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

extension FileManagerMainViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    
    private func setupLeftMenuButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped1))
        tapGesture.numberOfTapsRequired = 1
        leftMenuButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupFileMenuButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped2))
        tapGesture.numberOfTapsRequired = 1
        fileMenuButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupCommandMenuButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped3))
        tapGesture.numberOfTapsRequired = 1
        commandMenuButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupOptionsMenuButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped4))
        tapGesture.numberOfTapsRequired = 1
        optionsMenuButton.addGestureRecognizer(tapGesture)
    }
    
    private func setupRightMenuButton() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped5))
        tapGesture.numberOfTapsRequired = 1
        rightMenuButton.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped1() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "FileManagerLeftTableViewController") else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.leftMenuButton
        popOverVC?.sourceRect = CGRect(x: self.leftMenuButton.bounds.midX, y: self.leftMenuButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    @objc private func tapped2() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "FileManagerFileTableViewController") else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.fileMenuButton
        popOverVC?.sourceRect = CGRect(x: self.fileMenuButton.bounds.midX, y: self.fileMenuButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    @objc private func tapped3() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "FileManagerCommandTableViewController") else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.commandMenuButton
        popOverVC?.sourceRect = CGRect(x: self.commandMenuButton.bounds.midX, y: self.commandMenuButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    @objc private func tapped4() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "FileManagerOptionsTableViewController") else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.optionsMenuButton
        popOverVC?.sourceRect = CGRect(x: self.optionsMenuButton.bounds.midX, y: self.optionsMenuButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
    @objc private func tapped5() {
        guard let popVC = storyboard?.instantiateViewController(withIdentifier: "FileManagerLeftTableViewController") else { return }
        popVC.modalPresentationStyle = .popover
        let popOverVC = popVC.popoverPresentationController
        popOverVC?.delegate = self
        popOverVC?.sourceView = self.rightMenuButton
        popOverVC?.sourceRect = CGRect(x: self.rightMenuButton.bounds.midX, y: self.rightMenuButton.bounds.minY, width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        self.present(popVC, animated: true)
    }
    
}
