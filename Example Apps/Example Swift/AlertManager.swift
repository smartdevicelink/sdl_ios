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
    ///  Sends an alert with up to two lines of text, an image, and a close button that will dismiss the alert when tapped.
    /// - Parameters:
    ///   - imageName: The name of the image to upload
    ///   - textField1: The first line of text in the alert
    ///   - textField2: The second line of text in the alert
    ///   - sdlManager: The SDLManager
    class func sendAlert(imageName: String? = nil, textField1: String, textField2: String? = nil, sdlManager: SDLManager) {
        let okSoftButton = SDLSoftButton(type: .text, text: AlertOKButtonText, image: nil, highlighted: true, buttonId: 2, systemAction: nil, handler: nil)
        let alert = SDLAlert(alertText1: textField1, alertText2: textField2, alertText3: nil, softButtons: [okSoftButton], playTone: true, ttsChunks: nil, duration: 5000, progressIndicator: false, alertIcon: nil, cancelID: 0)

        if let imageName = imageName {
            sendImage(imageName, sdlManager: sdlManager) { (success, artworkName) in
                if success {
                    alert.alertIcon = SDLImage(name: artworkName, isTemplate: true)
                }
                sdlManager.send(alert)
            }
        } else {
            sdlManager.send(alert)
        }
    }

    ///  Sends a subtle alert with up to two lines of text, and an image.
    /// - Parameters:
    ///   - imageName: The name of the image to upload
    ///   - textField1: The first line of text in the alert
    ///   - textField2: The second line of text in the alert
    ///   - sdlManager: The SDLManager
    class func sendSubtleAlert(imageName: String? = nil, textField1: String, textField2: String? = nil, sdlManager: SDLManager) {
        let subtleAlert = SDLSubtleAlert(alertText1: textField1, alertText2: textField2, alertIcon: nil, ttsChunks: nil, duration: nil, softButtons: nil, cancelID: NSNumber(0))

        if let imageName = imageName {
            sendImage(imageName, sdlManager: sdlManager) { (success, artworkName) in
                if success {
                    subtleAlert.alertIcon = SDLImage(name: artworkName, isTemplate: true)
                }
                sdlManager.send(subtleAlert)
            }
        } else {
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
