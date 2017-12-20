//
//  RootController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class RootController {
    static let uintNan: Int = -1
    
    var mph: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Mph"] = String(mph)
        }
    }
    var rpm: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Rpm"] = String(rpm)
        }
    }
    var otf: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["OT F"] = String(otf)
        }
    }
    var oilPsi: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Oil PSI"] = String(oilPsi)
        }
    }
    var chtf: Int = uintNan {
        didSet {
            sensorDataController.sensorData["CHT F"] = String(chtf)
        }
    }
    var volt: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Volt"] = String(volt)
        }
    }
    var odom: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Odom"] = String(odom)
        }
    }
    var afr: Int = uintNan {
        didSet {
            sensorDataController.sensorData["AFR"] = String(afr)
        }
    }
    var amb: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Amb"] = String(amb)
        }
    }
    
    let sensorDataController = SensorDataController()
    let mphGaugeController = GaugeController(minValue: 0, maxValue: 120)
    let tempGaugeController = GaugeController(minValue: 0, maxValue: 160)
}
