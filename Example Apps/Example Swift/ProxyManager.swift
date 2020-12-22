//
//  ProxyManager.swift
//  SmartDeviceLink-ExampleSwift
//
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink
import SmartDeviceLinkSwift

enum ProxyTransportType {
    case tcp
    case iap
}

enum ProxyState {
    case stopped
    case searching
    case connected
}

class ProxyManager: NSObject {
    private var sdlManager: SDLManager!
    private var buttonManager: ButtonManager!
    private var subscribeButtonManager: SubscribeButtonManager!
    private var vehicleDataManager: VehicleDataManager!
    private var performInteractionManager: PerformInteractionManager!
    private var firstHMILevelState: SDLHMILevel
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
    func start(with proxyTransportType: ProxyTransportType) {
        delegate?.didChangeProxyState(ProxyState.searching)
        sdlManager = SDLManager(configuration: proxyTransportType == .iap ? ProxyManager.connectIAP() : ProxyManager.connectTCP(), delegate: self)
        startManager()
    }

    /// Attempts to close the connection between the this app and the car's head unit. The `SDLManagerDelegate`'s `managerDidDisconnect()` is called when connection is actually closed.
    func stopConnection() {
        guard sdlManager != nil else {
            delegate?.didChangeProxyState(.stopped)
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.sdlManager.stop()
        }

        delegate?.didChangeProxyState(.stopped)
    }
}

// MARK: - SDL Configuration Helpers

private extension ProxyManager {
    /// Configures an iAP transport layer.
    ///
    /// - Returns: A SDLConfiguration object
    class func connectIAP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, fullAppId: ExampleFullAppId)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    /// Configures a TCP transport layer with the IP address and port of the remote SDL Core instance.
    ///
    /// - Returns: A SDLConfiguration object
    class func connectTCP() -> SDLConfiguration {
        let lifecycleConfiguration = SDLLifecycleConfiguration(appName: ExampleAppName, fullAppId: ExampleFullAppId, ipAddress: AppUserDefaults.shared.ipAddress!, port: UInt16(AppUserDefaults.shared.port!)!)
        return setupManagerConfiguration(with: lifecycleConfiguration)
    }

    /// Helper method for setting additional configuration parameters for both TCP and iAP transport layers.
    ///
    /// - Parameter lifecycleConfiguration: The transport layer configuration
    /// - Returns: A SDLConfiguration object
    class func setupManagerConfiguration(with lifecycleConfiguration: SDLLifecycleConfiguration) -> SDLConfiguration {
        lifecycleConfiguration.shortAppName = ExampleAppNameShort
        let appIcon = UIImage(named: ExampleAppLogoName)?.withRenderingMode(.alwaysOriginal)
        lifecycleConfiguration.appIcon = appIcon != nil ? SDLArtwork(image: appIcon!, persistent: true, as: .PNG) : nil
        lifecycleConfiguration.appType = .default
        lifecycleConfiguration.language = .enUs
        lifecycleConfiguration.languagesSupported = [.enUs, .esMx, .frCa]
        lifecycleConfiguration.ttsName = [SDLTTSChunk(text: "S D L", type: .text)]

        let green = SDLRGBColor(red: 126, green: 188, blue: 121)
        let white = SDLRGBColor(red: 249, green: 251, blue: 254)
        let grey = SDLRGBColor(red: 186, green: 198, blue: 210)
        let darkGrey = SDLRGBColor(red: 57, green: 78, blue: 96)
        lifecycleConfiguration.dayColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: white)
        lifecycleConfiguration.nightColorScheme = SDLTemplateColorScheme(primaryRGBColor: green, secondaryRGBColor: grey, backgroundRGBColor: darkGrey)

        let lockScreenConfiguration = appIcon != nil ? SDLLockScreenConfiguration.enabledConfiguration(withAppIcon: appIcon!, backgroundColor: nil) : SDLLockScreenConfiguration.enabled()
        return SDLConfiguration(lifecycle: lifecycleConfiguration, lockScreen: lockScreenConfiguration, logging: logConfiguration(), fileManager: .default(), encryption: .default())
    }

    /// Sets the type of SDL debug logs that are visible and where to port the logs. There are 4 levels of log filtering, verbose, debug, warning and error. Verbose prints all SDL logs; error prints only the error logs. Adding SDLLogTargetFile to the targest will log to a text file on the iOS device. This file can be accessed via: iTunes > Your Device Name > File Sharing > Your App Name. Make sure `UIFileSharingEnabled` has been added to the application's info.plist and is set to `true`.
    ///
    /// - Returns: A SDLLogConfiguration object
    class func logConfiguration() -> SDLLogConfiguration {
        let logConfig = SDLLogConfiguration.default()
        let exampleLogFileModule = SDLLogFileModule(name: "SDL Swift Example App", files: ["ProxyManager", "AlertManager", "AudioManager", "ButtonManager", "SubscribeButtonManager", "MenuManager", "PerformInteractionManager", "RPCPermissionsManager", "VehicleDataManager"])
        logConfig.modules.insert(exampleLogFileModule)
        _ = logConfig.targets.insert(SDLLogTargetFile()) // Logs to file
        logConfig.globalLogLevel = .debug // Filters the logs
        return logConfig
    }

    /// Searches for a connection to a SDL enabled accessory. When a connection has been established, the ready handler is called. Even though the app is connected to SDL Core, it does not mean that RPCs can be immediately sent to the accessory as there is no guarentee that SDL Core is ready to receive RPCs. Monitor the `SDLManagerDelegate`'s `hmiLevel:didChangeToLevel:` to determine when to send RPCs.
    func startManager() {
        sdlManager.start(readyHandler: { [unowned self] (success, error) in
            guard success else {
                SDLLog.e("There was an error while starting up: \(String(describing: error))")
                self.stopConnection()
                return
            }

            self.delegate?.didChangeProxyState(ProxyState.connected)

            self.buttonManager = ButtonManager(sdlManager: self.sdlManager, updateScreenHandler: self.refreshUIHandler)
            self.subscribeButtonManager = SubscribeButtonManager(sdlManager: self.sdlManager)
            self.vehicleDataManager = VehicleDataManager(sdlManager: self.sdlManager, refreshUIHandler: self.refreshUIHandler)
            self.performInteractionManager = PerformInteractionManager(sdlManager: self.sdlManager)

            RPCPermissionsManager.setupPermissionsCallbacks(with: self.sdlManager)

            SDLLog.d("SDL file manager storage: \(self.sdlManager.fileManager.bytesAvailable / 1024 / 1024) mb")
        })
    }
}

