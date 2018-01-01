//
//  GaugeDualViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

/*
 * Controls a view which displays both a gauge and sensor data.
 */
class GaugeDualViewController: SensorDataViewController {
    var gaugeController: GaugeController! {
        didSet {
            gaugeViewController?.gaugeController = gaugeController
        }
    }
    var gaugeViewController: GaugeViewController! {
        didSet {
            gaugeViewController?.gaugeController = gaugeController
        }
    }
    
    @IBOutlet private var portraitConstraints: [NSLayoutConstraint]!
    @IBOutlet private var landscapeConstraints: [NSLayoutConstraint]!

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateOrientationConstraints(forSize: view.bounds.size)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { context in
            self.updateOrientationConstraints(forSize: size)
        }, completion: nil)
    }
    
    private func updateOrientationConstraints(forSize size: CGSize) {
        let isLandscape = size.width > size.height
        
        //Needs different order.
        //Both portrait and landscape constraints
        //can never be enabled at the same time --
        //needs to disable old constraints before enabling new ones.
        if isLandscape {
            for portraitConstraint in portraitConstraints {
                portraitConstraint.isActive = false
            }
            for landscapeConstraint in landscapeConstraints {
                landscapeConstraint.isActive = true
            }
        } else {
            for landscapeConstraint in landscapeConstraints {
                landscapeConstraint.isActive = false
            }
            for portraitConstraint in portraitConstraints {
                portraitConstraint.isActive = true
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let segueId = segue.identifier {
            switch segueId {
            case "EmbedGaugeViewController":
                gaugeViewController = segue.destination as! GaugeViewController
                gaugeViewController.gaugeController = gaugeController
            default: break
            }
        }
    }
}
