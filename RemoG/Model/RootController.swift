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
        maxValue: 120,
        unitLabel: SpeedUnit.mph.label
    )
    let tempGaugeController = GaugeController(
        minValue: 60,
        maxValue: 360,
        unitLabel: TempUnit.farenheit.label
    )
    let oilTempStatusController: StatusController
    
    var speed: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Speed"] =
                speed.isNaN ?
                nil :
                "\(speed) \(speedUnit.label)"
            speedGaugeController.gaugeValue = speed
            
            changeHandlers.callbackAll()
        }
    }
    var rpm: Int = uintNan {
        didSet {
            sensorDataController.sensorData["Rpm"] = (rpm == RootController.uintNan) ? nil : String(rpm)
            
            changeHandlers.callbackAll()
        }
    }
    var ot: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Oil Temp"] =
                ot.isNaN ?
                nil :
                "\(ot) \(tempUnit.label)"
            tempGaugeController.gaugeValue = ot
            oilTempStatusController.curValue = ot
            
            changeHandlers.callbackAll()
        }
    }
    var oilPsi: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["Oil PSI"] = oilPsi.isNaN ? nil : String(oilPsi)
            
            changeHandlers.callbackAll()
        }
    }
    var cht: Float = Float.nan {
        didSet {
            sensorDataController.sensorData["CH Temp"] =
                cht.isNaN ?
                nil :
                "\(cht) \(tempUnit.label)"
            
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
    var speedUnit: SpeedUnit = SpeedUnit.mph {
        didSet {
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
            speedGaugeController.unitLabel = speedUnit.label

            changeHandlers.callbackAll()
        }
    }
    var tempUnit: TempUnit = TempUnit.farenheit {
        didSet {
            tempGaugeController.maxValue = TempUnit.convert(
                tempGaugeController.maxValue,
                from: oldValue,
                to: tempUnit
            )
            tempGaugeController.minValue = TempUnit.convert(
                tempGaugeController.minValue,
                from: oldValue,
                to: tempUnit
            )
            ot = TempUnit.convert(ot, from: oldValue, to: tempUnit)
            cht = TempUnit.convert(cht, from: oldValue, to: tempUnit)
            tempGaugeController.unitLabel = tempUnit.label
            oilTempStatusController.unitLabel = tempUnit.label
            
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
    
    init(notificationController: NotificationController) {
        oilTempStatusController = StatusController(
            notificationController: notificationController,
            valueLabel: "Oil Temp",
            unitLabel: tempUnit.label,
            curValue: ot,
            curLimit: 250,
            limitEnabled: false
        )
    }
}
