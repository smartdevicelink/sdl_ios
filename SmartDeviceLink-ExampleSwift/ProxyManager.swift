//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

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

enum ProxyState : Int {
    case ProxyStateStopped
    case ProxyStateSearchingForConnection
    case ProxyStateConnected
}

weak var delegate:ProxyManagerDelegate?
var firstTimeState = SDLHMIFirstState(rawValue: 0)
var initialShowState = SDLHMIInitialShowState(rawValue: 0)
fileprivate var firstHMIFull = true

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: ProxyState)
}

class ProxyManager: NSObject {
    
    // Proxy Manager
    fileprivate var sdlManager: SDLManager!
    var state = ProxyState(rawValue: 0)!
    let appIcon = UIImage(named: "AppIcon60x60")

    // Singleton
    static let sharedManager = ProxyManager()
    private override init() {
        super.init()
    }
    
    // MARK: - SDL Setup
     func startIAP() {
        delegate?.didChangeProxyState(ProxyState.ProxyStateSearchingForConnection)
        let lifecycleConfiguration = setLifecycleConfigurationPropertiesOnConfiguration(SDLLifecycleConfiguration.defaultConfiguration(withAppName: AppConstants.sdlAppName, appId: AppConstants.sdlAppID))
        startSDLManager(lifecycleConfiguration)
    }
    
     func startTCP() {
        delegate?.didChangeProxyState(ProxyState.ProxyStateSearchingForConnection)
        let defaultIP = UserDefaults.standard.string(forKey: "ipAddress")!
        let defaultPort = UInt16(UserDefaults.standard.string(forKey: "port")!)!
        let lifecycleConfiguration = setLifecycleConfigurationPropertiesOnConfiguration(SDLLifecycleConfiguration.debugConfiguration(withAppName: AppConstants.sdlAppName, appId: AppConstants.sdlAppID, ipAddress: defaultIP, port: defaultPort))
        startSDLManager(lifecycleConfiguration)
    }
    
    private func startSDLManager(_ lifecycleConfiguration: SDLLifecycleConfiguration) {
        // Configure the proxy handling RPC calls between the SDL Core and the app
        let configuration: SDLConfiguration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: SDLLockScreenConfiguration.enabledConfiguration(withAppIcon: appIcon!, backgroundColor: nil))
        self.sdlManager = SDLManager(configuration: configuration, delegate: self)
        
        // Start watching for a connection with a SDL Core
        self.sdlManager?.start(readyHandler: { [unowned self] (success, error) in
            if success {
                // Get ready here
                print("SDL start file manager storage: \(self.sdlManager!.fileManager.bytesAvailable / 1024 / 1024) mb")
            }
            
            if let error = error {
                print("Error starting SDL: \(error)")
            }
        })
    }
    
    private func setLifecycleConfigurationPropertiesOnConfiguration(_ configuration: SDLLifecycleConfiguration) -> SDLLifecycleConfiguration {
        configuration.shortAppName = AppConstants.sdlShortAppName
        configuration.appType = SDLAppHMIType.media()
        configuration.appIcon = SDLArtwork.persistentArtwork(with: appIcon!, name: "AppIcon", as: .PNG)
        
        return configuration
    }
    
    func send(request: SDLRPCRequest, responseHandler: SDLResponseHandler? = nil) {
        guard sdlManager.hmiLevel != .none() else {
            return
        }
        
        sdlManager.send(request, withResponseHandler: responseHandler)
    }
    
    func forceSend(request: SDLRPCRequest, responseHandler: SDLResponseHandler? = nil) {
        sdlManager.send(request, withResponseHandler: responseHandler)
    }
    
    func hasUploadedFile(name: String) -> Bool {
        return sdlManager.fileManager.remoteFileNames.contains(name)
    }

    func reset() {
        sdlManager?.stop()
        delegate?.didChangeProxyState(ProxyState.ProxyStateStopped)
    }
}

// MARK: Speak
extension ProxyManager {
    class func appNameSpeak() -> SDLSpeak {
        let speak = SDLSpeak()
        speak?.ttsChunks = SDLTTSChunk.textChunks(from: "S D L Example App")
        return speak!
    }
    
    class func goodJobSpeak() -> SDLSpeak {
        let speak = SDLSpeak()
        speak?.ttsChunks = SDLTTSChunk.textChunks(from: "Good Job")
        return speak!
    }
    
    class func youMissedItSpeak() -> SDLSpeak {
        let speak = SDLSpeak()
        speak?.ttsChunks = SDLTTSChunk.textChunks(from: "You missed it")
        return speak!
    }
}

// MARK: Files / Artwork
extension ProxyManager {

}

// MARK: RPC Builders
extension ProxyManager {
    
}

//MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
                delegate?.didChangeProxyState(ProxyState.ProxyStateStopped)
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
        // On our first HMI level that isn't none, do some setup
        if newLevel != .none() && firstHMIFull == true {
            firstHMIFull = false
        }
        
        // HMI state is changing from NONE or BACKGROUND to FULL or LIMITED
        if (oldLevel == .none() || oldLevel == .background())
            && (newLevel == .full() || newLevel == .limited()) {

        } else if (oldLevel == .full() || oldLevel == .limited())
            && (newLevel == .none() || newLevel == .background()) {
            // HMI state changing from FULL or LIMITED to NONE or BACKGROUND

            
        }
    }
}


