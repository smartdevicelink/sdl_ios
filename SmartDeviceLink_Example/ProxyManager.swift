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
    fileprivate var buttonManager: ButtonManager?
    fileprivate var firstHMILevelState: SDLHMILevelFirstState
    fileprivate var isVehicleDataSubscribed: Bool
    weak var delegate: ProxyManagerDelegate?

    // Singleton
    static let sharedManager = ProxyManager()
    private override init() {
        firstHMILevelState = .none
        isVehicleDataSubscribed = false
        super.init()
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
        buttonManager = nil
    }
}

// MARK: - SDL Init

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
        logConfig.globalLogLevel = .debug
        return logConfig
    }

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
            self.buttonManager = ButtonManager(sdlManager: manager, updateScreenHandler: self.updateScreenHandler)
            self.setupPermissionsCallbacks()

            print("SDL file manager storage: \(self.sdlManager!.fileManager.bytesAvailable / 1024 / 1024) mb")
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
            prepareRemoteSystem(sdlManager!)
        }

        if newLevel == .full && firstHMILevelState != .full {
            // This is our first time in a FULL state
            firstHMILevelState = .full

            // manticoreTest()
        }

        if newLevel == .full {
            // We're always going to try to show the initial state to guard against some possible weird states
            showInitialData()
        }
    }

    func manticoreTest() {
        print("Waiting 10 seconds to send the CICS")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10.0) {
            print("Sending the CICS")
            self.sdlManager?.send(MenuManager.createChoiceSets(), progressHandler: { (request, response, error, progress) in
                print("Create Interaction Choice Set RPC sent, Response: \(response?.resultCode == .success ? "successful" : "not successful"), Percent Complete: \(progress), Error: \(String(describing: error?.localizedDescription))")
            }, completionHandler: { (success) in
                print("All Create Interaction Choice Set RPCs send successfully: \(success ? "YES" : "NO")")
            })
        }
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

// MARK: - SDL UI

private extension ProxyManager {
    var updateScreenHandler: updateScreenHandler? {
        return { [weak self] () in
            self?.updateScreen()
        }
    }

    func showInitialData() {
        let template = SDLSetDisplayLayout(predefinedLayout: .nonMedia)
        sdlManager?.send(request: template, responseHandler: { [weak self] (_, response, _) in
            guard response?.resultCode == .success else { return }
        })

        updateScreen()
        sdlManager?.screenManager.softButtonObjects = buttonManager!.screenSoftButtons(with: sdlManager!)
    }

    func updateScreen() {
        guard let screenManager = sdlManager?.screenManager, sdlManager?.hmiLevel == .full, let textEnabled = buttonManager?.textEnabled, let imagesEnabled = buttonManager?.imagesEnabled else { return }
        screenManager.beginUpdates()
        screenManager.textAlignment = .left
        screenManager.textField1 = textEnabled ? SmartDeviceLinkText : nil
        screenManager.textField2 = textEnabled ? "Swift \(ExampleAppText)" : nil
        screenManager.primaryGraphic = imagesEnabled ? SDLArtwork(image: UIImage(named: ExampleAppLogoName)!, persistent: false, as: .PNG) : nil
        screenManager.endUpdates(completionHandler: { (error) in
            print("Updated text and graphics. Error? \(String(describing: error))")
        })
    }
}

// MARK: - SDL Remote Setup

private extension ProxyManager {
    func setupPermissionsCallbacks() {
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

    func prepareRemoteSystem(_ manager: SDLManager) {
        sdlManager?.send(MenuManager.allAddCommands(with: manager) + [MenuManager.createInteractionChoiceSet()], progressHandler: { (request, response, error, percentComplete) in
            print("\(request), was sent \(response?.resultCode == .success ? "successfully" : "unsuccessfully"), error: \(error != nil ? error!.localizedDescription : "no error")")
        }, completionHandler: { (success) in
            print("All prepare remote system requests sent \(success ? "successfully" : "unsuccessfully")")
        })
    }
}
