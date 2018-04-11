//
//  AudioManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class AudioManager: NSObject {
    class func appNameTTS() -> SDLSpeak {
        return SDLSpeak(tts: ExampleAppNameTTS)
    }

    class func goodJobTTS() -> SDLSpeak {
        return SDLSpeak(tts: TTSGoodJob)
    }

    class func youMissedTTS() -> SDLSpeak {
        return SDLSpeak(tts: TTSYouMissed)
    }
}
