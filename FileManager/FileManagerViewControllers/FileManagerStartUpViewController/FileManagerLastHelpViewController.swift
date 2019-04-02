//
//  FileManagerLastHelpViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 4/2/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerLastHelpViewController: UIViewController {

    @IBOutlet weak var showHelpTipsSwitch: UISwitch!
    @IBOutlet weak var startUseFileManagerButton: UIButton!
    
    let fileManagerUserDefaultsSettings = FileManagerUserDefaultsSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if showHelpTipsSwitch.isOn {
            fileManagerUserDefaultsSettings.entryPoint = false
            fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()
        }
    }
    
    @IBAction func showHelpTipsSwitchAction(_ sender: UISwitch) {
        if showHelpTipsSwitch.isOn {
            fileManagerUserDefaultsSettings.entryPoint = false
        } else {
            fileManagerUserDefaultsSettings.entryPoint = true
        }
        fileManagerUserDefaultsSettings.writeToUserDefaultsEntryPoint()
        print(fileManagerUserDefaultsSettings.entryPoint)
    }
}
