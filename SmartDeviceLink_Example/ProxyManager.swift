//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink
import SmartDeviceLinkSwift

class ProxyManager: NSObject {
    fileprivate var sdlManager: SDLManager!
    fileprivate var buttonManager: ButtonManager!
    fileprivate var vehicleDataManager: VehicleDataManager!
    fileprivate var firstHMILevelState: SDLHMILevelFirstState
    weak var delegate: ProxyManagerDelegate?

    // Singleton
    static let sharedManager = ProxyManager()
    private override init() {
        firstHMILevelState = .none
        super.init()
    }
}

// MARK: - SDL Configuration

extension ProxyManager {
    /// Configures the SDL Manager that handles data transfer beween this app and the car's head unit and starts searching for a connection to a head unit. There are two possible types of transport layers to use: TCP is used to connect wirelessly to SDL Core and is only available for debugging; iAP is used to connect to MFi (Made for iPhone) hardware and is must be used for production builds.
    ///
    /// - Parameter connectionType: The type of transport layer to use.
    func start(with connectionType: SDLConnectionType) {
        delegate?.didChangeProxyState(SDLProxyState.searching)
        sdlManager = SDLManager(configuration: connectionType == .iAP ? ProxyManager.connectIAP() : ProxyManager.connectTCP(), delegate: self)
        startManager()
    }

    /// Attempts to close the connection between the this app and the car's head unit. The `SDLManagerDelegate`'s `managerDidDisconnect()` is called when connection is actually closed.
    func resetConnection() {
        sdlManager.stop()
    }
}

// MARK: - SDL Configuration Helpers

private extension ProxyManager {
    /// Configures an iAP transport layer.
    ///
    /// - Returns: A SDLConfiguration object
    class func connectIAP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, appId: ExampleAppId)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    /// Configures a TCP transport layer with the IP address and port of the remote SDL Core instance.
    ///
    /// - Returns: A SDLConfiguration object
    class func connectTCP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, appId: ExampleAppId, ipAddress: AppUserDefaults.shared.ipAddress!, port: UInt16(AppUserDefaults.shared.port!)!)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    /// Helper method for setting additional configuration parameters for both TCP and iAP transport layers.
    ///
    /// - Parameter lifecycleConfiguration: The transport layer configuration
    /// - Returns: A SDLConfiguration object
    class func setupManagerConfiguration(with lifecycleConfiguration: SDLLifecycleConfiguration) -> SDLConfiguration {
        lifecycleConfiguration.shortAppName = ExampleAppNameShort
        let appIcon = UIImage(named: ExampleAppLogoName)
        lifecycleConfiguration.appIcon = appIcon != nil ? SDLArtwork(image: appIcon!, persistent: true, as: .PNG) : nil
        lifecycleConfiguration.appType = .media
        lifecycleConfiguration.language = .enUs
        lifecycleConfiguration.languagesSupported = [.enUs, .esMx, .frCa]

        let lockScreenConfiguration = appIcon != nil ? SDLLockScreenConfiguration.enabledConfiguration(withAppIcon: appIcon!, backgroundColor: nil) : SDLLockScreenConfiguration.enabled()
        return SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: lockScreenConfiguration, logging: logConfiguration())
    }

    /// Sets the type of SDL debug logs that are visible and where to port the logs. There are 4 levels of logs, verbose, debug, warning and error, which verbose printing all SDL logs and error printing only the error logs. Adding SDLLogTargetFile to the targest will log to a text file on the iOS device. This file can be accessed via: iTunes > Your Device Name > File Sharing > Your App Name. Make sure `UIFileSharingEnabled` has been added to the application's info.plist and is set to `true`.
    ///
    /// - Returns: A SDLLogConfiguration object
    class func logConfiguration() -> SDLLogConfiguration {
        let logConfig = SDLLogConfiguration.default()
        let exampleLogFileModule = SDLLogFileModule(name: "SDL Example", files: ["ProxyManager"])
        logConfig.modules.insert(exampleLogFileModule)
        _ = logConfig.targets.insert(SDLLogTargetFile()) // Logs to file
        logConfig.globalLogLevel = .verbose // Filters the logs
        return logConfig
    }

    /// Searches for a connection to a SDL enabled accessory. When a connection has been established, the ready handler is called. Even though the app is connected to SDL Core, it does not mean that RPCs can be immediately sent to the accessory as there is no guarentee that SDL Core is ready to receive RPCs. Monitor the `SDLManagerDelegate`'s `hmiLevel(_:didChangeToLevel:)` to determine when to send RPCs.
    func startManager() {
        sdlManager.start(readyHandler: { [unowned self] (success, error) in
            guard success else {
                SDLLog.d("something")
                print("There was an error while starting up: \(String(describing: error))")
                self.resetConnection()
                return
            }

            // A connection has been established between the app and a SDL enabled accessory
            self.delegate?.didChangeProxyState(SDLProxyState.connected)

            // Do some setup
            self.buttonManager = ButtonManager(sdlManager: self.sdlManager, updateScreenHandler: self.refreshUIHandler)
            self.vehicleDataManager = VehicleDataManager(sdlManager: self.sdlManager, refreshUIHandler: self.refreshUIHandler)
            RPCPermissionsManager.setupPermissionsCallbacks(with: self.sdlManager)

            print("SDL file manager storage: \(self.sdlManager.fileManager.bytesAvailable / 1024 / 1024) mb")
        })
    }
}

// MARK: - SDLManagerDelegate

