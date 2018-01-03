//
//  OptionSettingCell.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class OptionSettingCell: UITableViewCell {
    @IBOutlet private weak var keyLabel: UILabel!
    @IBOutlet private weak var valueLabel: UILabel!
    @IBOutlet private weak var optionsSeg: UISegmentedControl!
    
    var setting: OptionSettingField! {
        didSet {
            keyLabel.text = setting.label
            
            valueLabel.text = setting.curOption
            
            optionsSeg.removeAllSegments()
            for option in setting.options {
                optionsSeg.insertSegment(withTitle: option, at: optionsSeg.numberOfSegments, animated: false)
            }
            
            optionsSeg.selectedSegmentIndex = setting.curIndex
        }
    }
    
    @IBAction func updateSettingFromOptionsSeg() {
        let newIndex = optionsSeg.selectedSegmentIndex
        if setting.curIndex != newIndex {
            setting.setIndex(newIndex)
            
            valueLabel.text = setting.curOption
        }
    }
}
