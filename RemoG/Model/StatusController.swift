//
//  StatusController.swift
//  RemoG
//
//  Created by Jakob Hain on 1/1/18.
//  Copyright © 2018 Resc. All rights reserved.
//

import Foundation

class StatusController {
    let notificationController: NotificationController
    let valueLabel: String
    var unitLabel: String
    var curValue: Float {
        didSet {
            if limitEnabled && oldValue < curLimit && curValue > curLimit {
                alertLimitExceeded()
            }
        }
    }
    var curLimit: Float {
        didSet {
            if limitEnabled && curValue < oldValue && curValue > curLimit {
                alertLimitExceeded()
            }
        }
    }
    var limitEnabled: Bool {
        didSet {
            if limitEnabled && !oldValue && curValue > curLimit {
                alertLimitExceeded()
            }
        }
    }
    
    init(
        notificationController: NotificationController,
        valueLabel: String,
        unitLabel: String,
        curValue: Float,
        curLimit: Float,
        limitEnabled: Bool
    ) {
        self.notificationController = notificationController
        self.valueLabel = valueLabel
        self.unitLabel = unitLabel
        self.curValue = curValue
        self.curLimit = curLimit
        self.limitEnabled = limitEnabled
    }
    
    private func alertLimitExceeded() {
        let notification = Notification(
            identifier: "\(valueLabel) Exceeded",
            title: "\(valueLabel) Exceeded Limit",
            body:
                "Current \(valueLabel) is \(curValue) \(unitLabel).\n" +
                "Limit is \(curLimit) \(unitLabel)"
        )
        notificationController.send(notification: notification)
    }
}
