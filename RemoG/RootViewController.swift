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

    var overviewViewController: SensorDataViewController!
    var mphDualViewController: GaugeDualViewController!
    var tempDualViewController: GaugeDualViewController!
    var pageViewController: SimplePageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //Test setting field
        rootController.mph = 60
    }
}

