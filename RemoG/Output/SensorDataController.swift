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
    
    var sensorData: [String:String] = [:] {
        didSet {
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
}
