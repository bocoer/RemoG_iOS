//
//  SensorDataViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

/*
 * Controls a view which displays sensor data.
 */
class SensorDataViewController: UIViewController {
    var sensorDataController: SensorDataController!
    var tableViewController: SensorDataTableViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let segueId = segue.identifier {
            switch segueId {
            case "EmbedSensorDataTableViewController":
                tableViewController = segue.destination as! SensorDataTableViewController
                tableViewController.sensorDataController = sensorDataController
            default: break
            }
        }
    }
}
