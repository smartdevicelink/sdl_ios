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
    class func alertWithMessage(_ message: String) -> SDLAlert {
        return SDLAlert(alertText1: message, alertText2: nil, alertText3: nil)
    }

    class func alertWithMessageAndCloseButton(_ message: String) -> SDLAlert {
        let okSoftButton = SDLSoftButton(type: .text, text: "OK", image: nil, highlighted: true, buttonId: 1, systemAction: nil, handler: nil)
        return SDLAlert(alertText1: message, alertText2: nil, alertText3: nil, duration: 5000, softButtons: [okSoftButton])
    }
}
