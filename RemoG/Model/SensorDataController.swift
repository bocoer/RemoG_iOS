//
//  SensorDataController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class SensorDataController {
    static let locationKey: String = "Location"
    static let locationDisabledVal: String = "Disabled"
    ///The possible keys, in order of how they should be displayed
    static let keys: [String] = [
        SpeedUnit.mph.label,
        SpeedUnit.kph.label,
        SpeedUnit.mps.label,
        "RPM",
        "OT °F",
        "Oil PSI",
        "CHT °F",
        "Volt",
        "Odom",
        "AFR",
        "Amb",
        locationKey
    ]
    
    var sensorData: [String:String] = [:] {
        didSet {
            for key in sensorData.keys {
                assert(SensorDataController.keys.contains(key), "No sensor data field corresponds to '\(key)'")
            }
            
            _sortedSensorData = sensorData.sorted(by: {
                SensorDataController.keys.index(of: $0.key)! < SensorDataController.keys.index(of: $1.key)!
            })
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
    var sortedSensorData: [SensorDataField] {
        return _sortedSensorData
    }
    
    private var _sortedSensorData: [SensorDataField] = []
}

typealias SensorDataField = (key: String, value: String)
