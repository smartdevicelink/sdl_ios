//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink

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
    func start(with connectionType: SDLConnectionType) {
        delegate?.didChangeProxyState(SDLProxyState.searching)
        sdlManager = SDLManager(configuration: connectionType == .iAP ? ProxyManager.connectIAP() : ProxyManager.connectTCP(), delegate: self)

        guard let sdlManager = sdlManager else {
            resetConnection()
            return
        }
        startManager(sdlManager)
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
    class func connectIAP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, appId: ExampleAppId)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    class func connectTCP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, appId: ExampleAppId, ipAddress: AppUserDefaults.shared.ipAddress!, port: UInt16(AppUserDefaults.shared.port!)!)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    class func setupManagerConfiguration(with lifecycleConfiguration: SDLLifecycleConfiguration) -> SDLConfiguration {
        let appIcon = UIImage(named: ExampleAppLogoName)

        lifecycleConfiguration.shortAppName = ExampleAppNameShort
        lifecycleConfiguration.appIcon = appIcon != nil ? SDLArtwork(image: appIcon!, persistent: true, as: .PNG) : nil
        lifecycleConfiguration.appType = .media

        let lockScreenConfiguration = appIcon != nil ? SDLLockScreenConfiguration.enabledConfiguration(withAppIcon: appIcon!, backgroundColor: nil) : SDLLockScreenConfiguration.enabled()
        return SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: lockScreenConfiguration, logging: logConfiguration())
    }

    class func logConfiguration() -> SDLLogConfiguration {
        let logConfig = SDLLogConfiguration.debug()
        logConfig.globalLogLevel = .verbose
        return logConfig
    }

    /// Start searching for a connection with SDL Core
    ///
    /// - Parameter manager: The SDL Manager
    func startManager(_ manager: SDLManager) {
        manager.start(readyHandler: { [unowned self] (success, error) in
            guard success else {
                print("There was an error while starting up: \(String(describing: error))")
                self.resetConnection()
                return
            }

            // A connection has been established between the app and a SDL enabled accessory
            self.delegate?.didChangeProxyState(SDLProxyState.connected)

            // Do some setup
            // self.sdlex_setupPermissionsCallbacks()
            print("SDL file manager storage: \(self.sdlManager!.fileManager.bytesAvailable / 1024 / 1024) mb")

            if manager.hmiLevel == .full {
                // TODO: showInitialData
            }
        })
    }
}

// MARK: - SDLManagerDelegate

extension ProxyManager: SDLManagerDelegate {
    func managerDidDisconnect() {
        delegate?.didChangeProxyState(SDLProxyState.stopped)
    }

    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if newLevel != .none && firstHMILevelState == .none {
            // This is our first time in a non-NONE state
            firstHMILevelState = .nonNone

            // Send AddCommands
            // TODO
        }

        if newLevel == .full && firstHMILevelState != .full {
            // This is our first time in a FULL state
            firstHMILevelState = .full

            print("Waiting 20 seconds to send the CICS")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 20.0) {
                print("Sending the CICS")
                self.sdlManager?.send(self.createChoiceSets(), progressHandler: { (request, response, error, progress) in
                    print("Create Interaction Choice Set RPC sent, Response: \(response?.resultCode == .success ? "successful" : "not successful"), Percent Complete: \(progress), Error: \(String(describing: error?.localizedDescription))")
                }, completionHandler: { (success) in
                    print("All Create Interaction Choice Set RPCs send successfully: \(success ? "YES" : "NO")")
                })
            }
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
        // The audio state only needs to be monitored if the app is streaming audio
        switch newState {
        case .audible: break        // The SDL app's audio can be heard
        case .notAudible: break     // The SDL app's audio cannot be heard
        case .attenuated: break     // The SDL app's audio volume has been lowered to let the system speak over the audio. This usually happens with voice recognition commands.
        default: break
        }
    }

    func managerShouldUpdateLifecycle(toLanguage language: SDLLanguage) -> SDLLifecycleConfigurationUpdate? {
        var appName = ""

        switch language {
        case .enUs:
            appName = ExampleAppName
        case .esMx:
            appName = ExampleAppName
        case .frCa:
            appName = ExampleAppName
        default:
            return nil
        }

        return SDLLifecycleConfigurationUpdate(appName: appName, shortAppName: nil, ttsName: [SDLTTSChunk(text: appName, type: .text)], voiceRecognitionCommandNames: nil)
    }
}

