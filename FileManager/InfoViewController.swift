//
//  InfoViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/27/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class InfoViewController: UITableViewController {
    
    
    @IBOutlet weak var fileSizeLabel: UILabel!
    @IBOutlet weak var fileDateLabel: UILabel!
    
    var storage = FileMangerStorage()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.title = storage.files[storage.index]
        
        print("******** index = \(storage.listUrl[storage.index - 1])")
        
        fileSizeLabel.text = storage.listUrl[storage.index - 1].fileSizeString
        
        let date = storage.listUrl[storage.index - 1].creationDate
        fileDateLabel.text = date?.asString(style: .long)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
