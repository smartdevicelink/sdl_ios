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
            updateSoftButtonHexagonIcon(isEnabled: hexagonEnabled, isImageEnabled: imagesEnabled, manager: sdlManager)
        }
    }

    public fileprivate(set) var hexagonEnabled: Bool {
        didSet {
            updateSoftButtonHexagonIcon(isEnabled: hexagonEnabled, isImageEnabled: imagesEnabled, manager: sdlManager)
        }
    }

    init(sdlManager: SDLManager, updateScreenHandler: updateScreenHandler? = nil) {
        self.sdlManager = sdlManager
        self.updateScreenHandler = updateScreenHandler
        textEnabled = true
        imagesEnabled = true
        hexagonEnabled = true
        super.init()
    }

    func screenSoftButtons(with manager: SDLManager) -> [SDLSoftButtonObject] {
//        return [softButtonStar(with: manager), softButtonHexagon()]
        return [softButtonStar(with: manager), softButtonHexagon(), softButtonTextVisible(), softButtonImagesVisible()]
    }
}

private extension ButtonManager {
    func softButtonStar(with manager: SDLManager) -> SDLSoftButtonObject {
        let imageSoftButtonState = SDLSoftButtonState(stateName: StarSoftButtonImageState, text: nil, image: UIImage(named: StarImageName))
        let textSoftButtonState = SDLSoftButtonState(stateName: StarSoftButtonTextState, text: StarSoftButtonText, image: nil)
        let softButton = SDLSoftButtonObject(name: StarSoftButton, states: [imageSoftButtonState, textSoftButtonState], initialStateName: imageSoftButtonState.name) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let alert = SDLAlert(alertText1: "You pressed the button", alertText2: nil, alertText3: nil)
            manager.send(alert)
        }

        return softButton
    }

    func softButtonHexagon() -> SDLSoftButtonObject {
        let imageOnState = SDLSoftButtonState(stateName: HexagonSoftButtonImageOnState, text: nil, image: UIImage(named: HexagonOnImageName))
        let imageOffState = SDLSoftButtonState(stateName: HexagonSoftButtonImageOffState, text: nil, image: UIImage(named: HexagonOffImageName))
        let textOnState = SDLSoftButtonState(stateName: HexagonSoftButtonTextOnState, text: HexagonSoftButtonTextTextOnText, image: nil)
        let textOffState = SDLSoftButtonState(stateName: HexagonSoftButtonTextOffState, text: HexagonSoftButtonTextTextOffText, image: nil)
        let softButton = SDLSoftButtonObject(name: HexagonSoftButton, states: [imageOnState, imageOffState, textOnState, textOffState], initialStateName: imageOnState.name) { [unowned self] (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.hexagonEnabled = !self.hexagonEnabled
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

    func updateSoftButtonHexagonIcon(isEnabled: Bool, isImageEnabled: Bool, manager: SDLManager) {
        let hexagonSoftButton = manager.screenManager.softButtonObjectNamed(HexagonSoftButton)
        guard (isImageEnabled ? hexagonSoftButton?.transition(toState: isEnabled ? HexagonSoftButtonImageOnState : HexagonSoftButtonImageOffState) : hexagonSoftButton?.transition(toState: isEnabled ? HexagonSoftButtonTextOnState : HexagonSoftButtonTextOffState)) != nil else {
            print("The state for the hexagon soft button was not found")
            return
        }
    }
}
