//
//  InfoViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/27/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class FileManagerTopInfoViewController: UITableViewController {
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var fileDateLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    var storage = FileManagerStorage()
    var fm = FM()
    
    fileprivate func showFileInfo() {
        if storage.topFilteringOrNot {
//            self.title = FileManagerStorage.topFilteredFiles[storage.topSortIndex]
//            fileSizeLabel.text = FileManagerStorage.topListUrl[storage.topSortIndex].fileSizeString
//            let date = FileManagerStorage.topListUrl[storage.topSortIndex].creationDate
//            fileDateLabel.text = date?.asString(style: .long)
//            infoTextView.text = fm.infoAbout(url: FileManagerStorage.topListUrl[storage.topSortIndex])
        } else {
            self.title = FileManagerStorage.myTopFilesSorted[storage.topIndex].0
            
            if storage.topIndex == 0 {
                fileSizeLabel.text = ".."
                fileDateLabel.text = ".."
            } else {
                
                fileSizeLabel.text = FileManagerStorage.myTopFilesSorted[storage.topIndex].1.fileSizeString
                let date = FileManagerStorage.myTopFilesSorted[storage.topIndex].1.creationDate
                fileDateLabel.text = date?.asString(style: .long)
                infoTextView.text = fm.infoAbout(url: FileManagerStorage.myTopFilesSorted[storage.topIndex].1)
            }
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
