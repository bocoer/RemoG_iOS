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

    var overviewViewController: SensorDataViewController!
    var mphDualViewController: GaugeDualViewController!
    var tempDualViewController: GaugeDualViewController!
    var pageViewController: SimplePageViewController!
    
    required init?(coder aDecoder: NSCoder) {
        gpsController = GPSController(rootController: rootController)
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
        mphDualViewController.gaugeController = rootController.mphGaugeController
        mphDualViewController.title = "Speed"
        
        tempDualViewController = storyboard!.instantiateViewController(withIdentifier: "GaugeDualViewController") as! GaugeDualViewController
        tempDualViewController.sensorDataController = rootController.sensorDataController
        tempDualViewController.gaugeController = rootController.tempGaugeController
        tempDualViewController.title = "Temperature"
        
        let viewControllers: [UIViewController] = [
            overviewViewController,
            mphDualViewController,
            tempDualViewController
        ]
        
        pageViewController = SimplePageViewController(allViewControllers: viewControllers, transitionStyle: .pageCurl)
        
        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
    }
}

