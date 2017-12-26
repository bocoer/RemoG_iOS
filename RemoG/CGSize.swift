//
//  CGSize.swift
//  RemoG
//
//  Created by Jakob Hain on 12/25/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import CoreGraphics

extension CGSize {
    ///Creates a point with the `x, y` equal to `width, height`
    var toPoint: CGPoint {
        return CGPoint(x: width, y: height)
    }
    
    init(radius: CGFloat, angle: CGFloat) {
        self.init(
            width: -sin(angle) * radius,
            height: -cos(angle) * radius
        )
    }
}
