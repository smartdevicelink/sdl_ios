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
    private class var okSoftButton: SDLSoftButton {
        return SDLSoftButton(type: .text, text: AlertOKButtonText, image: nil, highlighted: true, buttonId: 1, systemAction: nil, handler: nil)
    }

    /// Creates an alert with up to two lines of text, an image, and a close button that will dismiss the alert when tapped.
    /// - Parameters:
    ///   - textField1: The first line of a message to display in the alert
    ///   - textField2: The second line of a message to display in the alert
    ///   - iconName: An image to show in the alert
    /// - Returns: An SDLAlert object
    class func alertWithMessageAndCloseButton(_ textField1: String, textField2: String? = nil, iconName: String? = nil) -> SDLAlert {
        return SDLAlert(alertText1: textField1, alertText2: textField2, alertText3: nil, softButtons: [okSoftButton], playTone: true, ttsChunks: nil, duration: 5000, progressIndicator: false, alertIcon: (iconName != nil) ? SDLImage(name: iconName!, isTemplate: true) : nil, cancelID: 0)
    }


    /// Creates as subtle alert with two lines of text, an image, and a close button that will dismiss the alert when tapped.
    /// - Parameters:
    ///   - textField1: The first line of a message to display in the alert
    ///   - textField2: The second line of a message to display in the alert
    ///   - iconName: An image to show in the alert
    /// - Returns: An SDLSubtleAlert object
    class func subtleAlertWithMessageAndCloseButton(_ textField1: String, textField2: String? = nil, iconName: String? = nil) -> SDLSubtleAlert {
        return SDLSubtleAlert(alertText1: textField1, alertText2: textField2, alertIcon: (iconName != nil) ? SDLImage(name: iconName!, isTemplate: true) : nil, ttsChunks: nil, duration: nil, softButtons: [okSoftButton], cancelID: NSNumber(0))
    }
}
