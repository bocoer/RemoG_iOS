//
//  LocationAvailability.swift
//  RemoG
//
//  Created by Jakob Hain on 12/26/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import Foundation

enum LocationAvailability {
    ///The application can't access location services.
    case disabled
    ///Location services are unavailable, not necessarily paused
    case unavailable
    ///Location services are available
    case available
}
