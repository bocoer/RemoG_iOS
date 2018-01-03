//
//  Float.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

extension Float {
    static func round(_ value: Float, by step: Float) -> Float {
        return Darwin.round(value / step) * step
    }
}
