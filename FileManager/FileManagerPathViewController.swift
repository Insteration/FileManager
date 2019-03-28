//
//  FileManagerPathViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/28/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerPathViewController: UIViewController {

    @IBOutlet weak var pathHeaderLabel: UILabel!
    @IBOutlet weak var pathLabel: UILabel!
    
    var fileManager = FM()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(getNewPath), name: NSNotification.Name(rawValue: "getPath"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(getHomePath), name: NSNotification.Name(rawValue: "getHomePath"), object: nil)
        
    }
    
    @objc func getNewPath() {
        pathLabel.text = "Documents" + fileManager.getLocalPathByFull(FileManagerStorage.temporaryPath)
    }
    
    @objc func getHomePath() {
        pathLabel.text = "Documents"
    }
}
