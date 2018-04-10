//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import SmartDeviceLink
import UIKit

protocol ProxyManagerDelegate: class {
    func didChangeProxyState(_ newState: SDLProxyState)
}

class ProxyManager: NSObject {
    fileprivate var sdlManager: SDLManager?
    weak var delegate: ProxyManagerDelegate?
    fileprivate var firstHMILevelState = SDLHMILevelFirstState.none
    fileprivate var isVehicleDataSubscribed = false

    // Singleton
    static let sharedManager = ProxyManager()
    private override init() {
        super.init()
        firstHMILevelState = .none
    }
}

// MARK: - SDL Connection

extension ProxyManager {
    func startIAPConnection() {
        delegate?.didChangeProxyState(SDLProxyState.searching)
        let lifecycleConfiguration = setLifecycleConfiguration(SDLLifecycleConfiguration(appName: AppConstants.sdlAppName, appId: AppConstants.sdlAppID))
        setupManagerConfiguration(lifecycleConfiguration: lifecycleConfiguration)
    }

    func startTCPConnection() {
        delegate?.didChangeProxyState(SDLProxyState.searching)
        let lifecycleConfiguration = setLifecycleConfiguration(SDLLifecycleConfiguration(appName: AppConstants.sdlAppID, appId: AppConstants.sdlAppID, ipAddress: AppUserDefaults.shared.ipAddress!, port: UInt16(AppUserDefaults.shared.port!)!))
        setupManagerConfiguration(lifecycleConfiguration: lifecycleConfiguration)
    }

    func resetConnection() {

        delegate?.didChangeProxyState(SDLProxyState.stopped)

        guard sdlManager != nil else { return }
        sdlManager?.stop()
        sdlManager = nil
    }
}

// MARK: - SDL Setup

private extension ProxyManager {
    /// TODO
    ///
    /// - Parameter configuration: TODO
    /// - Returns: TODO
    func setLifecycleConfiguration(_ configuration: SDLLifecycleConfiguration) -> SDLLifecycleConfiguration {
        configuration.shortAppName = AppConstants.sdlShortAppName
        configuration.appType = .media
        configuration.appIcon = SDLArtwork(image: AppConstants.sdlAppLogo!, persistent: true, as: .PNG)
        return configuration
    }

    /// Create the SDL manager
    ///
    /// - Parameter lifecycleConfiguration: The type of transport layer to use between the app and head unit
    func setupManagerConfiguration(lifecycleConfiguration: SDLLifecycleConfiguration) {
        let configuration = SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: .enabled(), logging: .debug())
        sdlManager = SDLManager(configuration: configuration, delegate: self)
        guard let sdlManager = sdlManager else {
            resetConnection()
            return
        }
        startManager(sdlManager)
    }

    /// Start searching for a connection with SDL Core
    ///
    /// - Parameter manager: The SDL Manager
    func startManager(_ manager: SDLManager) {
        manager.start(readyHandler: { [unowned self] (success, error) in
            guard success else {
                self.resetConnection()
                return
            }

            self.delegate?.didChangeProxyState(SDLProxyState.connected)
//                self.addRPCObservers()
//                self.addPermissionManagerObservers()
            print("SDL start file manager storage: \(self.sdlManager!.fileManager.bytesAvailable / 1024 / 1024) mb")

            if let error = error {
                // An error may be returned even if the connection is successful
                print("Error starting SDL: \(error)")
            }
        })
    }


//    func send(request: SDLRPCRequest, responseHandler: SDLResponseHandler? = nil) {
//        guard sdlManager.hmiLevel != .none else {
//            return
//        }
//        sdlManager.send(request, withResponseHandler: responseHandler)
//    }

}

// MARK: - SDLManagerDelegate

extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        delegate?.didChangeProxyState(SDLProxyState.stopped)
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if !(newLevel == .none && firstHMILevelState == .none) {
            // This is our first time in a non-NONE state
            firstHMILevelState = .nonNone

            // Send AddCommands
            // TODO
        }

        if newLevel == .full && firstHMILevelState != .full {
            // This is our first time in a FULL state
            firstHMILevelState = .full
        }

        if newLevel == .full {
            // We're always going to try to show the initial state, because if we've already shown it, it won't be shown, and we need to guard against some possible weird states
            // TODO: show initial data
        }

