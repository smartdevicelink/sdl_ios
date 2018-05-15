//
//  PerformInteractionManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Nicole on 5/15/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import UIKit
import SmartDeviceLink
import SmartDeviceLinkSwift

class PerformInteractionManager: NSObject {
    /// Creates a choice set to be used in a PerformInteraction. The choice set must be sent to SDL Core and a response received before it can be used in a PerformInteraction request.
    ///
    /// - Returns: A SDLCreateInteractionChoiceSet request
    class func createInteractionChoiceSet() -> SDLCreateInteractionChoiceSet {
        return SDLCreateInteractionChoiceSet(id: UInt32(ChoiceSetId), choiceSet: createChoiceSet())
    }
    
    /// Shows a PICS. The handler is called when the user selects a menu item or when the menu times out after a set amount of time. A custom text-to-speech phrase is spoken when the menu is closed.
    ///
    /// - Parameter manager: The SDL Manager
    class func showPerformInteractionChoiceSet(with manager: SDLManager, triggerSource: SDLTriggerSource) {
        manager.send(request: createPerformInteraction(triggerSource: triggerSource)) { (_, response, error) in
            guard response?.resultCode == .success else {
                SDLLog.e("The Show Perform Interaction Choice Set request failed: \(error?.localizedDescription ?? "no error")")
                return
            }

            if response?.resultCode == .timedOut {
                // The menu timed out before the user could select an item
                manager.send(SDLSpeak(tts: TTSYouMissed))
            } else if response?.resultCode == .success {
                // The user selected an item in the menu
                manager.send(SDLSpeak(tts: TTSGoodJob))
            }
        }
    }
}

// MARK: - PICS Menu

private extension PerformInteractionManager {
    static let ChoiceSetId = 100
    /// The PICS menu items
    ///
    /// - Returns: An array of SDLChoice items
    class func createChoiceSet() -> [SDLChoice] {
        let firstChoice = SDLChoice(id: 1, menuName: PICSFirstChoice, vrCommands: [PICSFirstChoice])
        let secondChoice = SDLChoice(id: 2, menuName: PICSSecondChoice, vrCommands: [PICSSecondChoice])
        let thirdChoice = SDLChoice(id: 3, menuName: PICSThirdChoice, vrCommands: [PICSThirdChoice])
        return [firstChoice, secondChoice, thirdChoice]
    }

    /// Creates a PICS with three menu items and customized voice commands
    ///
    /// - Returns: A SDLPerformInteraction request
    class func createPerformInteraction(triggerSource: SDLTriggerSource) -> SDLPerformInteraction {
        let interactionMode: SDLInteractionMode = triggerSource == .voiceRecognition ? .voiceRecognitionOnly : .manualOnly
        let performInteraction = SDLPerformInteraction(initialPrompt: PICSInitialPrompt, initialText: PICSInitialText, interactionChoiceSetIDList: [ChoiceSetId as NSNumber], helpPrompt: PICSHelpPrompt, timeoutPrompt: PICSTimeoutPrompt, interactionMode: interactionMode, timeout: 10000)
        performInteraction.interactionLayout = .listOnly
        return performInteraction
    }
}
