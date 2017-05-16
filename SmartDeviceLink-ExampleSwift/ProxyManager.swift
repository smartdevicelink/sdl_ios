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

weak var delegate:ProxyManagerDelegate?

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: ProxyState)
}

class ProxyManager: NSObject {
    
    // Proxy Manager
    fileprivate var sdlManager: SDLManager!
    var state = ProxyState(rawValue: 0)!

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
        let appIcon = UIImage(named: "AppIcon60x60")
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
        let appIcon = UIImage(named: "AppIcon60x60")
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
        delegate?.didChangeProxyState(ProxyState.ProxyStateStopped)
        sdlManager?.stop()
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


