//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

let appName = "SDL Example Swift"
let shortAppName = "SDLSwift"
let appId = "9998"
let defaultIP = "192.168.1.59"
let defaultPort: UInt16 = 12345
let PointingSoftButtonArtworkName: String = "PointingSoftButtonIcon"
let MainGraphicArtworkName: String = "MainArtwork"
let ShouldRestartOnDisconnect: Bool = false

class ProxyManager: NSObject {
    
    
    // Manager
    fileprivate let sdlManager: SDLManager
    
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init( ) {
        
        // Used for USB Connection
        let lifecycleConfiguration = SDLLifecycleConfiguration.defaultConfiguration(withAppName: appName, appId: appId)
        
        // Used for TCP/IP Connection
        // let lifecycleConfiguration = SDLLifecycleConfiguration.debugConfiguration(withAppName: appName, appId: appId, ipAddress: defaultIP, port: defaultPort)
        
        // App icon image
        if let appImage = UIImage(named: MainGraphicArtworkName) {
            let appIcon = SDLArtwork.persistentArtwork(with: appImage, name: MainGraphicArtworkName, as: .JPG /* or .PNG */)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = shortAppName
        lifecycleConfiguration.appType = .media()
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled())
        
        sdlManager = SDLManager(configuration: configuration, delegate: nil)
        
        super.init()
        
        sdlManager.delegate = self
    }
    
    func connect() {
        // Start watching for a connection with a SDL Core
        sdlManager.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
            }
        }
    }
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
        print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
    }
}


