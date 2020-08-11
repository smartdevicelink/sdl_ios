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

    ///  Sends an alert with an image.
    /// - Parameters:
    ///   - imageName: The name of the image to upload
    ///   - textField1: The first line of text in the alert
    ///   - textField2: The second line of text in the alert
    ///   - sdlManager: The SDLManager
    class func sendAlert(imageName: String, textField1: String, textField2: String? = nil, sdlManager: SDLManager) {
        sendImage(imageName, sdlManager: sdlManager) { (success, artworkName) in
            let alert = alertWithMessageAndCloseButton(textField1, textField2: textField2, iconName: artworkName)
            sdlManager.send(alert)
        }
    }

    ///  Sends a subtle alert with an image.
    /// - Parameters:
    ///   - imageName: The name of the image to upload
    ///   - textField1: The first line of text in the alert
    ///   - textField2: The second line of text in the alert
    ///   - sdlManager: The SDLManager
    class func sendSubtleAlert(imageName: String, textField1: String, textField2: String? = nil, sdlManager: SDLManager) {
        sendImage(imageName, sdlManager: sdlManager) { (success, artworkName) in
            let subtleAlert = subtleAlertWithMessageAndCloseButton(textField1, textField2: textField2, iconName: (success ? artworkName : nil))
            sdlManager.send(subtleAlert)
        }
    }

    /// Helper method for uploading an image before it is shown in an alert
    /// - Parameters:
    ///   - imageName: The name of the image to upload
    ///   - sdlManager: The SDLManager
    ///   - completionHandler: Handler called when the artwork has finished uploading with the success of the upload and the name of the uploaded image.
    private class func sendImage(_ imageName: String, sdlManager: SDLManager, completionHandler: @escaping ((_ success: Bool, _ artwork: String) -> ())) {
        let artwork = SDLArtwork(image: UIImage(named: imageName)!.withRenderingMode(.alwaysTemplate), persistent: false, as: .PNG)
        sdlManager.fileManager.upload(artwork: artwork) { (success, artworkName, bytesAvailable, error) in
            return completionHandler(success, artworkName)
        }
    }
}
