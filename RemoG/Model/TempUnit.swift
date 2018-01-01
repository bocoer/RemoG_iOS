//
//  TempUnit.swift
//  RemoG
//
//  Created by Jakob Hain on 1/1/18.
//  Copyright © 2018 Resc. All rights reserved.
//

import Foundation

enum TempUnit: Int {
    case farenheit
    case celsius
    
    static let allValues: [TempUnit] = [.farenheit, .celsius]
    
    var label: String {
        switch self {
        case .farenheit:
            return "°F"
        case .celsius:
            return "°C"
        }
    }
    
    static func convert(_ temp: Float, from oldUnit: TempUnit, to newUnit: TempUnit) -> Float {
        switch (oldUnit, newUnit) {
        case (.farenheit, .celsius):
            return (temp - 32) * (5 / 9.0)
        case (.celsius, .farenheit):
            return (temp * (9 / 5.0)) + 32
        case (.farenheit, .farenheit), (.celsius, .celsius):
            return temp
        }
    }
}
