//
//  FileManagerConfigurationTableViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 4/2/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerConfigurationTableViewController: UITableViewController {
    
    @IBOutlet weak var showTipsSwitch: UISwitch!
    
    let fileManagerUserDefaultsSettings = FileManagerUserDefaultsSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if showTipsSwitch.isOn {
            fileManagerUserDefaultsSettings.entryPoint = true
            fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showTipsSwitchAction(_ sender: UISwitch) {
        if showTipsSwitch.isOn {
            fileManagerUserDefaultsSettings.entryPoint = true
        } else {
            fileManagerUserDefaultsSettings.entryPoint = false
        }
        fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()
        print(fileManagerUserDefaultsSettings.entryPoint)
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Configuration menu list"
    }
    
}