//        // On our first HMI level that isn't none, do some setup
//        if newLevel != .none && firstHMIFull == true {
//            firstHMIFull = false
//        }
//        // HMI state is changing from NONE or BACKGROUND to FULL or LIMITED
//        if (oldLevel == .none || oldLevel == .background) && (newLevel == .full || newLevel == .limited) {
////            prepareRemoteSystem(overwrite: true) { [unowned self] in
////                self.showMainImage()
////                self.prepareButtons()
////                self.addSpeakMenuCommand()
////                self.addperformInteractionMenuCommand()
////                self.setText()
////                self.setDisplayLayout()
////                self.subscribeVehicleData()
////            }
//        }
    }

    func audioStreamingState(_ oldState: SDLAudioStreamingState?, didChangeToState newState: SDLAudioStreamingState) {
        // The following states only apply if the app is streaming audio
        switch newState {
        case .audible: break        // The SDL app's audio can be heard
        case .notAudible: break     // The SDL app's audio cannot be heard
        case .attenuated: break     // The SDL app's audio volume has been lowered to let the system speak over the audio. This usually happens with voice recognition commands.
        default: break
        }
    }
}

//// MARK: - Prepare Remote System
//extension ProxyManager {
//    fileprivate func addRPCObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(didReceiveVehicleData(_:)), name: .SDLDidReceiveVehicleData, object: nil)
//    }
//
//    fileprivate func addPermissionManagerObservers() {
//        _ = sdlManager.permissionManager.addObserver(forRPCs: ["SubscribeVehicleData"], groupType: .allAllowed) { (_, _) in
//        }
//    }
//
//    fileprivate func prepareRemoteSystem(overwrite: Bool = false, completionHandler: @escaping (Void) -> (Void)) {
//        let group = DispatchGroup()
//        group.enter()
//        group.notify(queue: .main) {
//            completionHandler()
//        }
//        // Send images
//        if !sdlManager.fileManager.remoteFileNames.contains(AppConstants.mainArtwork) {
//            let artwork = SDLArtwork(image: #imageLiteral(resourceName: "sdl_logo_green"), name: AppConstants.mainArtwork, persistent: true, as: .PNG)
//            group.enter()
//            sdlManager.fileManager.uploadFile(artwork, completionHandler: { (_, _, error) in
//                group.leave()
//                if let error = error {
//                    print("Error uploading default artwork \(artwork) with error \(error)")
//                }
//            })
//        }
//        if !sdlManager.fileManager.remoteFileNames.contains(AppConstants.PointingSoftButtonArtworkName) {
//            let buttonIconPoint = SDLArtwork(image: #imageLiteral(resourceName: "sdl_softbutton_icon"), name: AppConstants.PointingSoftButtonArtworkName, persistent: true, as: .PNG)
//            group.enter()
//            sdlManager.fileManager.uploadFile(buttonIconPoint, completionHandler: { (_, _, error) in
//                group.leave()
//                if let error = error {
//                    print("Error uploading default artwork \(buttonIconPoint) with error \(error)")
//                }
//            })
//        }
//        let choice = SDLChoice(id: 113, menuName: AppConstants.menuNameOnlyChoice, vrCommands: [AppConstants.menuNameOnlyChoice])!
//        let createRequest = SDLCreateInteractionChoiceSet(id: 113, choiceSet: [choice])!
//        group.enter()
//        sdlManager.send(createRequest) { (_, _, error) in
//            group.leave()
//            if let error = error {
//                print("Send Failed with error: \(error)")
//            }
//        }
//        group.leave()
//    }
//}
//// MARK: - RPCs
//extension ProxyManager {
//    // MARK: Show Requests
//    // Set Text
//    fileprivate func setText() {
//        let show = SDLShow(mainField1: AppConstants.sdl, mainField2: AppConstants.testApp, alignment: .centered())
//        send(request: show!)
//    }
//    // Set Display Layout
//    fileprivate func setDisplayLayout() {
//        let display = SDLSetDisplayLayout(predefinedLayout: .non_MEDIA())!
//        send(request: display)
//    }
//    // Show Main Image
//    fileprivate func showMainImage() {
//        let sdlImage = SDLImage(name: AppConstants.mainArtwork, of: .dynamic())
//        let show = SDLShow()!
//        show.graphic = sdlImage
//        send(request: show)
//    }
//    // MARK: Buttons
//    fileprivate func prepareButtons() {
//        let softButton = SDLSoftButton()!
//        softButton.softButtonID = 100
//        softButton.handler = {[unowned self] (notification) in
//            if let onButtonPress = notification as? SDLOnButtonPress {
//                if onButtonPress.buttonPressMode.isEqual(to: SDLButtonPressMode.short()) {
//                    // Create Alert
//                    let alert = SDLAlert()!
//                    alert.alertText1 = AppConstants.pushButtonText
//                    self.send(request: alert)
//                }
//            }
//        }
//        softButton.type = .both()
//        softButton.text = AppConstants.buttonText
//        softButton.image = SDLImage(name: AppConstants.PointingSoftButtonArtworkName, of: .dynamic())
//
//        let show = SDLShow()!
//        show.softButtons = [softButton]
//        send(request: show)
//    }
//    // MARK: Menu Items
//    fileprivate func addSpeakMenuCommand() {
//        let menuParameters = SDLMenuParams(menuName: AppConstants.speakAppNameText, parentId: 0, position: 0)!
//
//        let menuItem = SDLAddCommand(id: 111, vrCommands: [AppConstants.speakAppNameText]) {[unowned self] (notification) in
//            guard let onCommand = notification as? SDLOnCommand else {
//                return
//            }
//            if onCommand.triggerSource == .menu() {
//                self.send(request: self.appNameSpeak())
//            }
//            }!
//        menuItem.menuParams = menuParameters
//        send(request: menuItem)
//    }
//    // MARK: Perform Interaction Functions
//    fileprivate func addperformInteractionMenuCommand() {
//        let menuParameters = SDLMenuParams(menuName: AppConstants.performInteractionText, parentId: 0, position: 1)!
//
//        let menuItem = SDLAddCommand(id: 112, vrCommands: [AppConstants.performInteractionText]) {[unowned self] (notification) in
//            guard let onCommand = notification as? SDLOnCommand else {
//                return
//            }
//            if onCommand.triggerSource == .menu() {
//                self.createPerformInteraction()
//            }
//            }!
//        menuItem.menuParams = menuParameters
//        send(request: menuItem)
//    }
//
//    fileprivate func createPerformInteraction() {
//        let performInteraction = SDLPerformInteraction(initialPrompt: nil, initialText: AppConstants.menuNameOnlyChoice, interactionChoiceSetID: 113)!
//        performInteraction.interactionMode = .manual_ONLY()
//        performInteraction.interactionLayout = .list_ONLY()
//        performInteraction.initialPrompt = SDLTTSChunk.textChunks(from: AppConstants.chooseOneTTS)
//        performInteraction.initialText = AppConstants.initialTextInteraction
//        performInteraction.helpPrompt = SDLTTSChunk.textChunks(from: AppConstants.doItText)
//        performInteraction.timeoutPrompt = SDLTTSChunk.textChunks(from: AppConstants.tooLateText)
//        performInteraction.timeout = 5000 // 5 seconds
//        self.sdlManager.send(performInteraction) {[unowned self] (request, response, _) in
//            guard let performInteractionResponse = response as? SDLPerformInteractionResponse else {
//                return
//            }
//            // Wait for user's selection or for timeout
//            if performInteractionResponse.resultCode == .timed_OUT() {
//                self.send(request: self.youMissedItSpeak())
//            } else if performInteractionResponse.resultCode == .success() {
//                self.send(request: self.goodJobSpeak())
//            }
//        }
//    }
//    // MARK: Speak Functions
//    fileprivate func appNameSpeak() -> SDLSpeak {
//        let speak = SDLSpeak()
//        speak?.ttsChunks = SDLTTSChunk.textChunks(from: AppConstants.sdlTTS)
//        return speak!
//    }
//
//    fileprivate func goodJobSpeak() -> SDLSpeak {
//        let speak = SDLSpeak()
//        speak?.ttsChunks = SDLTTSChunk.textChunks(from: AppConstants.goodJobTTS)
//        return speak!
//    }
//
//    fileprivate func youMissedItSpeak() -> SDLSpeak {
//        let speak = SDLSpeak()
//        speak?.ttsChunks = SDLTTSChunk.textChunks(from: AppConstants.missedItTTS)
//        return speak!
//    }
//    // MARK: Vehicle Data
//    fileprivate func subscribeVehicleData() {
//        print("subscribeVehicleData")
//        if isVehicleDataSubscribed {
//            return
//        }
//        let subscribe = SDLSubscribeVehicleData()!
//
//        // Specify which items to subscribe to
//        subscribe.speed = true
//
//        sdlManager.send(subscribe) { (_, response, _) in
//            print("SubscribeVehicleData response from SDL: \(String(describing: response?.resultCode)) with info: \(String(describing: response?.info))")
//            if response?.resultCode == SDLResult.success() {
//                isVehicleDataSubscribed = true
//            }
//        }
//    }
//
//    @objc fileprivate func didReceiveVehicleData(_ notification: SDLRPCNotificationNotification) {
//        guard let onVehicleData = notification.notification as? SDLOnVehicleData else {
//            return
//        }
//        print("Speed: \(onVehicleData.speed)")
//    }
//}
