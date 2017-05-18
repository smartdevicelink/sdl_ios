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
                delegate?.didChangeProxyState(ProxyState.ProxyStateConnected)
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
        }
        // HMI state is changing from NONE or BACKGROUND to FULL or LIMITED
        if (oldLevel == .none() || oldLevel == .background())
            && (newLevel == .full() || newLevel == .limited()) {
            setText()
            setDisplayLayout()
            prepareRemoteSystem(overwrite: true) { [unowned self] in
                self.showMainImage()
                self.prepareButtons()
            }
        } else if (oldLevel == .full() || oldLevel == .limited())
            && (newLevel == .none() || newLevel == .background()) {
            // HMI state changing from FULL or LIMITED to NONE or BACKGROUND
        }
    }
}

// MARK: - Uploads
extension ProxyManager {
    func prepareRemoteSystem(overwrite: Bool = false, completionHandler: @escaping (Void) -> (Void)) {
        let group = DispatchGroup()
        group.enter()
        group.notify(queue: .main) {
            completionHandler()
        }
        
        // Send images
        if !sdlManager.fileManager.remoteFileNames.contains(AppConstants.mainArtwork) {
            let artwork = SDLArtwork(image: #imageLiteral(resourceName: "sdl_logo_green"), name: AppConstants.mainArtwork, persistent: true, as: .PNG)
            group.enter()
            sdlManager.fileManager.uploadFile(artwork, completionHandler: { (_, _, error) in
                group.leave()
                if let error = error {
                    print("Error uploading default artwork \(artwork) with error \(error)")
                }
            })
        }
        if !sdlManager.fileManager.remoteFileNames.contains(AppConstants.PointingSoftButtonArtworkName) {
            let buttonIconPoint = SDLArtwork(image: #imageLiteral(resourceName: "sdl_softbutton_icon"), name: AppConstants.PointingSoftButtonArtworkName, persistent: true, as: .PNG)
            group.enter()
            sdlManager.fileManager.uploadFile(buttonIconPoint, completionHandler: { (_, _, error) in
                group.leave()
                if let error = error {
                    print("Error uploading default artwork \(buttonIconPoint) with error \(error)")
                }
            })
        }
        group.leave()
    }
}

// MARK: - RPCs
extension ProxyManager {
    // Set Text
    func setText(){
        let show = SDLShow(mainField1: "SDL", mainField2: "Test App", alignment: .centered())
        send(request: show!)
    }
    
    // Set Display Layout
    func setDisplayLayout(){
        let display = SDLSetDisplayLayout(predefinedLayout: .text_AND_SOFTBUTTONS_WITH_GRAPHIC())!
        send(request: display)
    }
    // Show Main Image
    func showMainImage(){
        let sdlImage = SDLImage(name: AppConstants.mainArtwork, of: .dynamic())
        let show = SDLShow()!
        show.graphic = sdlImage
        send(request: show)
    }
    
    // Create Soft Buttons
    func prepareButtons(){
        let softButton = SDLSoftButton()!
        // Button Id
        softButton.softButtonID = 100
        // Button handler - This is called when user presses the button
        softButton.handler = { (notification) in
            if let onButtonPress = notification as? SDLOnButtonPress {
                if onButtonPress.buttonPressMode.isEqual(to: SDLButtonPressMode.short()) {
                    // Short button press
                    let alert = SDLAlert()!
                    alert.alertText1 = "You pushed the button!"
                    self.send(request: alert)
                }
            }
        }
        // Button type can be text, image, or both text and image
        softButton.type = .both()
        // Button text
        softButton.text = AppConstants.buttonText
        // Button image
        softButton.image = SDLImage(name: AppConstants.PointingSoftButtonArtworkName, of: .dynamic())
        let show = SDLShow()!
        // The buttons are set as part of an array
        show.softButtons = [softButton]
        
        // Send the request
        send(request: show)
    }
    
    
    // Create Choice Interaction Set
}
