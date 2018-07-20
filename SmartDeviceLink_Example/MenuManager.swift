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
    /// Creates and returns the menu items
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: An array of SDLAddCommand objects
    class func allMenuItems(with manager: SDLManager, choiceSetManager: PerformInteractionManager) -> [SDLMenuCell] {
        return [menuCellSpeakName(with: manager),
                menuCellGetAllVehicleData(with: manager),
                menuCellShowPerformInteraction(with: manager, choiceSetManager: choiceSetManager),
                menuCellRecordInCarMicrophoneAudio(with: manager),
                menuCellDialNumber(with: manager),
                menuCellWithSubmenu(with: manager)]
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
        return SDLMenuCell(title: ACSpeakAppNameMenuName, icon: SDLArtwork(image: UIImage(named: SpeakBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: [ACSpeakAppNameMenuName], handler: { _ in
            manager.send(request: SDLSpeak(tts: ExampleAppNameTTS), responseHandler: { (_, response, error) in
                guard response?.resultCode == .success else { return }
                SDLLog.e("Error sending the Speak RPC: \(error?.localizedDescription ?? "no error message")")
            })
        })
    }

    /// Menu item that, when selected, shows a submenu with all possible vehicle data types
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellGetAllVehicleData(with manager: SDLManager) -> SDLMenuCell {
        let submenuItems = allVehicleDataTypes.map { submenuName in
            SDLMenuCell(title: submenuName, icon: nil, voiceCommands: nil, handler: { triggerSource in
                VehicleDataManager.getAllVehicleData(with: manager, triggerSource: triggerSource, vehicleDataType: submenuName)
            })
        }

        return SDLMenuCell(title: ACGetAllVehicleDataMenuName, icon: SDLArtwork(image: UIImage(named: CarBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), subCells: submenuItems)
    }

    /// A list of all possible vehicle data types
    static var allVehicleDataTypes: [String] {
        return [ACAccelerationPedalPositionMenuName, ACAirbagStatusMenuName, ACBeltStatusMenuName, ACBodyInformationMenuName, ACClusterModeStatusMenuName, ACDeviceStatusMenuName, ACDriverBrakingMenuName, ACECallInfoMenuName, ACElectronicParkBrakeStatus, ACEmergencyEventMenuName, ACEngineOilLifeMenuName, ACEngineTorqueMenuName, ACExternalTemperatureMenuName, ACFuelLevelMenuName, ACFuelLevelStateMenuName, ACFuelRangeMenuName, ACGPSMenuName, ACHeadLampStatusMenuName, ACInstantFuelConsumptionMenuName, ACMyKeyMenuName, ACOdometerMenuName, ACPRNDLMenuName, ACRPMMenuName, ACSpeedMenuName, ACSteeringWheelAngleMenuName, ACTirePressureMenuName, ACTurnSignalMenuName, ACVINMenuName, ACWiperStatusMenuName]
    }

    /// Menu item that shows a custom menu (i.e. a Perform Interaction Choice Set) when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellShowPerformInteraction(with manager: SDLManager, choiceSetManager: PerformInteractionManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACShowChoiceSetMenuName, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: [ACShowChoiceSetMenuName], handler: { triggerSource in
            choiceSetManager.show(from: triggerSource)
        })
    }

    /// Menu item that starts recording sounds via the in-car microphone when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellRecordInCarMicrophoneAudio(with manager: SDLManager) -> SDLMenuCell {
        if #available(iOS 10.0, *) {
            let audioManager = AudioManager(sdlManager: manager)
            return SDLMenuCell(title: ACRecordInCarMicrophoneAudioMenuName, icon: SDLArtwork(image: UIImage(named: MicrophoneBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: [ACRecordInCarMicrophoneAudioMenuName], handler: { _ in
                audioManager.startRecording()
            })
        }

        return SDLMenuCell(title: ACRecordInCarMicrophoneAudioMenuName, icon: SDLArtwork(image: UIImage(named: SpeakBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: [ACRecordInCarMicrophoneAudioMenuName], handler: { _ in
            manager.send(AlertManager.alertWithMessageAndCloseButton("Speech recognition feature only available on iOS 10+"))
        })
    }

    /// Menu item that dials a phone number when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellDialNumber(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACDialPhoneNumberMenuName, icon: SDLArtwork(image: UIImage(named: PhoneBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: [ACDialPhoneNumberMenuName], handler: { _ in
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
        for i in 0 ..< 10 {
            let submenuTitle = "Submenu Item \(i)"
            submenuItems.append(SDLMenuCell(title: submenuTitle, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), voiceCommands: nil, handler: { (triggerSource) in
                let message = "\(submenuTitle) selected!"
                switch triggerSource {
                case .menu:
                    manager.send(AlertManager.alertWithMessageAndCloseButton(message))
                case .voiceRecognition:
                    manager.send(SDLSpeak(tts: message))
                default: break
                }
            }))
        }
        
        return SDLMenuCell(title: ACSubmenuMenuName, icon: SDLArtwork(image: #imageLiteral(resourceName: "choice_set").withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), subCells: submenuItems)
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
