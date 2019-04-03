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
    @IBOutlet weak var fileSizeCell: UITableViewCell!
    @IBOutlet weak var fileSizeLabelHeader: UILabel!
    @IBOutlet weak var createDateCell: UITableViewCell!
    @IBOutlet weak var createDateLabelHeader: UILabel!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
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
            print("Top View Controller index = \(storage.topIndex)")

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
        
        if FileManagerUserDefaultsSettings.useDarkTheme {
            self.view.backgroundColor = .darkGray
            self.navigationController?.navigationBar.barTintColor = .darkGray
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
            fileSizeLabel.textColor = .white
            fileSizeLabelHeader.textColor = .white
            fileDateLabel.textColor = .white
            createDateLabelHeader.textColor = .white
            fileSizeCell.backgroundColor = .darkGray
            createDateCell.backgroundColor = .darkGray
            infoTextView.backgroundColor = .darkGray
            infoTextView.textColor = .white
            backButton.tintColor = .white
        } else {
            self.view.backgroundColor = .white
            self.navigationController?.navigationBar.barTintColor = .white
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
            fileSizeLabel.textColor = .black
            fileSizeLabelHeader.textColor = .black
            fileDateLabel.textColor = .black
            createDateLabelHeader.textColor = .black
            fileSizeCell.backgroundColor = .white
            createDateCell.backgroundColor = .white
            infoTextView.backgroundColor = .white
            infoTextView.textColor = .black
            backButton.tintColor = UIColor(red: 0, green: 0.478431, blue: 1, alpha: 1)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "File properties"
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
