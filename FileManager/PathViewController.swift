//
//  PathViewController.swift
//  FileManager
//
//  Created by Artem Karmaz on 3/27/19.
//  Copyright © 2019 Johansson Group. All rights reserved.
//

import UIKit

class PathViewController: UIViewController {
    
    var delegate: ViewController?
    var fileManager = FM()

    @IBOutlet weak var path: UILabel!
    @IBOutlet weak var pathAdress: UILabel!
    
    var text: URL?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text = fileManager.getUrl(fileManager.path)
            print(text)
        
        pathAdress.text = String(contentsOf: text!.absoluteURL)
    }
}
