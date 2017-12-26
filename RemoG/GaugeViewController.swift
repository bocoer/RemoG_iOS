//
//  GaugeViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class GaugeViewController: UIViewController {
    var gaugeController: GaugeController! {
        didSet {
            updateGauge()
            gaugeController.changeHandlers[self] = updateGauge
        }
    }
    
    var gaugeView: GaugeView! {
        get { return view as! GaugeView! }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        assert(view is GaugeView, "GaugeViewController's view needs to be GaugeView")
    }
    
    func updateGauge() {
        gaugeView.gaugeValue = gaugeController.gaugeValue
        gaugeView.minGaugeValue = gaugeController.minValue
        gaugeView.maxGaugeValue = gaugeController.maxValue
        gaugeView.numMajorTicks = gaugeController.numMajorTicks
        gaugeView.numMinorTicks = gaugeController.numMinorTicks
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
