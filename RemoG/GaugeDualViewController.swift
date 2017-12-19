//
//  GaugeDualViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

/*
 * Controls a view which displays both a gauge and sensor data.
 */
class GaugeDualViewController: SensorDataViewController {
    var gaugeController: GaugeController!
    var gaugeViewController: GaugeViewController!

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let segueId = segue.identifier {
            switch segueId {
            case "EmbedGaugeViewController":
                gaugeViewController = segue.destination as! GaugeViewController
                gaugeViewController.gaugeController = gaugeController
            default: break
            }
        }
    }
}
