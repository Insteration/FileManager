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
        return fileManagerOptionsMenu.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = fileManagerOptionsMenu[indexPath.row]
        cell.imageView?.image = fileManagerOptionsImagesMenu[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FileManagerOptionsMenu"), object: nil)
    }
}
