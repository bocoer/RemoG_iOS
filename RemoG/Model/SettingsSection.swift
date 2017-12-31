//
//  SettingsSection.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class SettingsSection {
    let label: String
    let fields: [SettingField]
    
    init(label: String, fields: [SettingField]) {
        self.label = label
        self.fields = fields
    }
}
