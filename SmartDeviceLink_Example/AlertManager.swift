//
//  AlertManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Nicole on 4/12/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class AlertManager {
    /// Creates an alert with a single line of text
    ///
    /// - Parameter message: The message to display in the alert
    /// - Returns: An SDLAlert object
    class func alertWithMessage(_ message: String) -> SDLAlert {
        return SDLAlert(alertText1: message, alertText2: nil, alertText3: nil)
    }

    /// Creates an alert with up to two lines of text and a close alert button
    ///
    /// - Parameter message: The message to display in the alert
    /// - Returns: An SDLAlert object
    class func alertWithMessageAndCloseButton(_ message: String) -> SDLAlert {
        let okSoftButton = SDLSoftButton(type: .text, text: "OK", image: nil, highlighted: true, buttonId: 1, systemAction: nil, handler: nil)
        return SDLAlert(alertText1: message, alertText2: nil, alertText3: nil, duration: 5000, softButtons: [okSoftButton])
    }
}
