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
    @IBOutlet weak var useDarkThemeSwitch: UISwitch!
    @IBOutlet var fileManagerConfigurationTableView: UITableView!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var showTipsCell: UITableViewCell!
    @IBOutlet weak var useDarkCell: UITableViewCell!
    @IBOutlet weak var showTipsLabel: UILabel!
    @IBOutlet weak var useDarkThemeLabel: UILabel!
    
    let fileManagerUserDefaultsSettings = FileManagerUserDefaultsSettings()
    let alert = Alert()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            useDarkThemeSwitch.isOn = true
            self.view.backgroundColor = .darkGray
            fileManagerConfigurationTableView.backgroundColor = .darkGray
            self.navigationController?.navigationBar.barTintColor = .darkGray
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            backButton.tintColor = .white
            showTipsCell.backgroundColor = .darkGray
            useDarkCell.backgroundColor = .darkGray
            showTipsLabel.textColor = .white
            useDarkThemeLabel.textColor = .white
        } else {
            useDarkThemeSwitch.isOn = false
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            fileManagerConfigurationTableView.backgroundColor = .white
            backButton.tintColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
            showTipsCell.backgroundColor = .white
            useDarkCell.backgroundColor = .white
            showTipsLabel.textColor = .black
            useDarkThemeLabel.textColor = .black
        }
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fileManagerUserDefaultsSettings.entryPoint = false
        fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()

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
    
    @IBAction func useDarkThemeSwitchAction(_ sender: UISwitch) {
        if useDarkThemeSwitch.isOn {
            FileManagerUserDefaultsSettings.useDarkTheme = true
            alert.restartApp()
        } else {
            FileManagerUserDefaultsSettings.useDarkTheme = false
            alert.restartApp()
        }
        fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()
        print(FileManagerUserDefaultsSettings.useDarkTheme)
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Configuration menu list"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 13)!

        if FileManagerUserDefaultsSettings.useDarkTheme {
            header.textLabel?.textColor = .white
        } else {
            header.textLabel?.textColor = .gray
        }
    }
    
}
