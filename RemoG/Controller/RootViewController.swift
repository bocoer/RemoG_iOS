//
//  RootViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit
import UserNotifications

class RootViewController: UIViewController {
    var notificationController: NotificationController!
    var rootController: RootController!
    var gpsController: GPSController!
    var settingsController: SettingsController!
    var persistenceController: PersistenceController!

    var overviewViewController: SensorDataViewController!
    var mphDualViewController: GaugeDualViewController!
    var tempDualViewController: GaugeDualViewController!
    var settingsViewController: SettingsViewController!
    var tabPageViewController: TabPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            notificationController = NotificationController(
                presentingViewController: self,
                application: UIApplication.shared,
                notificationCenter: UNUserNotificationCenter.current(),
                options: [.alert, .carPlay]
            )
        } else {
            notificationController = NotificationController(
                presentingViewController: self,
                application: UIApplication.shared
            )
        }
        rootController = RootController(notificationController: notificationController)
        gpsController = GPSController(rootController: rootController)
        settingsController = SettingsController(rootController: rootController)
        persistenceController = PersistenceController(
            settingsController: settingsController,
            userDefaults: UserDefaults.standard
        )
        
        //Test engine
        let engineSim = EngineSim()
        engineSim.controller = rootController
        engineSim.start()
        
        overviewViewController = storyboard!.instantiateViewController(withIdentifier: "SensorDataViewController") as! SensorDataViewController
        overviewViewController.sensorDataController = rootController.sensorDataController
        overviewViewController.tabBarItem.image = #imageLiteral(resourceName: "OverviewIcon")
        overviewViewController.title = "Overview"
        
        mphDualViewController = storyboard!.instantiateViewController(withIdentifier: "GaugeDualViewController") as! GaugeDualViewController
        mphDualViewController.sensorDataController = rootController.sensorDataController
        mphDualViewController.gaugeController = rootController.speedGaugeController
        mphDualViewController.tabBarItem.image = #imageLiteral(resourceName: "GaugeIcon")
        mphDualViewController.title = "Speed"
        
        tempDualViewController = storyboard!.instantiateViewController(withIdentifier: "GaugeDualViewController") as! GaugeDualViewController
        tempDualViewController.sensorDataController = rootController.sensorDataController
        tempDualViewController.gaugeController = rootController.tempGaugeController
        tempDualViewController.tabBarItem.image = #imageLiteral(resourceName: "GaugeIcon")
        tempDualViewController.title = "Temperature"
        
        settingsViewController = storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsViewController.settingsController = settingsController
        settingsViewController.tabBarItem.image = #imageLiteral(resourceName: "SettingsIcon")
        settingsViewController.title = "Settings"
        
        let viewControllers: [UIViewController] = [
            overviewViewController,
            mphDualViewController,
            tempDualViewController,
            settingsViewController
        ]
        
        tabPageViewController = TabPageViewController(
            viewControllers: viewControllers,
            transitionStyle: .scroll
        )
        
        addChildViewController(tabPageViewController)
        view.addSubview(tabPageViewController.view)
    }
}

