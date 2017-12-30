//
//  CGPoint.swift
//  RemoG
//
//  Created by Jakob Hain on 12/25/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import CoreGraphics

extension CGPoint {
    static func +(_ val: CGPoint, offset: CGSize) -> CGPoint {
        return CGPoint(
            x: val.x + offset.width,
            y: val.y + offset.height
        )
    }
}
