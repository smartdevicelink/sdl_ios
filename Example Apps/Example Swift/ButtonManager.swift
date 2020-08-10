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
    ///
    /// - Parameter manager: The SDL Manager for showing the alert
    /// - Returns: A soft button
    private var softButtonAlert: SDLSoftButtonObject {
        let imageSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonImageState, text: nil, image: UIImage(named: AlertBWIconName)?.withRenderingMode(.alwaysTemplate))
        let textSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonTextState, text: AlertSoftButtonText, image: nil)
        return SDLSoftButtonObject(name: AlertSoftButton, states: [imageSoftButtonState, textSoftButtonState], initialStateName: imageSoftButtonState.name) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, buttonPress != nil else { return }
            self.sdlManager.fileManager.upload(artwork: SDLArtwork(image: UIImage(named: CarBWIconImageName)!, persistent: false, as: .PNG), completionHandler: { [weak self] (success, artworkName, bytesAvailable, err) in
                guard let self = self else { return }
                let alert = AlertManager.alertWithMessageAndCloseButton(AlertMessageText, iconName: artworkName)
                self.sdlManager.send(alert)
            })
        }
    }

    /// Returns a soft button that shows a subtle alert when tapped.
    ///
    /// - Returns: A soft button
    private var softButtonSubtleAlert: SDLSoftButtonObject {
        return SDLSoftButtonObject(name: SubtleAlertSoftButton, text: nil, artwork: SDLArtwork(image: (UIImage(named: BatteryFullBWIconName)?.withRenderingMode(.alwaysTemplate))!, persistent: false, as: .PNG)) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, buttonPress != nil else { return }

            let subtleAlertImage = SDLArtwork(image: (UIImage(named: BatteryEmptyBWIconName)?.withRenderingMode(.alwaysTemplate))!, persistent: false, as: .PNG)
            self.sdlManager.fileManager.upload(artwork: subtleAlertImage, completionHandler: { [weak self] (success, artworkName, bytesAvailable, err) in
                guard let self = self else { return }

                let subtleAlert = AlertManager.subtleAlertWithMessageAndCloseButton(SubtleAlertHeaderText, textField2: SubtleAlertSubheaderText, iconName: artworkName)
                self.sdlManager.send(request: subtleAlert) { [weak self] (request, response, error) in
                    guard let self = self, !(response?.success.boolValue ?? false) else { return }

                    self.sdlManager.send(AlertManager.alertWithMessageAndCloseButton(SubtleAlertNotSupportedText))
                }
            })
        }
    }

    /// Returns a soft button that toggles the textfield visibility state for the SDL UI. The button's text toggles based on the current text visibility.
    ///
    /// - Returns: A soft button
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

    /// Returns a soft button that toggles the image visibility state for the SDL UI. The button's text toggles based on the current image visibility.
    ///
    /// - Returns: A soft button
    private var softButtonImagesVisible: SDLSoftButtonObject {
        let imagesVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOnState, text: ImagesVisibleSoftButtonImageOnText, image: nil)
        let imagesNotVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOffState, text: ImagesVisibleSoftButtonImageOffText, image: nil)
        return SDLSoftButtonObject(name: ImagesVisibleSoftButton, states: [imagesVisibleState, imagesNotVisibleState], initialStateName: imagesVisibleState.name) { [weak self] (buttonPress, buttonEvent) in
            guard let self = self, let manager = self.sdlManager, buttonPress != nil, let alertSoftButton = manager.screenManager.softButtonObjectNamed(AlertSoftButton) else { return }
            self.imagesEnabled = !self.imagesEnabled

            let imagesVisibleSoftButton = self.sdlManager.screenManager.softButtonObjectNamed(ImagesVisibleSoftButton)
            imagesVisibleSoftButton?.transitionToNextState()

            alertSoftButton.transitionToNextState()
        }
    }
}