// Mark - CICS
private extension ProxyManager {
    func createChoiceSets() -> [SDLCreateInteractionChoiceSet] {
        var interactionChoiceSet = [SDLCreateInteractionChoiceSet]()

        var choiceId = 1
        for _ in 0..<20 {
            var choiceSet = [SDLChoice]()
            for j in 0..<5 {
                let menuName = "Choice \(choiceId)"
                choiceSet.append(SDLChoice(id: UInt16(choiceId), menuName: menuName, vrCommands: [menuName], image: nil, secondaryText: nil, secondaryImage: nil, tertiaryText: nil))
                choiceId += 1
            }
            interactionChoiceSet.append(SDLCreateInteractionChoiceSet(id: UInt32(choiceId), choiceSet: choiceSet))
            choiceId += 1
        }

        return interactionChoiceSet
    }
}

// MARK: - Helpers

private extension ProxyManager {
    func sdlex_setupPermissionsCallbacks() {
        // Gets the current permissions for a single RPC
        let isShowRPCAvailable = sdlManager?.permissionManager.isRPCAllowed("Show")
        print("Show RPC allowed? \(String(describing: isShowRPCAvailable))")

        // Get the current permissions of a group of RPCs
        let rpcGroup = ["AddCommand", "PerformInteraction"]
        let commandPICSStatus = sdlManager?.permissionManager.groupStatus(ofRPCs: rpcGroup)
        let commandPICSStatusDict = sdlManager?.permissionManager.status(ofRPCs: rpcGroup)
        print("The group status for \(rpcGroup) is: \(String(describing: commandPICSStatus)). The status for each RPC in the group is: \(String(describing: commandPICSStatusDict))")

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to `SDLPermissionGroupTypeAllAllowed`, this block is called when the group permissions changes from all allowed to all not allowed. This block is called immediately when created.
        let observedRPCGroup = ["Show", "Alert"]
        let permissionAllAllowedObserverId = self.sdlManager?.permissionManager.addObserver(forRPCs: observedRPCGroup, groupType: .allAllowed, withHandler: { (individualStatuses, groupStatus) in
            print("The group status for \(observedRPCGroup) has changed to: \(groupStatus)")
            for (rpcName, rpcAllowed) in individualStatuses {
                print("\(rpcName as String) allowed? \(rpcAllowed.boolValue ? "yes" : "no")")
            }
        })

        // To stop observing permissions changes for a group of RPCs, remove the observer.
        sdlManager?.permissionManager.removeObserver(forIdentifier: permissionAllAllowedObserverId!)

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to `SDLPermissionGroupTypeAllAny`, this block is called when the permission status changes for any of the RPCs being observed. This block is called immediately when created.
        let _ = sdlManager?.permissionManager.addObserver(forRPCs: observedRPCGroup, groupType: .any, withHandler: { (individualStatuses, groupStatus) in
            print("The group status for \(observedRPCGroup) has changed to: \(groupStatus)")
            for (rpcName, rpcAllowed) in individualStatuses {
                print("\(rpcName as String) allowed? \(rpcAllowed.boolValue ? "yes" : "no")")
            }
        })

        // To stop observing permissions changes for a group of RPCs, remove the observer.
        // sdlManager?.permissionManager.removeObserver(forIdentifier: permissionAnyObserverId!)
    }

    func sdlex_showInitialData() {
        guard sdlManager?.hmiLevel == .full else { return }

//        let template = SDLSetDisplayLayout(predefinedLayout: .nonMedia)
//        self.sdlManager?.send(request: template, responseHandler: { (_, response, error) in
//            <#code#>
//        })
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
