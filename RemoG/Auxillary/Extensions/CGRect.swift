//
//  CGRect.swift
//  RemoG
//
//  Created by Jakob Hain on 12/25/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import CoreGraphics

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: width / 2, y: height / 2)
    }
}
