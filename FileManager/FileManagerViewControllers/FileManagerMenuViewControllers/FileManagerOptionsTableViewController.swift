//
//  FileManagerOptionsTableViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/30/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerOptionsTableViewController: UITableViewController {
    
    let fileManagerOptionsMenu = ["Configuration", "Layout", "Panel options", "Appearance", "Save setup"]
    let fileManagerOptionsImagesMenu = [UIImage(named: "settings-4"), UIImage(named: "transfer"), UIImage(named: "web-design"), UIImage(named: "favourites"), UIImage(named: "diskette-4")]
    lazy var mainVC = FileManagerMainViewController()
    lazy var fileManagerPreferencesActions = FileManagerPreferencesActions()
    lazy var alert = Alert()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            self.view.backgroundColor = .darkGray
            self.tableView.backgroundColor = .darkGray
        } else {
            self.view.backgroundColor = .white
            self.tableView.backgroundColor = .white
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preferredContentSize = CGSize(width: 250, height: tableView.contentSize.height)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fileManagerOptionsMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = fileManagerOptionsMenu[indexPath.row]
        cell.imageView?.image = fileManagerOptionsImagesMenu[indexPath.row]
        
         if FileManagerUserDefaultsSettings.useDarkTheme {
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .darkGray
         } else {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
     func teleportToConfigurationTableViewController() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fileManagerConfigurationVC = storyboard.instantiateViewController(withIdentifier: "ConfigurationVC") as! FileManagerConfigurationTableViewController
        let fileManagerNavController = UINavigationController(rootViewController: fileManagerConfigurationVC)
        present(fileManagerNavController, animated: true, completion: nil)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select row - \(indexPath.row)")
        FileManagerPreferences.fileManagerConfiguration = indexPath.row
        
        switch FileManagerPreferences.fileManagerConfiguration {
        case 0:
            teleportToConfigurationTableViewController()
        case 1:
            ()
        case 2:
            ()
        case 3:
            ()
        case 4: 
            alert.saveSetupOptions()
        default:
            ()
        }
    }
    
    
}

extension FileManagerOptionsTableViewController {
    
    // MARK: Segue
    
}
