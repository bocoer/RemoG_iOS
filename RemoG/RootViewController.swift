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

    var sensorDataViewController: SensorDataViewController!
    var mphDualViewController: GaugeDualViewController!
    var tempDualViewController: GaugeDualViewController!
    var pageViewController: SimplePageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorDataViewController = storyboard!.instantiateViewController(withIdentifier: "SensorDataViewController") as! SensorDataViewController
        sensorDataViewController.sensorDataController = rootController.sensorDataController
        
        mphDualViewController = storyboard!.instantiateViewController(withIdentifier: "MphDualViewController") as! GaugeDualViewController
        mphDualViewController.sensorDataController = rootController.sensorDataController
        mphDualViewController.gaugeController = rootController.mphGaugeController
        
        tempDualViewController = storyboard!.instantiateViewController(withIdentifier: "TempDualViewController") as! GaugeDualViewController
        tempDualViewController.sensorDataController = rootController.sensorDataController
        tempDualViewController.gaugeController = rootController.tempGaugeController
        
        let viewControllers: [UIViewController] = [
            sensorDataViewController,
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

