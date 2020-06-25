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
    fileprivate let sdlManager: SDLManager!
    let presetButtons: [SDLButtonName] = [.preset0, .preset1, .preset2, .preset3, .preset4, .preset5, .preset6, .preset7]
    fileprivate var presetButtonSubscriptionIDs = [SDLButtonName: Any]()

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
            guard presetButtonSubscriptionIDs[buttonName] == nil else {
                SDLLog.w("The app is already subscribed to the \(buttonName.rawValue.rawValue) button")
                return
            }

            let subscriptionID = sdlManager.screenManager.subscribeButton(buttonName) { [weak self] (press, event, error) in
                guard error == nil, let press = press else {
                    SDLLog.e("Error subscribing to the \(buttonName.rawValue.rawValue) button")
                    self?.presetButtonSubscriptionIDs[buttonName] = nil;
                    return
                }

                let alert: SDLAlert
                if press.buttonPressMode == .short {
                    alert = AlertManager.alertWithMessageAndCloseButton("\(press.buttonName.rawValue.rawValue) pressed")
                } else {
                    alert = AlertManager.alertWithMessageAndCloseButton("\(press.buttonName.rawValue.rawValue) long pressed")
                }

                self?.sdlManager.send(alert)
            }

            presetButtonSubscriptionIDs[buttonName] = subscriptionID
        }
    }

    /// Unsubscribes to all subscribed preset buttons.
    func unsubscribeToPresetButtons() {
        guard !presetButtonSubscriptionIDs.isEmpty else {
            SDLLog.w("The app is not subscribed to any preset buttons")
            return
        }

        for (buttonName, subscriptionID) in presetButtonSubscriptionIDs {
            guard let subscriptionID  = subscriptionID as? NSObject else { continue }
            sdlManager.screenManager.unsubscribeButton(buttonName, withObserver: subscriptionID) { [weak self] (error) in
                guard error == nil else {
                    SDLLog.e("The \(buttonName.rawValue.rawValue) button was not unsubscribed successfully")
                    return
                }

                SDLLog.d("The \(buttonName.rawValue.rawValue) button was successfully unsubscribed")
                self?.presetButtonSubscriptionIDs[buttonName] = nil
            }
        }
    }
}
