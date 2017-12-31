//
//  SettingsViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/30/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class SettingsViewController: TitledViewController {
    var settingsController: SettingsController!
    
    var tableViewController: SettingsTableViewController!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let segueId = segue.identifier {
            switch segueId {
            case "EmbedSettingsTableViewController":
                tableViewController = segue.destination as! SettingsTableViewController
                tableViewController.settingsController = settingsController
            default: break
            }
        }
    }
}
