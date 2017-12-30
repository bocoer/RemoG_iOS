//
//  SensorDataFieldCell.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class SensorDataFieldCell: UITableViewCell {
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    
    var key: String? {
        get {
            return keyLabel.text
        } set(newKey) {
            keyLabel.text = newKey
        }
    }
    
    var value: String? {
        get {
            return valueLabel.text
        } set(newKey) {
            valueLabel.text = newKey
        }
    }
}
