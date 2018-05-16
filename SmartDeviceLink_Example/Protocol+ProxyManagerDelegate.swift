//
//  Protocol+ProxyManagerDelegate.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: ProxyState)
}
