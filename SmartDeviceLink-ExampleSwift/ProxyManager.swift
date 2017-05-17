//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Created by Bretty White on 5/12/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
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
fileprivate var firstTimeState = SDLHMIFirstState(rawValue: 0)
fileprivate var initialShowState = SDLHMIInitialShowState(rawValue: 0)
fileprivate var firstHMIFull = true
var state = ProxyState(rawValue: 0)!
let appIcon = UIImage(named: "AppIcon60x60")

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: ProxyState)
}

class ProxyManager: NSObject {
    
    fileprivate var sdlManager: SDLManager!
    
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
    func prepareRemoteSystem() {
        let group = DispatchGroup()
        
        // Send images
        let artwork = SDLArtwork(image: #imageLiteral(resourceName: "sdl_logo_green"), name: "sdl_logo_green", persistent: true, as: .PNG)
        group.enter()
        artwork.overwrite = true
        sdlManager.fileManager.uploadFile(artwork, completionHandler: { (_, _, error) in
            group.leave()
            if let error = error {
                print("Error uploading default artwork \(artwork) with error \(error)")
            }
        })
        
        let buttonIconPoint = SDLArtwork(image:  #imageLiteral(resourceName: "sdl_softbutton_icon"), name: AppConstants.PointingSoftButtonArtworkName, persistent: true, as: .PNG)
        group.enter()
        artwork.overwrite = true
        sdlManager.fileManager.uploadFile(buttonIconPoint, completionHandler: { (_, _, error) in
            group.leave()
            if let error = error {
                print("Error uploading default artwork \(artwork) with error \(error)")
            }
        })
        
        // Create Soft Buttons
        
        // Create Choice Interaction Set
    }
}

// MARK: RPC Builders
extension ProxyManager {
    
    // Soft Button
    class func pointingSoftButton(with manager: SDLManager) -> SDLSoftButton {
        let softButton = SDLSoftButton(handler: {(_ notification: SDLRPCNotification) -> Void in
            if (notification is SDLOnButtonPress) {
                let alert = SDLAlert()
                alert?.alertText1 = "You pushed the button!"
                manager.send(alert!)
            }
        })
        softButton?.text = "Press"
        softButton?.softButtonID = 100
        softButton?.type = SDLSoftButtonType.both()
        let image = SDLImage()
        image?.imageType = SDLImageType.dynamic()
        image?.value = AppConstants.PointingSoftButtonArtworkName
        softButton?.image = image
        return softButton!
    }
    
    class func createOnlyChoiceInteractionSet() -> SDLCreateInteractionChoiceSet {
        let createInteractionSet = SDLCreateInteractionChoiceSet()
        createInteractionSet?.interactionChoiceSetID = 0
        let theOnlyChoiceName: String = "The Only Choice"
        let theOnlyChoice = SDLChoice()
        theOnlyChoice?.choiceID = 0
        theOnlyChoice?.menuName = theOnlyChoiceName
        theOnlyChoice?.vrCommands = [theOnlyChoiceName]
        createInteractionSet?.choiceSet = [Any](arrayLiteral: [theOnlyChoice]) as! NSMutableArray
        return createInteractionSet!
    }
    
    class func sendPerformOnlyChoiceInteraction(with manager: SDLManager) {
        let performOnlyChoiceInteraction = SDLPerformInteraction()
        performOnlyChoiceInteraction?.initialText = "Choose the only one! You have 5 seconds..."
        performOnlyChoiceInteraction?.initialPrompt = SDLTTSChunk.textChunks(from: "Choose it")
        performOnlyChoiceInteraction?.interactionMode = SDLInteractionMode.both()
        performOnlyChoiceInteraction?.interactionChoiceSetIDList = [0]
        performOnlyChoiceInteraction?.helpPrompt = SDLTTSChunk.textChunks(from: "Do it")
        performOnlyChoiceInteraction?.timeoutPrompt = SDLTTSChunk.textChunks(from: "Too late")
        performOnlyChoiceInteraction?.timeout = 5000
        performOnlyChoiceInteraction?.interactionLayout = SDLLayoutMode.list_ONLY()
        manager.send(performOnlyChoiceInteraction!) { (request, response, error) in
            guard let performInteractionResponse = response as? SDLPerformInteractionResponse else {
                return;
            }
            
            // Wait for user's selection or for timeout
            if performInteractionResponse.resultCode == .timed_OUT() {
                // The custom menu timed out before the user could select an item
            } else if performInteractionResponse.resultCode == .success() {
                let choiceId = performInteractionResponse.choiceID
                // The user selected an item in the custom menu
            }
        }
    }

}

// MARK: SDLManagerDelegate
extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        print("Manager disconnected!")
                delegate?.didChangeProxyState(ProxyState.ProxyStateStopped)
    }
    
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeTo newLevel: SDLHMILevel) {
        // On our first HMI level that isn't none, do some setup
        if newLevel != .none() && firstHMIFull == true {
            firstHMIFull = false
            prepareRemoteSystem()
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


