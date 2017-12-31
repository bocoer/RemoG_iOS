//
//  PersistenceController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

///Allows settings to be saved and restored.
class PersistenceController {
    let settingsController: SettingsController
    let userDefaults: UserDefaults
    
    init(settingsController: SettingsController, userDefaults: UserDefaults) {
        self.settingsController = settingsController
        self.userDefaults = userDefaults
        load()
        settingsController.changeHandlers[self] = save
    }
    
    ///Restores previously saved settings.
    func load() {
        for setting in settingsController.allSettingFields {
            setting.load(from: userDefaults)
        }
    }
    
    ///Saves settings to be restored later.
    func save() {
        for setting in settingsController.allSettingFields {
            setting.save(from: userDefaults)
        }
    }
}
