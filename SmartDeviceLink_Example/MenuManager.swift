//
//  MenuManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Nicole on 4/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class MenuManager: NSObject {
    class func createInteractionChoiceSet() -> SDLCreateInteractionChoiceSet {
        return SDLCreateInteractionChoiceSet(id: UInt32(choiceSetId), choiceSet: createChoiceSet())
    }

    class func allAddCommands(with manager: SDLManager) -> [SDLAddCommand] {
        return [addCommandSpeakName(with: manager), addCommandGetVehicleData(with: manager), addCommandShowPerformInteraction(with: manager)]
    }

    class func createChoiceSets() -> [SDLCreateInteractionChoiceSet] {
        var interactionChoiceSet = [SDLCreateInteractionChoiceSet]()

        var choiceId = 1
        for _ in 0..<20 {
            var choiceSet = [SDLChoice]()
            for _ in 0..<40 {
                let menuName = "Choice \(choiceId)"
                choiceSet.append(SDLChoice(id: UInt16(choiceId), menuName: menuName, vrCommands: [menuName], image: nil, secondaryText: nil, secondaryImage: nil, tertiaryText: nil))
                choiceId += 1
            }
            interactionChoiceSet.append(SDLCreateInteractionChoiceSet(id: UInt32(choiceId), choiceSet: choiceSet))
            choiceId += 1
        }

        return interactionChoiceSet
    }
}

// MARK: - Perform Interaction Choice Set Menu

private extension MenuManager {
    static let choiceSetId = 100

    class func createChoiceSet() -> [SDLChoice] {
        let firstChoice = SDLChoice(id: 1, menuName: PICSFirstChoice, vrCommands: [PICSFirstChoice])
        let secondChoice = SDLChoice(id: 2, menuName: PICSSecondChoice, vrCommands: [PICSSecondChoice])
        let thirdChoice = SDLChoice(id: 3, menuName: PICSThirdChoice, vrCommands: [PICSThirdChoice])
        return [firstChoice, secondChoice, thirdChoice]
    }

    class func createPerformInteraction() -> SDLPerformInteraction {
        let performInteraction = SDLPerformInteraction(initialPrompt: PICSInitialPrompt, initialText: PICSInitialText, interactionChoiceSetIDList: [choiceSetId as NSNumber], helpPrompt: PICSHelpPrompt, timeoutPrompt: PICSTimeoutPrompt, interactionMode: .both, timeout: 10000)
        performInteraction.interactionLayout = .listOnly
        return performInteraction
    }

    class func showPerformInteractionChoiceSet(with manager: SDLManager) {
        manager.send(request: MenuManager.createPerformInteraction()) { (_, response, error) in
            guard response?.resultCode == .success else {
                print("The show interaction choice set request failed: \(String(describing: error?.localizedDescription))")
                return
            }

            if response?.resultCode == .timedOut {
                // The menu timed out before the user could select an item
                manager.send(AudioManager.youMissedTTS())
            } else if response?.resultCode == .success {
                // The user selected an item in the menu
                manager.send(AudioManager.goodJobTTS())
            }
        }
    }
}

// MARK: - Add Commands for Root Menu

private extension MenuManager {
    class func addCommandSpeakName(with manager: SDLManager) -> SDLAddCommand {
        return SDLAddCommand(id: 200, vrCommands: [ACSpeakAppNameMenuName], menuName: ACSpeakAppNameMenuName, handler: { (onCommand) in
            manager.send(request: AudioManager.appNameTTS(), responseHandler: { (_, response, error) in
                if response?.resultCode != .success {
                    print("Error sending the speak app name request: \(error != nil ? error!.localizedDescription : "no error message")")
                }
            })
        })
    }

    class func addCommandGetVehicleData(with manager: SDLManager) -> SDLAddCommand {
        return SDLAddCommand(id: 201, vrCommands: [ACGetVehicleDataMenuName], menuName: ACGetVehicleDataMenuName, handler: { (onCommand) in
            ProxyManager.sendGetVehicleData(with: manager)
        })
    }

    class func addCommandShowPerformInteraction(with manager: SDLManager) -> SDLAddCommand {
        return SDLAddCommand(id: 202, vrCommands: [ACShowChoiceSetMenuName], menuName: ACShowChoiceSetMenuName, handler: { (onCommand) in
            showPerformInteractionChoiceSet(with: manager)
        })
    }
}
