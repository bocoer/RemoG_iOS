//
//  RootViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/18/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    let rootController: RootController = RootController()
    let gpsController: GPSController
    let settingsController: SettingsController
    let persistenceController: PersistenceController

    var overviewViewController: SensorDataViewController!
    var mphDualViewController: GaugeDualViewController!
    var tempDualViewController: GaugeDualViewController!
    var settingsViewController: SettingsViewController!
    var tabPageViewController: TabPageViewController!
    
    required init?(coder aDecoder: NSCoder) {
        gpsController = GPSController(rootController: rootController)
        settingsController = SettingsController(rootController: rootController)
        persistenceController = PersistenceController(
            settingsController: settingsController,
            userDefaults: UserDefaults.standard
        )
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Test engine
        let engineSim = EngineSim()
        engineSim.controller = rootController
        engineSim.start()
        
        overviewViewController = storyboard!.instantiateViewController(withIdentifier: "SensorDataViewController") as! SensorDataViewController
        overviewViewController.sensorDataController = rootController.sensorDataController
        overviewViewController.title = "Overview"
        
        mphDualViewController = storyboard!.instantiateViewController(withIdentifier: "GaugeDualViewController") as! GaugeDualViewController
        mphDualViewController.sensorDataController = rootController.sensorDataController
        mphDualViewController.gaugeController = rootController.speedGaugeController
        mphDualViewController.title = "Speed"
        
        tempDualViewController = storyboard!.instantiateViewController(withIdentifier: "GaugeDualViewController") as! GaugeDualViewController
        tempDualViewController.sensorDataController = rootController.sensorDataController
        tempDualViewController.gaugeController = rootController.tempGaugeController
        tempDualViewController.title = "Temperature"
        
        settingsViewController = storyboard!.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
        settingsViewController.settingsController = settingsController
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

