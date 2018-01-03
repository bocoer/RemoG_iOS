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
    var unitLabel: String {
        didSet {
            changeHandlers.callbackAll()
        }
    }
    var changeHandlers: CallbackDictionary = CallbackDictionary()
    var valueSpan: Float {
        return maxValue - minValue
    }
    var majorStep: Float {
        switch valueSpan {
        case 0...100:
            return 5
        case 100...160:
            return 10
        case 160...320:
            return 20
        case 320...640:
            return 40
        default:
            fatalError("Don't know step size for value span '\(valueSpan)'")
        }
    }
    var minorStep: Float {
        switch valueSpan {
        case 0...640:
            return 1
        default:
            fatalError("Don't know step size for value span '\(valueSpan)'")
        }
    }
    
    init(
        minValue: Float,
        maxValue: Float,
        unitLabel: String
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
        self.unitLabel = unitLabel
    }
}
