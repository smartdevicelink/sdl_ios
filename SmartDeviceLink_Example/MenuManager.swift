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

    /// Creates and returns the menu items
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of SDLAddCommand objects
    class func allMenuItems(with manager: SDLManager) -> [SDLMenuCell] {
        return [menuCellSpeakName(with: manager), menuCellGetVehicleSpeed(with: manager), menuCellShowPerformInteraction(with: manager), menuCellRecordInCarMicrophoneAudio(with: manager), menuCellDialNumber(with: manager), menuCellWithSubmenu(with: manager)]
    }

    /// Creates and returns the voice commands. The voice commands are menu items that are selected using the voice recognition system.
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of SDLVoiceCommand objects
    class func allVoiceMenuItems(with manager: SDLManager) -> [SDLVoiceCommand] {
        guard manager.systemCapabilityManager.vrCapability else {
            SDLLog.e("The head unit does not support voice recognition")
            return []
        }
        return [voiceCommandStart(with: manager), voiceCommandStop(with: manager)]
    }
}

// MARK: - Root Menu

private extension MenuManager {
    /// Menu item that speaks the app name when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellSpeakName(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACSpeakAppNameMenuName, icon: SDLArtwork(image: UIImage(named: SpeakBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACSpeakAppNameMenuName], handler: { (triggerSource) in
            manager.send(request: SDLSpeak(tts: ExampleAppNameTTS), responseHandler: { (_, response, error) in
                guard response?.resultCode == .success else { return }
                SDLLog.e("Error sending the Speak RPC: \(error?.localizedDescription ?? "no error message")")
            })
        })
    }

    /// Menu item that requests vehicle data when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellGetVehicleSpeed(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACGetVehicleDataMenuName, icon: SDLArtwork(image: UIImage(named: CarBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACGetVehicleDataMenuName], handler: { (triggerSource) in
            VehicleDataManager.getVehicleSpeed(with: manager)
        })
    }

    /// Menu item that shows a custom menu (i.e. a Perform Interaction Choice Set) when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellShowPerformInteraction(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACShowChoiceSetMenuName, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACShowChoiceSetMenuName], handler: { (triggerSource) in
            showPerformInteractionChoiceSet(with: manager)
        })
    }

    /// Menu item that starts recording sounds via the in-car microphone when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellRecordInCarMicrophoneAudio(with manager: SDLManager) -> SDLMenuCell {
        if #available(iOS 10.0, *) {
            let audioManager = AudioManager(sdlManager: manager)
            return SDLMenuCell(title: ACRecordInCarMicrophoneAudioMenuName, icon: SDLArtwork(image: UIImage(named: MicrophoneBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACRecordInCarMicrophoneAudioMenuName], handler: { (triggerSource) in
                audioManager.startRecording()
            })
        }

        return SDLMenuCell(title: ACRecordInCarMicrophoneAudioMenuName, icon: SDLArtwork(image: UIImage(named: SpeakBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACRecordInCarMicrophoneAudioMenuName], handler: { (triggerSource) in
            manager.send(AlertManager.alertWithMessageAndCloseButton("Speech recognition feature only available on iOS 10+"))
        })
    }

    /// Menu item that dials a phone number when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellDialNumber(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACDialPhoneNumberMenuName, icon: SDLArtwork(image: UIImage(named: PhoneBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [ACDialPhoneNumberMenuName], handler: { (triggerSource) in
            guard RPCPermissionsManager.isDialNumberRPCAllowed(with: manager) else {
                manager.send(AlertManager.alertWithMessageAndCloseButton("This app does not have the required permissions to dial a number"))
                return
            }

            VehicleDataManager.checkPhoneCallCapability(manager: manager, phoneNumber:"555-555-5555")
        })
    }

    /// Menu item that opens a submenu when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellWithSubmenu(with manager: SDLManager) -> SDLMenuCell {
        var submenuItems = [SDLMenuCell]()
        for i in 0..<75 {
            let submenuTitle = "Submenu Item \(i)"
            submenuItems.append(SDLMenuCell(title: submenuTitle, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!, persistent: true, as: .PNG), voiceCommands: [submenuTitle, "Item \(i)", "\(i)"], handler: { (triggerSource) in
                manager.send(AlertManager.alertWithMessageAndCloseButton("Submenu item \(i) selected!"))
            }))
        }

        return SDLMenuCell(title: "Submenu", subCells: submenuItems)
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

// MARK: - Menu Voice Commands

private extension MenuManager {
    /// Voice command menu item that shows an alert when triggered via the VR system
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLVoiceCommand object
    class func voiceCommandStart(with manager: SDLManager) -> SDLVoiceCommand {
        return SDLVoiceCommand(voiceCommands: [VCStart], handler: {
            manager.send(AlertManager.alertWithMessageAndCloseButton("\(VCStart) voice command selected!"))
        })
    }

    /// Voice command menu item that shows an alert when triggered via the VR system
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLVoiceCommand object
    class func voiceCommandStop(with manager: SDLManager) -> SDLVoiceCommand {
        return SDLVoiceCommand(voiceCommands: [VCStop], handler: {
            manager.send(AlertManager.alertWithMessageAndCloseButton("\(VCStop) voice command selected!"))
        })
    }
}
