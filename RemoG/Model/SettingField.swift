//
//  SettingField.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class SettingField {
    let label: String
    
    init(label: String) {
        self.label = label
    }
    
    func save(from userDefaults: UserDefaults) {
        //Nothing to save
    }
    
    func load(from userDefaults: UserDefaults) {
        //Nothing to load
    }
}

class NumberSettingField: SettingField {
    let min: Float
    let max: Float
    let step: Float
    let unitLabel: String
    let curValue: Float
    let setValue: (Float) -> Void
    
    var curValueDesc: String {
        //Renders no decimals in value
        return String(format: "%.0f %@", curValue, unitLabel)
    }
    
    init(
        label: String,
        min: Float,
        max: Float,
        step: Float,
        unitLabel: String,
        curValue: Float,
        setValue: @escaping (Float) -> Void
    ) {
        self.min = min
        self.max = max
        self.step = step
        self.unitLabel = unitLabel
        self.curValue = curValue
        self.setValue = setValue
        super.init(label: label)
    }
    
    override func save(from userDefaults: UserDefaults) {
        userDefaults.set(curValue, forKey: label)
    }
    
    override func load(from userDefaults: UserDefaults) {
        if let savedValue = userDefaults.value(forKey: label) {
            setValue(savedValue as! Float)
        }
    }
}

class ToggleNumberSettingField: NumberSettingField {
    let curEnabled: Bool
    let setEnabled: (Bool) -> Void
    
    override var curValueDesc: String {
        return curEnabled ? super.curValueDesc : "Off"
    }
    
    init(
        label: String,
        min: Float,
        max: Float,
        step: Float,
        unitLabel: String,
        curValue: Float,
        curEnabled: Bool,
        setValue: @escaping (Float) -> Void,
        setEnabled: @escaping (Bool) -> Void
        ) {
        self.curEnabled = curEnabled
        self.setEnabled = setEnabled
        super.init(
            label: label,
            min: min,
            max: max,
            step: step,
            unitLabel: unitLabel,
            curValue: curValue,
            setValue: setValue
        )
    }
    
    override func save(from userDefaults: UserDefaults) {
        userDefaults.set(curValue, forKey: "\(label)-value")
        userDefaults.set(curEnabled, forKey: "\(label)-enabled")
    }
    
    override func load(from userDefaults: UserDefaults) {
        if let savedValue = userDefaults.value(forKey: "\(label)-value") {
            setValue(savedValue as! Float)
        }
        if let savedEnabled = userDefaults.value(forKey: "\(label)-enabled") {
            setEnabled(savedEnabled as! Bool)
        }
    }
}

class OptionSettingField: SettingField {
    let options: [String]
    let curIndex: Int
    let setIndex: (Int) -> Void
    
    var curOption: String {
        return options[curIndex]
    }
    
    init(
        label: String,
        options: [String],
        curIndex: Int,
        setIndex: @escaping (Int) -> Void
    ) {
        self.options = options
        self.curIndex = curIndex
        self.setIndex = setIndex
        super.init(label: label)
    }
    
    override func save(from userDefaults: UserDefaults) {
        userDefaults.set(curIndex, forKey: label)
    }
    
    override func load(from userDefaults: UserDefaults) {
        if let savedIndex = userDefaults.value(forKey: label) {
            setIndex(savedIndex as! Int)
        }
    }
}

