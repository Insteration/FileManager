//
//  FileManagerPreferencesActions.swift
//  FileManager
//
//  Created by Artem Karmaz on 4/2/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerPreferencesActions: FileManagerOptionsTableViewController {
    
    override func teleportToConfigurationTableViewController() {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let fileManagerConfigurationVC = storyboard.instantiateViewController(withIdentifier: "ConfigurationVC") as! FileManagerConfigurationTableViewController
        let fileManagerNavController = UINavigationController(rootViewController: fileManagerConfigurationVC)
        present(fileManagerNavController, animated: true, completion: nil)
    }
}

    
