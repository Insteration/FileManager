//
//  FileManagerPathViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerTopPathViewController: UIViewController {

    @IBOutlet weak var pathHeaderLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    
    var fileManager = FM()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            self.view.backgroundColor = .darkGray
            pathLabel.textColor = .white
            pathHeaderLabel.textColor = .white
        } else {
            self.view.backgroundColor = .white
            pathLabel.textColor = .black
            pathHeaderLabel.textColor = .black
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getNewPath), name: NSNotification.Name(rawValue: "getTopPath"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHomePath), name: NSNotification.Name(rawValue: "getTopHomePath"), object: nil)
        
    }
    
    @objc func getNewPath() {
        pathLabel.text = "Documents" + fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)
        print("directoryExistsAtPath \(fileManager.directoryExistsAtPath(fileManager.getLocalPathByFull(FileManagerStorage.topTemporaryPath)))")
    }
    
    @objc func getHomePath() {
        pathLabel.text = "Documents/"
    }
}
