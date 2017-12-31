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
    
    let sensorDataController = SensorDataController()
    let speedGaugeController = GaugeController(
        minValue: 0,
        maxValue: 120
    )
    let tempGaugeController = GaugeController(
        minValue: 60,
        maxValue: 360
    )
    
    var speed: Float = Float.nan {
        didSet {
            sensorDataController.sensorData[speedUnit.label] = speed.isNaN ? nil : String(speed)
            speedGaugeController.gaugeValue = speed
            
            changeHandlers.callbackAll()
        }
    }
    var speedUnit: SpeedUnit = SpeedUnit.mph {
        didSet {
            sensorDataController.sensorData[oldValue.label] = nil
            
            speedGaugeController.maxValue = SpeedUnit.convert(
                speedGaugeController.maxValue,
                from: oldValue,
                to: speedUnit
            )
            speedGaugeController.minValue = SpeedUnit.convert(
                speedGaugeController.minValue,
                from: oldValue,
                to: speedUnit
            )
            speed = SpeedUnit.convert(speed, from: oldValue, to: speedUnit)
            
            changeHandlers.callbackAll()
        }
    }
    var rpm: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Rpm"] = (rpm == RootController.uintNan) ? nil : String(rpm)
            
            changeHandlers.callbackAll()
        }
    }
    var otf: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["OT °F"] = otf.isNaN ? nil : String(otf)
            tempGaugeController.gaugeValue = otf
            
            changeHandlers.callbackAll()
        }
    }
    var oilPsi: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Oil PSI"] = (oilPsi == RootController.uintNan) ? nil : String(oilPsi)
            
            changeHandlers.callbackAll()
        }
    }
    var chtf: Int = uintNan {
        didSet {
            sensorDataController.sensorData["CHT °F"] = (chtf == RootController.uintNan) ? nil : String(chtf)
            
            changeHandlers.callbackAll()
        }
    }
    var volt: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Volt"] = volt.isNaN ? nil : String(volt)
            
            changeHandlers.callbackAll()
        }
    }
    var odom: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Odom"] = (odom == RootController.uintNan) ? nil : String(odom)
            
            changeHandlers.callbackAll()
        }
    }
    var afr: Int = uintNan {
        didSet {
            sensorDataController.sensorData["AFR"] = (afr == RootController.uintNan) ? nil : String(afr)
            
            changeHandlers.callbackAll()
        }
    }
    var amb: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Amb"] = amb.isNaN ? nil : String(amb)
            
            changeHandlers.callbackAll()
        }
    }
    var locationAvailability: LocationAvailability? = nil {
        didSet {
            switch locationAvailability {
            case .some(.disabled):
                speed = Float.nan
                sensorDataController.sensorData[SensorDataController.locationKey] = SensorDataController.locationDisabledVal
            case .some(.unavailable):
                speed = Float.nan
                sensorDataController.sensorData[SensorDataController.locationKey] = "Unavailable"
            case .some(.available), .none:
                sensorDataController.sensorData[SensorDataController.locationKey] = nil
            }
            
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
}
