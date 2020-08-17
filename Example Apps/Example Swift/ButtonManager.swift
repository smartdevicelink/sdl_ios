//
//  ButtonManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

typealias RefreshUIHandler = (() -> Void)

class ButtonManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var refreshUIHandler: RefreshUIHandler?
    
    /// Textfields are visible if true; hidden if false
    public fileprivate(set) var textEnabled: Bool {
        didSet {
            guard let refreshUIHandler = refreshUIHandler else { return }
            refreshUIHandler()
        }
    }

    /// UI images are visible if true; hidden if false
    public fileprivate(set) var imagesEnabled: Bool {
        didSet {
            guard let refreshUIHandler = refreshUIHandler else { return }
            refreshUIHandler()
        }
    }

    private var isSubtleAlertAllowed: Bool {
        return self.sdlManager.permissionManager.isRPCNameAllowed(SDLRPCFunctionName.subtleAlert)
    }

    private var isAlertAllowed: Bool {
        return self.sdlManager.permissionManager.isRPCNameAllowed(SDLRPCFunctionName.alert)
    }

    init(sdlManager: SDLManager, updateScreenHandler: RefreshUIHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshUIHandler = updateScreenHandler
        textEnabled = true
        imagesEnabled = true
    }

    /// An array of all the soft buttons
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of all soft buttons for the UI
    func allScreenSoftButtons() -> [SDLSoftButtonObject] {
        return [softButtonAlert, softButtonSubtleAlert, softButtonTextVisible, softButtonImagesVisible]
    }
}

// MARK: - Custom Soft Buttons

extension ButtonManager {
    /// Returns a soft button that shows an alert when tapped.
    private var softButtonAlert: SDLSoftButtonObject {
        let imageAndTextState = SDLSoftButtonState(stateName: AlertSoftButtonImageAndTextState, text: AlertSoftButtonText, image: UIImage(named: AlertBWIconName)?.withRenderingMode(.alwaysTemplate))
        let textState = SDLSoftButtonState(stateName: AlertSoftButtonTextState, text: AlertSoftButtonText, image: nil)
        return SDLSoftButtonObject(name: AlertSoftButton, states: [imageAndTextState, textState], initialStateName: imageAndTextState.name) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, buttonPress != nil else { return }

            if (self.isAlertAllowed) {
                AlertManager.sendAlert(imageName: CarBWIconImageName, textField1: AlertMessageText, sdlManager: self.sdlManager)
            } else if (self.isSubtleAlertAllowed) {
                AlertManager.sendSubtleAlert(imageName: CarBWIconImageName, textField1: AlertMessageText, sdlManager: self.sdlManager)
            } else {
                SDLLog.w("The module does not support the Alert request or the Subtle Alert request")
            }
        }
    }

    /// Returns a soft button that shows a subtle alert when tapped. If the subtle alert is not supported, then a regular alert is shown.
    private var softButtonSubtleAlert: SDLSoftButtonObject {
        let imageAndTextState = SDLSoftButtonState(stateName: SubtleAlertSoftButtonImageAndTextState, text: SubtleAlertSoftButtonText, image: UIImage(named: BatteryFullBWIconName)?.withRenderingMode(.alwaysTemplate))
        let textState = SDLSoftButtonState(stateName: SubtleAlertSoftButtonTextState, text: SubtleAlertSoftButtonText, image: nil)
        return SDLSoftButtonObject(name: SubtleAlertSoftButton, states: [imageAndTextState, textState], initialStateName: imageAndTextState.name) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, buttonPress != nil else { return }

            if (self.isSubtleAlertAllowed) {
                AlertManager.sendSubtleAlert(imageName: BatteryEmptyBWIconName, textField1: SubtleAlertHeaderText, textField2: SubtleAlertSubheaderText, sdlManager: self.sdlManager)
            } else if (self.isAlertAllowed) {
                AlertManager.sendAlert(imageName: BatteryEmptyBWIconName, textField1: SubtleAlertHeaderText, textField2: SubtleAlertSubheaderText, sdlManager: self.sdlManager)
            } else {
                SDLLog.w("The module does not support the Alert request or the Subtle Alert request")
            }
        }
    }

    /// Returns a soft button that toggles the textfield visibility state.
    private var softButtonTextVisible: SDLSoftButtonObject {
        let textVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOnState, text: TextVisibleSoftButtonTextOnText, artwork: nil)
        let textNotVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOffState, text: TextVisibleSoftButtonTextOffText, image: nil)
        return SDLSoftButtonObject(name: TextVisibleSoftButton, states: [textVisibleState, textNotVisibleState], initialStateName: textVisibleState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.textEnabled = !self.textEnabled

            // Update the button state
            let softButton = self.sdlManager.screenManager.softButtonObjectNamed(TextVisibleSoftButton)
            softButton?.transitionToNextState()
        }
    }

    /// Returns a soft button that toggles the image visibility state.
    private var softButtonImagesVisible: SDLSoftButtonObject {
        let imagesVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOnState, text: ImagesVisibleSoftButtonImageOnText, image: nil)
        let imagesNotVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOffState, text: ImagesVisibleSoftButtonImageOffText, image: nil)
        return SDLSoftButtonObject(name: ImagesVisibleSoftButton, states: [imagesVisibleState, imagesNotVisibleState], initialStateName: imagesVisibleState.name) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, let sdlManager = self.sdlManager, buttonPress != nil else { return }
            
            self.imagesEnabled = !self.imagesEnabled

            if let imagesVisibleSoftButton = sdlManager.screenManager.softButtonObjectNamed(ImagesVisibleSoftButton) {
                imagesVisibleSoftButton.transitionToNextState()
            }

            if let alertSoftButton = sdlManager.screenManager.softButtonObjectNamed(AlertSoftButton) {
                alertSoftButton.transitionToNextState()
            }

            if let subtleAlertSoftButton = sdlManager.screenManager.softButtonObjectNamed(SubtleAlertSoftButton) {
                subtleAlertSoftButton.transitionToNextState()
            }
        }
    }
}
