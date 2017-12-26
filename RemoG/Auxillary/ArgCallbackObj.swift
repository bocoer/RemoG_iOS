//
//  ArgCallbackObj.swift
//  RemoG
//
//  Created by Jakob Hain on 12/26/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

///A callback which is also an object, which takes 1 argument,
///so it can encode a Swift closure in a target and selector.
class ArgCallbackObj {
    let callback: (AnyObject) -> Void
    init(_ callback: @escaping (AnyObject) -> Void) {
        self.callback = callback
    }
    
    @objc func callbackSel(_ arg: AnyObject) {
        callback(arg)
    }
}