extension ProxyManager: SDLManagerDelegate {
    /// Called when the connection beween this app and SDL Core has closed.
    func managerDidDisconnect() {
        delegate?.didChangeProxyState(SDLProxyState.stopped)
        firstHMILevelState = .none
        buttonManager.reset()
        vehicleDataManager.reset()

        // If desired, automatically start searching for a new connection to Core
        if ExampleAppShouldRestartSDLManagerOnDisconnect.boolValue {
            startManager()
        }
    }

    /// Called when the state of the SDL app has changed. The state limits the type of RPC that can be sent. Refer to the class documentation for each RPC to determine what state(s) the RPC can be sent.
    ///
    /// - Parameters:
    ///   - oldLevel: The old SDL HMI Level
    ///   - newLevel: The new SDL HMI Level
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if newLevel != .none && firstHMILevelState == .none {
            // This is our first time in a non-NONE state
            firstHMILevelState = .nonNone

            // Send static menu items. Menu related RPCs can be sent at all `hmiLevel`s except `NONE`
            createStaticMenus()
            vehicleDataManager.subscribeToVehicleOdometer()
        }

        if newLevel == .full && firstHMILevelState != .full {
            // This is our first time in a `FULL` state.
            firstHMILevelState = .full
        }

        switch newLevel {
        case .full:                // The SDL app is in the foreground
            // Always try to show the initial state to guard against some possible weird states. Duplicates will be ignored by Core.
            showInitialData()
        case .limited: break        // The SDL app's menu is open
        case .background: break     // The SDL app is not in the foreground
        case .none: break           // The SDL app is not yet running
        default: break
        }
    }

    /// Called when the audio state of the SDL app has changed. The audio state only needs to be monitored if the app is streaming audio.
    ///
    /// - Parameters:
    ///   - oldState: The old SDL audio streaming state
    ///   - newState: The new SDL audio streaming state
    func audioStreamingState(_ oldState: SDLAudioStreamingState?, didChangeToState newState: SDLAudioStreamingState) {
        switch newState {
        case .audible: break        // The SDL app's audio can be heard
        case .notAudible: break     // The SDL app's audio cannot be heard
        case .attenuated: break     // The SDL app's audio volume has been lowered to let the system speak over the audio. This usually happens with voice recognition commands.
        default: break
        }
    }

    /// Called when the car's head unit language is different from the default langage set in the SDLConfiguration AND the head unit language is supported by the app (as set in `languagesSupported` of SDLConfiguration). This method is only called when a connection to Core is first established. If desired, you can update the app's name and text-to-speech name to reflect the head unit's language.
    ///
    /// - Parameter language: The head unit's current language
    /// - Returns: A SDLLifecycleConfigurationUpdate object
    func managerShouldUpdateLifecycle(toLanguage language: SDLLanguage) -> SDLLifecycleConfigurationUpdate? {
        var appName = ""
        switch language {
        case .enUs:
            appName = ExampleAppName
        case .esMx:
            appName = ExampleAppNameSpanish
        case .frCa:
            appName = ExampleAppNameFrench
        default:
            return nil
        }

        return SDLLifecycleConfigurationUpdate(appName: appName, shortAppName: nil, ttsName: [SDLTTSChunk(text: appName, type: .text)], voiceRecognitionCommandNames: nil)
    }
}

// MARK: - SDL UI

private extension ProxyManager {
    /// Handler for refreshing the UI
    var refreshUIHandler: refreshUIHandler? {
        return { [unowned self] () in
            self.updateScreen()
        }
    }

    /// Set the template and create the UI
    func showInitialData() {
        let mediaTemplate = SDLSetDisplayLayout(predefinedLayout: .media)
        if sdlManager.registerResponse?.displayCapabilities?.templatesAvailable?.contains(mediaTemplate.displayLayout) ?? false {
            sdlManager.send(request: mediaTemplate, responseHandler: nil)
        }

        updateScreen()
        sdlManager.screenManager.softButtonObjects = buttonManager.allScreenSoftButtons(with: sdlManager)
    }

    /// Update the UI's textfields, images and soft buttons
    func updateScreen() {
        guard sdlManager.hmiLevel == .full else { return }
        let screenManager = sdlManager.screenManager
        let isTextVisible = buttonManager.textEnabled
        let areImagesVisible = buttonManager.imagesEnabled

        screenManager.beginUpdates()
        screenManager.textAlignment = .left
        screenManager.textField1 = isTextVisible ? SmartDeviceLinkText : nil
        screenManager.textField2 = isTextVisible ? "Swift \(ExampleAppText)" : nil
        screenManager.textField3 = isTextVisible ? vehicleDataManager.vehicleOdometerData : nil
        screenManager.primaryGraphic = areImagesVisible ? SDLArtwork(image: UIImage(named: ExampleAppLogoName)!, persistent: false, as: .PNG) : nil
        screenManager.endUpdates(completionHandler: { (error) in
            print("Updated text and graphics. Error? \(String(describing: error))")
        })
    }

    /// Send static menu data
    func createStaticMenus() {
        sdlManager.send(MenuManager.allAddCommands(with: sdlManager) + [MenuManager.createInteractionChoiceSet()], progressHandler: { (request, response, error, percentComplete) in
            print("\(request), was sent \(response?.resultCode == .success ? "successfully" : "unsuccessfully"), error: \(error != nil ? error!.localizedDescription : "no error")")
        }, completionHandler: { (success) in
            print("All prepare remote system requests sent \(success ? "successfully" : "unsuccessfully")")
        })
    }
}
