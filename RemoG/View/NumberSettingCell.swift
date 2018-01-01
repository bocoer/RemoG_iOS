//
//  NumberSettingCell.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class NumberSettingCell: UITableViewCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel?
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var stepper: UIStepper!
    
    var setting: NumberSettingField! {
        didSet {
            keyLabel.text = setting.label
            
            valueLabel?.text = String(setting.curValue)
            
            slider.minimumValue = setting.min
            slider.maximumValue = setting.max
            slider.value = setting.curValue
            
            stepper.minimumValue = Double(setting.min)
            stepper.maximumValue = Double(setting.max)
            stepper.stepValue = Double(setting.step)
            stepper.value = Double(setting.curValue)
        }
    }
    
    @IBAction func updateSettingFromSlider() {
        let newValue = Float.round(slider.value, by: setting.step)
        if setting.curValue != newValue {
            setting.setValue(newValue)
            
            valueLabel?.text = String(setting.curValue)
            stepper.value = Double(setting.curValue)
        }
    }
    
    @IBAction func updateSettingFromStepper() {
        let newValue = Float(stepper.value)
        if setting.curValue != newValue {
            setting.setValue(newValue)
            
            valueLabel?.text = String(setting.curValue)
            slider.value = setting.curValue
        }
    }
}
