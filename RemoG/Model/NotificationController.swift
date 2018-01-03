//
//  NotificationController.swift
//  RemoG
//
//  Created by Jakob Hain on 1/1/18.
//  Copyright © 2018 Resc. All rights reserved.
//

import UserNotifications
import UIKit

class NotificationController {
    let presentingViewController: UIViewController
    let application: UIApplication
    private let _notificationCenter: AnyObject?
    @available(iOS 10.0, *)
    var notificationCenter: UNUserNotificationCenter {
        return _notificationCenter as! UNUserNotificationCenter
    }
    @available(iOS, obsoleted: 10.0, message: "Replaced with notificationCenter")
    
    @available(iOS 10.0, *)
    init(
        presentingViewController: UIViewController,
        application: UIApplication,
        notificationCenter: UNUserNotificationCenter,
        options: UNAuthorizationOptions
    ) {
        self.presentingViewController = presentingViewController
        self.application = application
        _notificationCenter = notificationCenter
        
        notificationCenter.requestAuthorization(options: options, completionHandler: { (suceeded, error) in
            if let error = error {
                let alert = UIAlertController(
                    title: "Error Enabling Notifications",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(
                    title: "Dismiss",
                    style: .default,
                    handler: nil
                ))
                self.presentingViewController.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    @available(iOS, obsoleted: 10.0, message: "Replaced with init(notificationCenter:)")
    init(
        presentingViewController: UIViewController,
        application: UIApplication
    ) {
        self.presentingViewController = presentingViewController
        self.application = application
        _notificationCenter = nil
    }
    
    func send(notification: Notification) {
        if application.applicationState == .active {
            sendLocally(notification: notification)
        } else {
            if #available(iOS 10.0, *) {
                let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body
                
                let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: nil)
                notificationCenter.add(request, withCompletionHandler: nil)
            } else {
                let containsNotification = application.scheduledLocalNotifications?.contains { localNotification in
                    let identifier = localNotification.userInfo?["identifier"] as? String
                    return identifier == notification.identifier
                    } ?? false
                if !containsNotification {
                    let localNotification = UILocalNotification()
                    localNotification.alertTitle = notification.title
                    localNotification.alertBody = notification.body
                    localNotification.userInfo = ["identifier": notification.identifier]
                    application.scheduleLocalNotification(localNotification)
                }
            }
        }
    }
    
    func sendLocally(notification: Notification) {
        let alert = UIAlertController(
            title: notification.title,
            message: notification.body,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "Dismiss",
            style: .default,
            handler: nil
        ))
        presentingViewController.present(alert, animated: true, completion: nil)
    }
}
