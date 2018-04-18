//
//  MenuManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class MenuManager: NSObject {
    /// Creates a choice set to be used in a PerformInteraction. The choice set must be sent to SDL Core and a response received before it can be used in a PerformInteraction request.
    ///
    /// - Returns: A SDLCreateInteractionChoiceSet request
    class func createInteractionChoiceSet() -> SDLCreateInteractionChoiceSet {
        return SDLCreateInteractionChoiceSet(id: UInt32(choiceSetId), choiceSet: createChoiceSet())
    }

    /// Creates and returns the root menu items.
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of SDLAddCommand requests
    class func allAddCommands(with manager: SDLManager) -> [SDLAddCommand] {
        return [addCommandSpeakName(with: manager), addCommandGetVehicleSpeed(with: manager), addCommandShowPerformInteraction(with: manager), addCommandRecordInCarMicrophoneAudio(with: manager)]
    }
}

// MARK: - Perform Interaction Choice Set Menu

private extension MenuManager {
    static let choiceSetId = 100
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
    class func createPerformInteraction() -> SDLPerformInteraction {
        let performInteraction = SDLPerformInteraction(initialPrompt: PICSInitialPrompt, initialText: PICSInitialText, interactionChoiceSetIDList: [choiceSetId as NSNumber], helpPrompt: PICSHelpPrompt, timeoutPrompt: PICSTimeoutPrompt, interactionMode: .both, timeout: 10000)
        performInteraction.interactionLayout = .listOnly
        return performInteraction
    }

    /// Shows a PICS. The handler is called when the user selects a menu item or when the menu times out after a set amount of time. A custom text-to-speech phrase is spoken when the menu is closed.
    ///
    /// - Parameter manager: The SDL Manager
    class func showPerformInteractionChoiceSet(with manager: SDLManager) {
        manager.send(request: createPerformInteraction()) { (_, response, error) in
            guard response?.resultCode == .success else {
                SDLLog.e("The Show Perform Interaction Choice Set request failed: \(String(describing: error?.localizedDescription))")
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

// MARK: - Add Commands for Root Menu

private extension MenuManager {
    /// Menu item that speaks the app name when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An SDLAddCommand request
    class func addCommandSpeakName(with manager: SDLManager) -> SDLAddCommand {
        let speakAddCommand = SDLAddCommand(id: 200, vrCommands: [ACSpeakAppNameMenuName], menuName: ACSpeakAppNameMenuName, handler: { (onCommand) in
            manager.send(request: SDLSpeak(tts: ExampleAppNameTTS), responseHandler: { (_, response, error) in
                if response?.resultCode != .success {
                    SDLLog.e("Error sending the Speak App name request: \(error != nil ? error!.localizedDescription : "no error message")")
                }
            })
        })

        speakAddCommand.cmdIcon = SDLImage(name: "0x11", ofType: .static)
            // SDLImage(staticImageValue: 0x11)
            // SDLImage(name: "0x11", ofType: .static)
        return speakAddCommand
    }
    
    /// Menu item that requests vehicle data when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An SDLAddCommand request
    class func addCommandGetVehicleSpeed(with manager: SDLManager) ->
        SDLAddCommand {
        let vehicleSpeedAddCommand = SDLAddCommand(id: 201, vrCommands: [ACGetVehicleDataMenuName], menuName: ACGetVehicleDataMenuName, handler: { (onCommand) in
        VehicleDataManager.getVehicleSpeed(with: manager)
        })
        vehicleSpeedAddCommand.cmdIcon = SDLImage(name: "0x2A", ofType: .static)

        return vehicleSpeedAddCommand
    }

    /// Menu item that shows a custom menu (i.e. a Perform Interaction Choice Set) when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An SDLAddCommand request
    class func addCommandShowPerformInteraction(with manager: SDLManager) -> SDLAddCommand {
        return SDLAddCommand(id: 202, vrCommands: [ACShowChoiceSetMenuName], menuName: ACShowChoiceSetMenuName, handler: { (onCommand) in
            showPerformInteractionChoiceSet(with: manager)
        })
    }

    class func addCommandRecordInCarMicrophoneAudio(with manager: SDLManager) -> SDLAddCommand {
        let audioManager = AudioManager(sdlManager: manager)
        let recordAddCommand = SDLAddCommand(id: 203, vrCommands: [ACRecordInCarMicrophoneAudioMenuName], menuName: ACRecordInCarMicrophoneAudioMenuName, handler: { (onCommand) in
            audioManager.startRecording()
        })
        recordAddCommand.cmdIcon = SDLImage(name: "0x91", ofType: .static)

        return recordAddCommand
    }
}
