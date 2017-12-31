//
//  SettingsController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class SettingsController {
    let rootController: RootController
    
    var changeHandlers: CallbackDictionary = CallbackDictionary()
    private var _sections: [SettingsSection]!
    var sections: [SettingsSection] {
        return _sections
    }
    var allSettingFields: [SettingField] {
        return sections.flatMap { $0.fields }
    }
    
    init(rootController: RootController) {
        self.rootController = rootController
        updateSections()
        rootController.changeHandlers[self] = updateSections
    }
    
    private func updateSections() {
        let speedStep = self.rootController.speedGaugeController.majorStep
        let tempStep = self.rootController.tempGaugeController.majorStep
        _sections = [
            SettingsSection(label: "Speed", fields: [
                OptionSettingField(
                    label: "Unit",
                    options: SpeedUnit.allValues.map { $0.label },
                    curIndex: rootController.speedUnit.rawValue,
                    setIndex: { newIndex in
                        if let newUnit = SpeedUnit(rawValue: newIndex) {
                            self.rootController.speedUnit = newUnit
                            self.rootController.speedGaugeController.maxValue = Float.round(
                                self.rootController.speedGaugeController.maxValue,
                                by: speedStep
                            )
                        } else {
                            fatalError("Invalid index '\(newIndex)' not a speed unit")
                        }
                    }
                ),
                NumberSettingField(
                    label: "Maximum",
                    min: Float.round(rootController.speedUnit.convertFrom(mps: 20), by: speedStep),
                    max: Float.round(rootController.speedUnit.convertFrom(mps: 100), by: speedStep),
                    step: speedStep,
                    curValue: rootController.speedGaugeController.maxValue,
                    setValue: { newValue in
                        self.rootController.speedGaugeController.maxValue = newValue
                    }
                )
            ]),
            SettingsSection(label: "Temperature", fields: [
                NumberSettingField(
                    label: "Minimum",
                    min: 0,
                    max: 120,
                    step: tempStep,
                    curValue: rootController.tempGaugeController.minValue,
                    setValue: { newValue in
                        self.rootController.tempGaugeController.minValue = newValue
                    }
                ),
                NumberSettingField(
                    label: "Maximum",
                    min: 240,
                    max: 360,
                    step: tempStep,
                    curValue: rootController.tempGaugeController.maxValue,
                    setValue: { newValue in
                        self.rootController.tempGaugeController.maxValue = newValue
                    }
                )
            ])
        ]
        changeHandlers.callbackAll()
    }
    
    func settingAtIndexPath(_ indexPath: IndexPath) -> SettingField {
        let section = sections[indexPath.section]
        let field = section.fields[indexPath.row]
        return field
    }
}
