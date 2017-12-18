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
    var viewControllers: [UIViewController]!
    var pageViewController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sensorDataViewController = storyboard!.instantiateViewController(withIdentifier: "SensorDataViewController") as! SensorDataViewController
        sensorDataViewController.sensorDataController = rootController.sensorDataController
        
        viewControllers = [
            sensorDataViewController
        ]
        
        pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageViewController!.setViewControllers(
            viewControllers,
            direction: .forward,
            animated: false,
            completion: { done in }
        )

        self.addChildViewController(pageViewController!)
        self.view.addSubview(pageViewController!.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

