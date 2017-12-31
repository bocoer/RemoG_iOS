//
//  SpeedUnit.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

enum SpeedUnit: Int {
    case mph
    case kph
    case mps
    
    static let allValues: [SpeedUnit] = [.mph, .kph, .mps]
    
    var label: String {
        switch self {
        case .mph:
            return "mi/hr"
        case .kph:
            return "km/hr"
        case .mps:
            return "m/s"
        }
    }
    
    static func convert(_ speed: Float, from oldUnit: SpeedUnit, to newUnit: SpeedUnit) -> Float {
        return newUnit.convertFrom(mps: oldUnit.convertTo(mps: speed))
    }

    ///Converts from meters per second (location input) to this unit.
    func convertFrom(mps: Float) -> Float {
        switch self {
        case .mph:
            return mps * (3600 / 1609.34)
        case .kph:
            return mps * (3600 / 1000.0)
        case .mps:
            return mps
        }
    }
    
    ///Converts from this unit to meters per second (location input)
    func convertTo(mps: Float) -> Float {
        switch self {
        case .mph:
            return mps * (1609.34 / 3600)
        case .kph:
            return mps * (1000.0 / 3600)
        case .mps:
            return mps
        }
    }
}
