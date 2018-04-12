//
//  ButtonManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

typealias updateScreenHandler = (() -> Void)

class ButtonManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    var updateScreenHandler: updateScreenHandler?
    
    public fileprivate(set) var textEnabled: Bool {
        didSet {
            guard let handler = updateScreenHandler else { return }
            handler()
        }
    }

    public fileprivate(set) var imagesEnabled: Bool {
        didSet {
            guard let handler = updateScreenHandler else { return }
            handler()
            updateToggleSoftButtonIcon(isEnabled: toggleEnabled, isImageEnabled: imagesEnabled)
            updateAlertSoftButtonIcon()
        }
    }

    public fileprivate(set) var toggleEnabled: Bool {
        didSet {
            updateToggleSoftButtonIcon(isEnabled: toggleEnabled, isImageEnabled: imagesEnabled)
        }
    }

    init(sdlManager: SDLManager, updateScreenHandler: updateScreenHandler? = nil) {
        self.sdlManager = sdlManager
        self.updateScreenHandler = updateScreenHandler
        textEnabled = true
        imagesEnabled = true
        toggleEnabled = true
        super.init()
    }

    func screenSoftButtons(with manager: SDLManager) -> [SDLSoftButtonObject] {
        return [softButtonAlert(with: manager), softButtonToggle(), softButtonTextVisible(), softButtonImagesVisible()]
    }
}

private extension ButtonManager {
    func softButtonAlert(with manager: SDLManager) -> SDLSoftButtonObject {
        let imageSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonImageState, text: nil, image: UIImage(named: CarIconImageName))
        let textSoftButtonState = SDLSoftButtonState(stateName: AlertSoftButtonTextState, text: AlertSoftButtonText, image: nil)
        let softButton = SDLSoftButtonObject(name: AlertSoftButton, states: [imageSoftButtonState, textSoftButtonState], initialStateName: imageSoftButtonState.name) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let alert = AlertManager.alertWithMessageAndCloseButton("You pressed the button!")
            manager.send(alert)
        }

        return softButton
    }

    func softButtonToggle() -> SDLSoftButtonObject {
        let imageOnState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOnState, text: nil, image: UIImage(named: WheelIconImageName))
        let imageOffState = SDLSoftButtonState(stateName: ToggleSoftButtonImageOffState, text: nil, image: UIImage(named: LaptopIconImageName))
        let textOnState = SDLSoftButtonState(stateName: ToggleSoftButtonTextOnState, text: ToggleSoftButtonTextTextOnText, image: nil)
        let textOffState = SDLSoftButtonState(stateName: ToggleSoftButtonTextOffState, text: ToggleSoftButtonTextTextOffText, image: nil)
        let softButton = SDLSoftButtonObject(name: ToggleSoftButton, states: [imageOnState, imageOffState, textOnState, textOffState], initialStateName: imageOnState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.toggleEnabled = !self.toggleEnabled
        }

        return softButton
    }

    func softButtonTextVisible() -> SDLSoftButtonObject {
        let textVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOnState, text: TextVisibleSoftButtonTextOnText, artwork: nil)
        let textNotVisibleState = SDLSoftButtonState(stateName: TextVisibleSoftButtonTextOffState, text: TextVisibleSoftButtonTextOffText, image: nil)
        let softButton = SDLSoftButtonObject(name: TextVisibleSoftButton, states: [textVisibleState, textNotVisibleState], initialStateName: textVisibleState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.textEnabled = !self.textEnabled

            // Update the button state
            let softButton = self.sdlManager.screenManager.softButtonObjectNamed(TextVisibleSoftButton)
            softButton?.transitionToNextState()
        }
        return softButton
    }

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
        if softButton == nil {
            print("Something went wrong...")
        }

        return softButton!
    }

    func updateToggleSoftButtonIcon(isEnabled: Bool, isImageEnabled: Bool) {
        let hexagonSoftButton = sdlManager.screenManager.softButtonObjectNamed(ToggleSoftButton)
        guard (isImageEnabled ? hexagonSoftButton?.transition(toState: isEnabled ? ToggleSoftButtonImageOnState : ToggleSoftButtonImageOffState) : hexagonSoftButton?.transition(toState: isEnabled ? ToggleSoftButtonTextOnState : ToggleSoftButtonTextOffState)) != nil else {
            print("The state for the hexagon soft button was not found")
            return
        }
    }

    func updateAlertSoftButtonIcon() {
        let softButton = sdlManager.screenManager.softButtonObjectNamed(AlertSoftButton)
        softButton?.transitionToNextState()
    }
}
