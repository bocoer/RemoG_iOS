//
//  CallbackObj.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

///A callback which is also an object, so it can be in NSMapTable.
class CallbackObj {
    let callback: () -> Void
    init(_ callback: @escaping () -> Void) {
        self.callback = callback
    }
}
