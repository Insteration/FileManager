//
//  FileManagerFileTableViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/30/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerFileTableViewController: UITableViewController {
    
    let fileManagerFilesMenu = ["View", "Edit", "Copy", "Link", "Create new file", "Delete"]
    let fileManagerFileImagesMenu = [UIImage(named: "files"), UIImage(named: "data"), UIImage(named: "copy"), UIImage(named: "link"), UIImage(named: "add-file"), UIImage(named: "delete")]
    lazy var mainVC = FileManagerMainViewController()
    
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

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return fileManagerFilesMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = fileManagerFilesMenu[indexPath.row]
        cell.imageView?.image = fileManagerFileImagesMenu[indexPath.row]
        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            cell.textLabel?.textColor = .white
            cell.backgroundColor = .darkGray
        } else {
            cell.textLabel?.textColor = .black
            cell.backgroundColor = .white
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileManagerMenuCommand"), object: nil)
    }
}
