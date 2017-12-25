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
            mphGaugeController.gaugeValue = mph
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
            tempGaugeController.gaugeValue = otf
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
    let mphGaugeController = GaugeController(
        minValue: 0,
        maxValue: 120,
        numMajorTicks: 13, //0 10 20 30 40 50 60 70 80 90 100 110 120
        numMinorTicks: 121
    )
    let tempGaugeController = GaugeController(
        minValue: 60,
        maxValue: 360,
        numMajorTicks: 16, //60 80 100 120 140 160 180 200 220 240 260 280 300 320 340 360
        numMinorTicks: 301
    )
}
