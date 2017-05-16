//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

enum ProxyState : Int {
    case ProxyStateStopped
    case ProxyStateSearchingForConnection
    case ProxyStateConnected
}

let appName = "SDL Example Swift"
let shortAppName = "SDLSwift"
let appId = "9998"
var defaultIP = "192.168.1.59"
var defaultPort: UInt16 = 12345
let PointingSoftButtonArtworkName: String = "PointingSoftButtonIcon"
let MainGraphicArtworkName: String = "MainArtwork"
weak var delegate:ProxyManagerDelegate?

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: ProxyState)
}

class ProxyManager: NSObject {
    
    // Proxy Manager
    var sdlManager: SDLManager?
    var state = ProxyState(rawValue: 0)!

    // Singleton
    static let sharedManager = ProxyManager()
    private override init() {
        super.init()
    }
    
    func connectTCP() {
        delegate?.didChangeProxyState(ProxyState.ProxyStateSearchingForConnection)
        // Used for TCP/IP Connection
        defaultIP = UserDefaults.standard.string(forKey: "ipAddress")!
        defaultPort = UInt16(UserDefaults.standard.string(forKey: "port")!)!
        
        let lifecycleConfiguration = SDLLifecycleConfiguration.debugConfiguration(withAppName: appName, appId: appId, ipAddress: defaultIP, port: defaultPort)
        
        // App icon image
        if let appImage = UIImage(named: MainGraphicArtworkName) {
            let appIcon = SDLArtwork.persistentArtwork(with: appImage, name: MainGraphicArtworkName, as: .JPG /* or .PNG */)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = shortAppName
        lifecycleConfiguration.appType = .media()
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled())
        
        sdlManager = SDLManager(configuration: configuration, delegate: nil)
        sdlManager?.delegate = self
        // Start watching for a connection with a SDL Core
        sdlManager?.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
                delegate?.didChangeProxyState(ProxyState.ProxyStateConnected)
            }
        }
    }
    
    func connectIAP() {
        delegate?.didChangeProxyState(ProxyState.ProxyStateSearchingForConnection)
        // Used for USB Connection
        let lifecycleConfiguration = SDLLifecycleConfiguration.defaultConfiguration(withAppName: appName, appId: appId)
        // App icon image
        if let appImage = UIImage(named: MainGraphicArtworkName) {
            let appIcon = SDLArtwork.persistentArtwork(with: appImage, name: MainGraphicArtworkName, as: .JPG /* or .PNG */)
            lifecycleConfiguration.appIcon = appIcon
        }
        
        lifecycleConfiguration.shortAppName = shortAppName
        lifecycleConfiguration.appType = .media()
        
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled())
        
        sdlManager = SDLManager(configuration: configuration, delegate: nil)
        sdlManager?.delegate = self
        // Start watching for a connection with a SDL Core
        sdlManager?.start { (success, error) in
            if success {
                // Your app has successfully connected with the SDL Core
                delegate?.didChangeProxyState(ProxyState.ProxyStateConnected)
            }
        }
    }
    
    func sdlex_updateProxyState(_ newState: ProxyState) {
        if state != newState {
            willChangeValue(forKey: "state")
            state = newState
            didChangeValue(forKey: "state")
        }
    }

}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
                delegate?.didChangeProxyState(ProxyState.ProxyStateStopped)
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
        print("Went from HMI level \(oldLevel) to HMI level \(newLevel)")
    }
}


