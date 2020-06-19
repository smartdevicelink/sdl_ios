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

        guard presetButtonSubscriptionIDs.isEmpty else {
            SDLLog.w("The app is already subscribed to preset buttons")
            return
        }

        presetButtons.forEach { buttonName in
            let subscriptionID = sdlManager.screenManager.subscribeButton(buttonName) { [weak self] (press, event, error) in
                guard error == nil, let press = press else { return }
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
            SDLLog.w("The app is not subscribed to preset buttons")
            return
        }

        for subscription in presetButtonSubscriptionIDs {
            guard let observer = subscription.value as? NSObject else { continue }
            sdlManager.screenManager.unsubscribeButton(subscription.key, withObserver: observer) { [weak self] (error) in
                guard error == nil else {
                    SDLLog.e("The \(subscription.key) button was not unsubscribed")
                    return
                }

                SDLLog.d("The \(subscription.key) button was successfully unsubscribed")
                self?.presetButtonSubscriptionIDs[subscription.key] = nil
            }
        }
    }
}
