//
//  FileManagerBottomViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/29/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerBottomInfoViewController: UITableViewController {
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var fileDateLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    var storage = FileManagerStorage()
    var fm = FM()
    
    fileprivate func showFileInfo() {
        self.title = FileManagerStorage.bottomFiles[storage.bottomIndex]
        
        if storage.bottomIndex == 0 {
            fileSizeLabel.text = ".."
            fileDateLabel.text = ".."
        } else {
            fileSizeLabel.text = FileManagerStorage.bottomListUrl[storage.bottomIndex - 1].fileSizeString
            let date = FileManagerStorage.bottomListUrl[storage.bottomIndex - 1].creationDate
            fileDateLabel.text = date?.asString(style: .long)
            infoTextView.text = fm.infoAbout(url: FileManagerStorage.bottomListUrl[storage.bottomIndex - 1])
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showFileInfo()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
