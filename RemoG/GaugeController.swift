//
//  GaugeController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class GaugeController {
    var gaugeValue: Float = Float.nan {
        didSet {
            changeHandlers.callbackAll()
        }
    }
    var minValue: Float {
        didSet {
            changeHandlers.callbackAll()
        }
    }
    var maxValue: Float {
        didSet {
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
    
    init(minValue: Float, maxValue: Float) {
        self.minValue = minValue
        self.maxValue = maxValue
    }
}