// MARK: - SDLManagerDelegate

extension ProxyManager: SDLManagerDelegate {
    /// Called when the connection beween this app and the module has closed.
    func managerDidDisconnect() {        
        if delegate?.proxyState != .some(.stopped) {
            delegate?.didChangeProxyState(ProxyState.searching)
        }
        
        firstHMILevelState = .none
    }

    /// Called when the state of the SDL app has changed. The state limits the type of RPC that can be sent. Refer to the class documentation for each RPC to determine what state(s) the RPC can be sent.
    ///
    /// - Parameters:
    ///   - oldLevel: The old HMI Level
    ///   - newLevel: The new HMI Level
    func hmiLevel(_ oldLevel: SDLHMILevel, didChangeToLevel newLevel: SDLHMILevel) {
        if newLevel != .none && firstHMILevelState == .none {
            // This is our first time in a non-NONE state
            firstHMILevelState = newLevel

            // Send static menu items.
            createMenuAndGlobalVoiceCommands()

            // Subscribe to vehicle data.
            vehicleDataManager.subscribeToVehicleOdometer()
        }

        switch newLevel {
        case .full:
            // The SDL app is in the foreground. Always try to show the initial state to guard against some possible weird states. Duplicates will be ignored by Core.
            showInitialData()
            subscribeButtonManager.subscribeToPresetButtons()
        case .limited: break // An active NAV or MEDIA SDL app is in the background
        case .background: break // The SDL app is not in the foreground
        case .none: break // The SDL app is not yet running
        default: break
        }
    }

