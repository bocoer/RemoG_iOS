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
    var valueSpan: Float {
        return maxValue - minValue
    }
    var majorStep: Float {
        switch valueSpan {
        case 20...100:
            return 5
        case 100...200:
            return 10
        case 200...400:
            return 20
        default:
            fatalError("Don't know step size for value span '\(valueSpan)'")
        }
    }
    var minorStep: Float {
        switch valueSpan {
        case 0...400:
            return 1
        default:
            fatalError("Don't know step size for value span '\(valueSpan)'")
        }
    }
    
    init(
        minValue: Float,
        maxValue: Float
    ) {
        self.minValue = minValue
        self.maxValue = maxValue
    }
}
