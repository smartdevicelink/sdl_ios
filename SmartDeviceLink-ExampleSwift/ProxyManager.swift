//
//  ProxyManager.swift
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class ProxyManager: NSObject {
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init() {
        super.init()
    }
}

