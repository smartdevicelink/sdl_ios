//
//  Preferences.swift
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 5/15/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation

var ipAddress: String = ""
var port: UInt16 = 0
let IPAddressPreferencesKey: String = "SDLExampleAppIPAddress"
let PortPreferencesKey: String = "SDLExampleAppPort"
let DefaultIPAddressValue: String = "192.168.1.1"
let DefaultPortValue: UInt16 = 12345

class Preferences {
    // MARK: - Singleton / Initializers
    
    override init() {
        super.init()
        if ipAddress == nil || port == 0 {
            reset()
        }
    }
    
    class func shared() -> Preferences {
        var sharedPreferences: Preferences? = nil
        var onceToken: Int
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            sharedPreferences = Preferences()
        }
        onceToken = 1
        return sharedPreferences!
    }
    
    // MARK: - Class Queue
    class func preferencesQueue() -> DispatchQueue {
        var preferencesQueue: DispatchQueue
        var onceToken: Int
        if (onceToken == 0) {
            /* TODO: move below code to a static variable initializer (dispatch_once is deprecated) */
            preferencesQueue = DispatchQueue(label: "com.sdl-exampleSwift.preferences")
        }
        onceToken = 1
        return preferencesQueue
    }
    
    // MARK: - Public API
    func resetPreferences() {
        ipAddress = DefaultIPAddressValue
        port = DefaultPortValue
    }
    
    // MARK: - Setters / Getters
    
    // MARK: - Private User Defaults Helpers
    func set(_ aString: String, forKey aKey: String) {
        assert(aKey != nil, "Invalid parameter not satisfying: aKey != nil")
        Preferences.preferencesQueue().async(execute: {() -> Void in
            UserDefaults.standard.set(aString, forKey: aKey)
        })
    }
    
    func string(forKey aKey: String) -> String {
        assert(aKey != nil, "Invalid parameter not satisfying: aKey != nil")
        var retVal: String? = nil
        Preferences.preferencesQueue().sync(execute: {() -> Void in
            retVal = UserDefaults.standard.string(forKey: aKey)
        })
        return retVal!
    }
    
    func set(_ aInt: Int, forKey aKey: String) {
        assert(aKey != nil, "Invalid parameter not satisfying: aKey != nil")
        Preferences.preferencesQueue().async(execute: {() -> Void in
            UserDefaults.standard.set(aInt, forKey: aKey)
        })
    }
    
    func integer(forKey aKey: String) -> Int {
        assert(aKey != nil, "Invalid parameter not satisfying: aKey != nil")
        var retVal: Int = 0
        Preferences.preferencesQueue().sync(execute: {() -> Void in
            retVal = UserDefaults.standard.integer(forKey: aKey)
        })
        return retVal
    }
}
