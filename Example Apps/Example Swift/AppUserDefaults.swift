//
//  ESUserDefaults.swift
//  SmartDeviceLink-iOS
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//
import UIKit

class AppUserDefaults {
    struct Keys {
        static let ipAddress = "ipAddress"
        static let port = "port"
        static let lastUsedSegment = "lastUsedSegment"
    }

    static let shared = AppUserDefaults()

    static func setDefaults() {
        var defaults: [String : Any] = [:]

        defaults[Keys.ipAddress] = String()
        defaults[Keys.port] = String()
        defaults[Keys.lastUsedSegment] = 0

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

    var lastUsedSegment: Int? {
        get {
            return UserDefaults.standard.integer(forKey: Keys.lastUsedSegment)
        }
        set {
            UserDefaults.standard.set(newValue!, forKey: Keys.lastUsedSegment)
        }
    }
}
