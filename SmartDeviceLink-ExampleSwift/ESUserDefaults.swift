//
//  ESUserDefaults.swift
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit

class ESUserDefaults {
    struct Keys {
        static let ipAddress = "ipAddress"
        static let port = "port"
    }

    static let shared = ESUserDefaults()

    static func setDefaults() {
        var defaults: [String : Any] = [:]

        defaults[Keys.ipAddress] = String()
        defaults[Keys.port] = String()

        UserDefaults.standard.register(defaults: defaults)
    }

    var ipAddress: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.ipAddress)
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: Keys.ipAddress)
        }
    }

    var port: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.port)
        }
        set {
            UserDefaults.standard.setValue(newValue!, forKeyPath: Keys.port)
        }
    }
}
