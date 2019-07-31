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
    
    /// SDL UI textfields are visible if true; hidden if false
    public fileprivate(set) var textEnabled: Bool {
        didSet {
            guard let refreshUIHandler = refreshUIHandler else { return }
            refreshUIHandler()
        }
    }

    /// SDL UI images are visible if true; hidden if false
    public fileprivate(set) var imagesEnabled: Bool {
        didSet {
            guard let refreshUIHandler = refreshUIHandler, let alertSoftButton = sdlManager.screenManager.softButtonObjectNamed(AlertSoftButton) else { return }
            alertSoftButton.transitionToNextState()
            refreshUIHandler()
        }
    }

    /// Keeps track of the toggle soft button current state. The image or text changes when the button is selected
    fileprivate var toggleEnabled: Bool {
        didSet {
            guard let hexagonSoftButton = sdlManager.screenManager.softButtonObjectNamed(ToggleSoftButton), hexagonSoftButton.transition(toState: toggleEnabled ? ToggleSoftButtonImageOnState : ToggleSoftButtonImageOffState) else { return }
        }
    }

    init(sdlManager: SDLManager, updateScreenHandler: RefreshUIHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshUIHandler = updateScreenHandler
        textEnabled = true
        imagesEnabled = true
        toggleEnabled = true
        super.init()
    }

    /// Creates and returns an array of all soft buttons for the UI
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of all soft buttons for the UI
    func allScreenSoftButtons(with manager: SDLManager) -> [SDLSoftButtonObject] {
        return [softButtonAlert(with: manager), softButtonToggle(), softButtonTextVisible(), softButtonImagesVisible()]
    }
}

// MARK: - Custom Soft Buttons

private extension ButtonManager {
    /// Returns a soft button that shows an alert when tapped.
    ///
    /// - Parameter manager: The SDL Manager for showing the alert
    /// - Returns: A soft button
    func softButtonAlert(with manager: SDLManager) -> SDLSoftButtonObject {
        let imageSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonImageState, text: nil, image: UIImage(named: AlertBWIconName)?.withRenderingMode(.alwaysTemplate))
        let textSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonTextState, text: AlertSoftButtonText, image: nil)
        return SDLSoftButtonObject(name: AlertSoftButton, states: [imageSoftButtonState, textSoftButtonState], initialStateName: imageSoftButtonState.name) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            manager.fileManager.upload(artwork: SDLArtwork(image: UIImage(named: CarBWIconImageName)!, persistent: false, as: .PNG), completionHandler: { (success, artworkName, bytesAvailable, err) in
                let alert = AlertManager.alertWithMessageAndCloseButton("You pressed the button!", iconName: artworkName)
                manager.send(alert)
            })
        }
    }

    /// Returns a soft button that toggles between two states: on and off. If images are currently visible, the button image toggles; if images aren't visible, the button text toggles.
    ///
    /// - Returns: A soft button
    func softButtonToggle() -> SDLSoftButtonObject {
        let imageOnState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOnState, text: nil, image: UIImage(named: ToggleOnBWIconName)?.withRenderingMode(.alwaysTemplate))
        let imageOffState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOffState, text: nil, image: UIImage(named: ToggleOffBWIconName)?.withRenderingMode(.alwaysTemplate))
        return SDLSoftButtonObject(name: ToggleSoftButton, states: [imageOnState, imageOffState], initialStateName: imageOnState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.toggleEnabled = !self.toggleEnabled
        }
    }

    /// Returns a soft button that toggles the textfield visibility state for the SDL UI. The button's text toggles based on the current text visibility.
    ///
    /// - Returns: A soft button
    func softButtonTextVisible() -> SDLSoftButtonObject {
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
    func softButtonImagesVisible() -> SDLSoftButtonObject {
        let imagesVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOnState, text: ImagesVisibleSoftButtonImageOnText, image: nil)
        let imagesNotVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOffState, text: ImagesVisibleSoftButtonImageOffText, image: nil)
        return SDLSoftButtonObject(name: ImagesVisibleSoftButton, states: [imagesVisibleState, imagesNotVisibleState], initialStateName: imagesVisibleState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.imagesEnabled = !self.imagesEnabled

            // Update the button state
            let softButton = self.sdlManager.screenManager.softButtonObjectNamed(ImagesVisibleSoftButton)
            softButton?.transitionToNextState()
        }
    }
}
