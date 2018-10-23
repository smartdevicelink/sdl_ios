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
    fileprivate var manager: SDLManager!

    init(sdlManager: SDLManager) {
        self.manager = sdlManager
    }
    
    /// Shows a PICS. The handler is called when the user selects a menu item or when the menu times out after a set amount of time. A custom text-to-speech phrase is spoken when the menu is closed.
    ///
    /// - Parameter manager: The SDL Manager
    func show(from triggerSource: SDLTriggerSource) {
        manager.screenManager.presentSearchableChoiceSet(choiceSet, mode: interactionMode(for: triggerSource), with: self)
    }
}

// MARK: - PICS Menu

private extension PerformInteractionManager {
    /// The PICS menu items
    var choiceCells: [SDLChoiceCell] {
        let firstChoice = SDLChoiceCell(text: PICSFirstChoice, artwork: SDLArtwork(staticIcon: .key), voiceCommands: nil)
        let secondChoice = SDLChoiceCell(text: PICSSecondChoice)
        let thirdChoice = SDLChoiceCell(text: PICSThirdChoice)
        return [firstChoice, secondChoice, thirdChoice]
    }

    /// Creates a PICS with three menu items and customized voice commands
    var choiceSet: SDLChoiceSet {
        return SDLChoiceSet(title: PICSInitialPrompt, delegate: self, layout: .list, timeout: 10, initialPromptString: PICSInitialPrompt, timeoutPromptString: PICSTimeoutPrompt, helpPromptString: PICSHelpPrompt, vrHelpList: nil, choices: choiceCells)
    }

    func interactionMode(for triggerSource: SDLTriggerSource) -> SDLInteractionMode {
        return (triggerSource == .menu ? .manualOnly : .voiceRecognitionOnly)
    }
}

extension PerformInteractionManager: SDLChoiceSetDelegate {
    func choiceSet(_ choiceSet: SDLChoiceSet, didSelectChoice choice: SDLChoiceCell, withSource source: SDLTriggerSource, atRowIndex rowIndex: UInt) {
        manager.send(SDLSpeak(tts: TTSGoodJob))
    }

    func choiceSet(_ choiceSet: SDLChoiceSet, didReceiveError error: Error) {
        manager.send(SDLSpeak(tts: TTSYouMissed))
    }
}

extension PerformInteractionManager: SDLKeyboardDelegate {
    func keyboardDidAbort(withReason event: SDLKeyboardEvent) {
        switch event {
        case SDLKeyboardEvent.cancelled:
            manager.send(SDLSpeak(tts: TTSYouMissed))
        case SDLKeyboardEvent.aborted:
            manager.send(SDLSpeak(tts: TTSYouMissed))
        default: break
        }
    }

    func userDidSubmitInput(_ inputText: String, withEvent source: SDLKeyboardEvent) {
        switch source {
        case SDLKeyboardEvent.voice: break
            // Start Voice search
        case SDLKeyboardEvent.submitted:
            manager.send(SDLSpeak(tts: TTSGoodJob))
        default: break
        }
    }

    func updateAutocomplete(withInput currentInputText: String, completionHandler: @escaping SDLKeyboardAutocompleteCompletionHandler) {
        if currentInputText.lowercased().hasPrefix("f") {
            completionHandler(PICSFirstChoice)
        } else if currentInputText.lowercased().hasPrefix("s") {
            completionHandler(PICSSecondChoice)
        } else if currentInputText.lowercased().hasPrefix("t") {
            completionHandler(PICSThirdChoice)
        } else {
            completionHandler(nil)
        }
    }
}
