//
//  TintStepper.swift
//  RemoG
//
//  Created by Jakob Hain on 1/1/18.
//  Copyright © 2018 Resc. All rights reserved.
//

import UIKit

///A stepper which becomes tinted grey when disabled,
///which makes it more clear that it's disabled.
class TintStepper: UIStepper {
    @IBInspectable var enabledTintColor: UIColor = #colorLiteral(red: 0, green: 0.4788140655, blue: 0.9994292855, alpha: 1)
    @IBInspectable var disabledTintColor: UIColor = #colorLiteral(red: 0.7233663201, green: 0.7233663201, blue: 0.7233663201, alpha: 1)
    
    override var isEnabled: Bool {
        didSet {
            tintColor = isEnabled ? enabledTintColor : disabledTintColor
        }
    }
}
