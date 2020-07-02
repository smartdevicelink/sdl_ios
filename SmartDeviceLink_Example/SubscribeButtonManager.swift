//
//  SubscribeButtonManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 6/19/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class SubscribeButtonManager {
    private let sdlManager: SDLManager!
    private let presetButtons: [SDLButtonName] = [.preset0, .preset1, .preset2, .preset3, .preset4, .preset5, .preset6, .preset7]

    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
    }

    /// Subscribe to all available preset buttons. An alert will be shown when a preset button is short pressed or long pressed.
    func subscribeToPresetButtons() {
        guard (sdlManager.systemCapabilityManager.defaultMainWindowCapability?.numCustomPresetsAvailable?.intValue ?? 0) > 0 else {
            SDLLog.w("The module does not support preset buttons")
            return
        }

        presetButtons.forEach { buttonName in
            _ = sdlManager.screenManager.subscribeButton(buttonName) { [weak self] (press, event, error) in
                guard error == nil else {
                    SDLLog.e("There was an error subscribing to the preset button: \(error!.localizedDescription)")
                    return
                }

                guard let buttonPress = press else { return }

                let alert: SDLAlert
                let buttonName = buttonPress.buttonName.rawValue.rawValue
                switch buttonPress.buttonPressMode {
                case .short:
                    alert = AlertManager.alertWithMessageAndCloseButton("\(buttonName) short pressed")
                case .long:
                     alert = AlertManager.alertWithMessageAndCloseButton("\(buttonName) long pressed")
                default: fatalError()
                }

                self?.sdlManager.send(alert)
            }
        }
    }
}
