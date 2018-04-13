//
//  ButtonManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

typealias refreshUIHandler = (() -> Void)

class ButtonManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var refreshUIHandler: refreshUIHandler?
    
    /// SDL UI textfields are visible if true; hidden if false
    public fileprivate(set) var textEnabled: Bool {
        didSet {
            guard let handler = refreshUIHandler else { return }
            handler()
        }
    }

    /// SDL UI images are visible if true; hidden if false
    public fileprivate(set) var imagesEnabled: Bool {
        didSet {
            guard let handler = refreshUIHandler else { return }
            handler()
            updateToggleSoftButtonIcon(isEnabled: toggleEnabled, isImageEnabled: imagesEnabled)
            updateAlertSoftButtonIcon()
        }
    }

    /// Keeps track of the toggle soft button current state. The image or text changes when the button is selected
    fileprivate var toggleEnabled: Bool {
        didSet {
            updateToggleSoftButtonIcon(isEnabled: toggleEnabled, isImageEnabled: imagesEnabled)
        }
    }

    /// Custom init
    ///
    /// - Parameters:
    ///   - sdlManager: The SDL Manager
    ///   - updateScreenHandler: handler for refreshing the current SDL UI
    init(sdlManager: SDLManager, updateScreenHandler: refreshUIHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshUIHandler = updateScreenHandler
        textEnabled = true
        imagesEnabled = true
        toggleEnabled = true
        super.init()
    }

    func reset() {
        textEnabled = true
        imagesEnabled = true
        toggleEnabled = true
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
        let imageSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonImageState, text: nil, image: UIImage(named: CarIconImageName))
        let textSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonTextState, text: AlertSoftButtonText, image: nil)
        let softButton: SDLSoftButtonObject? = SDLSoftButtonObject(name: AlertSoftButton, states: [imageSoftButtonState, textSoftButtonState], initialStateName: imageSoftButtonState.name) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let alert = AlertManager.alertWithMessageAndCloseButton("You pressed the button!")
            manager.send(alert)
        }

        guard softButton != nil else { assert(false, "Button was not created successfully") }
        return softButton!
    }

    /// Returns a soft button that toggles between two states: on and off. If images are currently visible, the button image toggles; if images aren't visible, the button text toggles.
    ///
    /// - Returns: A soft button
    func softButtonToggle() -> SDLSoftButtonObject {
        let imageOnState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOnState, text: nil, image: UIImage(named: WheelIconImageName))
        let imageOffState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOffState, text: nil, image: UIImage(named: LaptopIconImageName))
        let textOnState = SDLSoftButtonState(stateName: ToggleSoftButtonTextOnState, text: ToggleSoftButtonTextTextOnText, image: nil)
        let textOffState = SDLSoftButtonState(stateName: ToggleSoftButtonTextOffState, text: ToggleSoftButtonTextTextOffText, image: nil)
        let softButton: SDLSoftButtonObject? = SDLSoftButtonObject(name: ToggleSoftButton, states: [imageOnState, imageOffState, textOnState, textOffState], initialStateName: imageOnState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.toggleEnabled = !self.toggleEnabled
        }

        guard softButton != nil else { assert(false, "Button was not created successfully") }
        return softButton!
    }

    /// Returns a soft button that toggles the textfield visibility state for the SDL UI. The button's text toggles based on the current text visibility.
    ///
    /// - Returns: A soft button
    func softButtonTextVisible() -> SDLSoftButtonObject {
        let textVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOnState, text: TextVisibleSoftButtonTextOnText, artwork: nil)
        let textNotVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOffState, text: TextVisibleSoftButtonTextOffText, image: nil)
        let softButton: SDLSoftButtonObject? = SDLSoftButtonObject(name: TextVisibleSoftButton, states: [textVisibleState, textNotVisibleState], initialStateName: textVisibleState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.textEnabled = !self.textEnabled

            // Update the button state
            let softButton = self.sdlManager.screenManager.softButtonObjectNamed(TextVisibleSoftButton)
            softButton?.transitionToNextState()
        }

        guard softButton != nil else { assert(false, "Button was not created successfully") }
        return softButton!
    }

    /// Returns a soft button that toggles the image visibility state for the SDL UI. The button's text toggles based on the current image visibility.
    ///
    /// - Returns: A soft button
    func softButtonImagesVisible() -> SDLSoftButtonObject {
        let imagesVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOnState, text: ImagesVisibleSoftButtonImageOnText, image: nil)
        let imagesNotVisibleState = SDLSoftButtonState(stateName: ImagesVisibleSoftButtonImageOffState, text: ImagesVisibleSoftButtonImageOffText, image: nil)
        let softButton: SDLSoftButtonObject? = SDLSoftButtonObject(name: ImagesVisibleSoftButton, states: [imagesVisibleState, imagesNotVisibleState], initialStateName: imagesVisibleState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.imagesEnabled = !self.imagesEnabled

            // Update the button state
            let softButton = self.sdlManager.screenManager.softButtonObjectNamed(ImagesVisibleSoftButton)
            softButton?.transitionToNextState()
        }

        guard softButton != nil else { assert(false, "Button was not created successfully") }
        return softButton!
    }
}

// MARK: - Button State Helpers

private extension ButtonManager {
    /// Updates the toggle button's icon or text for the new state. If images are visible, the button has an image; if images are not visible, text.
    ///
    /// - Parameters:
    ///   - isEnabled: true if on, false if off
    ///   - isImageEnabled: Whether or not SDL UI images are visible
    func updateToggleSoftButtonIcon(isEnabled: Bool, isImageEnabled: Bool) {
        let hexagonSoftButton = sdlManager.screenManager.softButtonObjectNamed(ToggleSoftButton)
        guard (isImageEnabled ? hexagonSoftButton?.transition(toState: isEnabled ? ToggleSoftButtonImageOnState : ToggleSoftButtonImageOffState) : hexagonSoftButton?.transition(toState: isEnabled ? ToggleSoftButtonTextOnState : ToggleSoftButtonTextOffState)) != nil else {
            print("The state for the soft button was not found")
            return
        }
    }

    /// Toggles between the alert button's image state and text state
    func updateAlertSoftButtonIcon() {
        let softButton = sdlManager.screenManager.softButtonObjectNamed(AlertSoftButton)
        softButton?.transitionToNextState()
    }
}
