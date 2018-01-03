//
//  TitledViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/30/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class TitledViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel?
    override var title: String? {
        didSet {
            titleLabel?.text = title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = title
    }
}
