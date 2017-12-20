//
//  GaugeView.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class GaugeView: UIView {
    var gaugeValue: Float = Float.nan
    @IBInspectable var minGaugeValue: Float = Float.nan
    @IBInspectable var maxGaugeValue: Float = Float.nan
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}
