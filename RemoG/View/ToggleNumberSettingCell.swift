//
//  ToggleNumberSettingCell.swift
//  RemoG
//
//  Created by Jakob Hain on 1/1/18.
//  Copyright © 2018 Resc. All rights reserved.
//

import UIKit

class ToggleNumberSettingCell: NumberSettingCell {
    @IBOutlet weak var valueEnabledLabel: UILabel!
    @IBOutlet private weak var enabledSwitch: UISwitch!
    
    var toggleSetting: ToggleNumberSettingField! {
        didSet {
            setting = toggleSetting
            
            enabledSwitch.isOn = toggleSetting.curEnabled
            slider.isEnabled = toggleSetting.curEnabled
            stepper.isEnabled = toggleSetting.curEnabled
            valueEnabledLabel.text = toggleSetting.curEnabled ? String(toggleSetting.curValue) : "Disabled"
        }
    }
    
    @IBAction override func updateSettingFromSlider() {
        let oldValue = toggleSetting.curValue
        
        super.updateSettingFromSlider()
        
        if oldValue != toggleSetting.curValue && toggleSetting.curEnabled {
            valueEnabledLabel.text = String(toggleSetting.curValue)
        }
    }
    
    @IBAction override func updateSettingFromStepper() {
        let oldValue = toggleSetting.curValue
        
        super.updateSettingFromStepper()
        
        if oldValue != toggleSetting.curValue && toggleSetting.curEnabled {
            valueEnabledLabel.text = String(toggleSetting.curValue)
        }
    }
    
    @IBAction func updateSettingFromEnabledSwitch() {
        let newEnabled = enabledSwitch.isOn
        if toggleSetting.curEnabled != newEnabled {
            toggleSetting.setEnabled(newEnabled)
            
            slider.isEnabled = toggleSetting.curEnabled
            stepper.isEnabled = toggleSetting.curEnabled
            valueEnabledLabel.text = toggleSetting.curEnabled ? String(toggleSetting.curValue) : "Disabled"
        }
    }
}
