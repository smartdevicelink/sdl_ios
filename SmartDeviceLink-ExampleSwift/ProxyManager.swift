//
//  ProxyManager.swift
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

enum ProxyTransportType : Int {
    case ProxyTransportTypeUnknown
    case ProxyTransportTypeTCP
    case ProxyTransportTypeIAP
}

enum ProxyState : Int {
    case ProxyStateStopped
    case ProxyStateSearchingForConnection
    case ProxyStateConnected
}

enum SDLHMIFirstState : Int {
    case SDLHMIFirstStateNone
    case SDLHMIFirstStateNonNone
    case SDLHMIFirstStateFull
}

enum SDLHMIInitialShowState : Int {
    case SDLHMIInitialShowStateNone
    case SDLHMIInitialShowStateDataAvailable
    case SDLHMIInitialShowStateShown
}

let sdlAppName = "SDL Example Swift"
let sdlShortAppName = "SDLSwift"
let sdlAppID = "9998"
let PointingSoftButtonArtworkName: String = "PointingSoftButtonIcon"
let MainGraphicArtworkName: String = "MainArtwork"
let ShouldRestartOnDisconnect: Bool = false

class ProxyManager: NSObject {
    
    // Proxy Manager
    var sdlManager: SDLManager?
    
    // Singleton
    static let sharedManager = ProxyManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - SDL Setup
    fileprivate func startIAP() {
        //let lifecycleConfiguration = SDLLifecycleConfiguration.defaultConfiguration(withAppName: sdlAppName, appId: sdlAppID)
        //startSDLManager(lifecycleConfiguration)
    }

    fileprivate func startTCP() {
        //let lifecycleConfiguration = SDLLifecycleConfiguration.debugConfiguration(withAppName: sdlAppName, appId: sdlAppID, ipAddress:, port: Preferences.shared().port)
        //startSDLManager(lifecycleConfiguration)
    }
    
    fileprivate func startSDLManager(_ lifecycleConfiguration: SDLLifecycleConfiguration) {
        // Start watching for a connection with a SDL Core
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled())
        sdlManager = SDLManager(configuration: configuration, delegate: self as? SDLManagerDelegate)
        
        // Start watching for a connection with a SDL Core
        self.sdlManager?.start(readyHandler: { [unowned self] (success, _) in
            if success {
                // Get ready here
                print("SDL start file manager storage: \(self.sdlManager!.fileManager.bytesAvailable / 1024 / 1024) mb")

            }
        })
    }

}

// MARK: - Notifications
extension ProxyManager {

    fileprivate func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ProxyManager.hmiStatusChanged), name: .SDLDidChangeHMIStatus, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ProxyManager.lockScreenStatusChanged(notification:)), name: .SDLDidChangeLockScreenStatus, object: nil)
    }
    
    func hmiStatusChanged(notification: SDLRPCNotificationNotification) {
        guard notification.notification is SDLOnHMIStatus else { return }

    }
    
    func lockScreenStatusChanged(notification: SDLRPCNotificationNotification) {
        print("got notification: \(notification)")
    }
}