    /// Called when the SDL app's HMI context changes.
    /// - Parameters:
    ///   - oldContext: The old HMI context
    ///   - newContext: The new HMI context
    func systemContext(_ oldContext: SDLSystemContext?, didChangeToContext newContext: SDLSystemContext) {
        switch newContext {
        case SDLSystemContext.alert: break // The SDL app's screen is obscured by an alert
        case SDLSystemContext.hmiObscured: break // The SDL app's screen is obscured
        case SDLSystemContext.main: break // The SDL app's main screen is open
        case SDLSystemContext.menu: break // The SDL app's menu is open
        case SDLSystemContext.voiceRecognitionSession: break // A voice recognition session is in progress
        default: break
        }
    }

    /// Called when the audio state of the SDL app has changed. The audio state only needs to be monitored if the app is streaming audio.
    ///
    /// - Parameters:
    ///   - oldState: The old audio streaming state
    ///   - newState: The new audio streaming state
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
    /// - Parameter language: The head unit's current VR+TTS language
    /// - Parameter hmiLanguage: The head unit's current HMI language
    /// - Returns: A SDLLifecycleConfigurationUpdate object
    func managerShouldUpdateLifecycle(toLanguage language: SDLLanguage, hmiLanguage: SDLLanguage) -> SDLLifecycleConfigurationUpdate? {
        let update = SDLLifecycleConfigurationUpdate()
        switch hmiLanguage {
        case .enUs:
            update.appName = ExampleAppName
        case .esMx:
            update.appName = ExampleAppNameSpanish
        case .frCa:
            update.appName = ExampleAppNameFrench
        default:
            return nil
        }
        
        update.ttsName = [SDLTTSChunk(text: update.appName!, type: .text)]
        
        return update
    }
}

// MARK: - SDL UI

private extension ProxyManager {
    /// Handler for refreshing the UI
    var refreshUIHandler: RefreshUIHandler? {
        return { [unowned self] () in
            self.updateScreen()
        }
    }

    /// Set the template and create the UI
    func showInitialData() {
        guard sdlManager.hmiLevel == .full else { return }
        
        let setDisplayLayout = SDLSetDisplayLayout(predefinedLayout: .nonMedia)
        sdlManager.send(setDisplayLayout)

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
        screenManager.title = isTextVisible ? "Home" : nil
        screenManager.textField1 = isTextVisible ? SmartDeviceLinkText : nil
        screenManager.textField2 = isTextVisible ? "Swift \(ExampleAppText)" : nil
        screenManager.textField3 = isTextVisible ? vehicleDataManager.vehicleOdometerData : nil

        // Primary graphic
        if imageFieldSupported(imageFieldName: .graphic) {
            screenManager.primaryGraphic = areImagesVisible ? SDLArtwork(image: UIImage(named: ExampleAppLogoName)!.withRenderingMode(.alwaysOriginal), persistent: false, as: .PNG) : nil
        }
        
        // Secondary graphic
        if imageFieldSupported(imageFieldName: .secondaryGraphic) {
            screenManager.secondaryGraphic = areImagesVisible ? SDLArtwork(image: UIImage(named: CarBWIconImageName)!, persistent: false, as: .PNG) : nil
        }
        
        screenManager.endUpdates(completionHandler: { (error) in
            guard error != nil else { return }
            SDLLog.e("Textfields, graphics and soft buttons failed to update: \(error!.localizedDescription)")
        })
    }

    /// Send static menu data
    func createMenuAndGlobalVoiceCommands() {
        // Send the root menu items
        let screenManager = sdlManager.screenManager
        let menuItems = MenuManager.allMenuItems(with: sdlManager, choiceSetManager: performInteractionManager)
        let voiceMenuItems = MenuManager.allVoiceMenuItems(with: sdlManager)

        if !menuItems.isEmpty { screenManager.menu = menuItems }
        if !voiceMenuItems.isEmpty { screenManager.voiceCommands = voiceMenuItems }
    }

    /// Checks if SDL Core's HMI current template supports the template image field (i.e. primary graphic, secondary graphic, etc.)
    ///
    /// - Parameter imageFieldName: The name for the image field
    /// - Returns:                  True if the image field is supported, false if not
    func imageFieldSupported(imageFieldName: SDLImageFieldName) -> Bool {
        return sdlManager.systemCapabilityManager.defaultMainWindowCapability?.imageFields?.first { $0.name == imageFieldName } != nil ? true : false
    }
}
