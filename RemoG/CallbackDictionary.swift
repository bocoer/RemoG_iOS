//
//  CallbackDictionary.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

class CallbackDictionary {
    let mapTable: NSMapTable<AnyObject, CallbackObj> = NSMapTable(keyOptions: .weakMemory, valueOptions: .strongMemory)
    
    subscript(key: AnyObject) -> (() -> Void)? {
        get {
            return mapTable.object(forKey: key)?.callback
        } set(newOptValue) {
            if let newValue = newOptValue {
                mapTable.setObject(CallbackObj(newValue), forKey: key)
            } else {
                mapTable.removeObject(forKey: key)
            }
        }
    }
    
    func callbackAll() -> Void {
        for callbackObj in mapTable.objectEnumerator()! {
            (callbackObj as! CallbackObj).callback()
        }
    }
}
