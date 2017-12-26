//
//  EngineSim.swift
//  RemoG
//
//  Created by Jakob Hain on 12/23/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class EngineSim {
    static let sleepTime: TimeInterval = 0.5
    
    var controller: RootController? = nil
    var ot: Float = 0
    var cht: Float = 0
    var op: Float = 0
    var runTimeLeft: TimeInterval = TimeInterval.nan
    private var runTimer: Timer? = nil
    
    ///Makes the EngineSim run for a random amount of time.
    ///If it's already running, just "restarts" it to that amount of time.
    func start() {
        runTimeLeft = TimeInterval(Float.rand(minr: 5 * 60, maxr: 90 * 60))
        if runTimer == nil {
            runTimer = Timer.scheduledTimer(
                withTimeInterval: EngineSim.sleepTime,
                repeats: true,
                block: updateState
            )
        }
    }
    
    private func updateState(runTimer: Timer) {
        assert(self.runTimer == runTimer)
        
        if runTimeLeft > 0 {
            updateSimulationState()
        } else {
            runTimeLeft = TimeInterval.nan
            runTimer.invalidate()
            self.runTimer = nil
        }
    }
    
    ///Simulates a few engine stats.
    func updateSimulationState() {
        simOilTemp()
        simOilPressure()
        simCht()
        updateController()
        runTimeLeft -= EngineSim.sleepTime
    }

    func simOilTemp() {
        // Begin with 60 F
        if ot == 0 {
            ot = 60
        } else if ot > 240 {
            // We have reached a max temp, hover there
            ot = Float.newVal(lastVal: ot, r: 5, bias: 0)
        } else if ot < 180 {
            // Engine is still warming up
            ot = ot + 5
        } else {
            // Operating temp
            ot = Float.newVal(lastVal: ot, r: 3, bias: 0.25)
        }
    }
        
    func simCht() {
        if cht == 0 {
            cht = 100
        } else if cht < 250 {
            cht = Float.newVal(lastVal: cht, r: 5, bias: 10)
        } else if cht > 350 {
            cht = Float.newVal(lastVal: cht, r: 1, bias: -0.5)
        } else {
            cht = Float.newVal(lastVal: cht, r: 5, bias: 0.25)
        }
    }
        
    func simOilPressure() {
        if op == 0 {
            op = 60
        } else if op < 5 {
            op = Float.newVal(lastVal: op, r: 0.5, bias: 0)
        } else if op < 10 {
            op = Float.newVal(lastVal: op, r: 1, bias: 0.01)
        } else {
            op = Float.newVal(lastVal: op, r: 2, bias: -1)
        }
    }
    
    func updateController() {
        controller?.otf = ot
        controller?.chtf = Int(cht)
        controller?.oilPsi = Int(op)
    }
}

extension Float {
    /// Generate a random number between minr, maxr
    static func rand(minr: Float, maxr: Float) -> Float {
        let rFrom0To1 = Float(arc4random()) / Float(UInt32.max)
        let diff = maxr - minr
        let r = rFrom0To1 * diff
        return minr + r
    }
    
    /// Generate a new random number centered around lastVal
    /// of range 'r' and bias 'bias'
    static func newVal(lastVal: Float, r: Float, bias: Float) -> Float {
        let mn = (lastVal - r) + bias
        let mx = (lastVal + r) + bias
        return rand(minr: mn, maxr: mx)
    }
}
