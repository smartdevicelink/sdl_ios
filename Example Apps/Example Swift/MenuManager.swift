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
    class func allMenuItems(with manager: SDLManager, choiceSetManager: PerformInteractionManager, remoteManager: RemoteControlManager) -> [SDLMenuCell] {
        return [menuCellSpeakName(with: manager),
                menuCellGetAllVehicleData(with: manager),
                menuCellRemoteControl(with: manager, remoteManager: remoteManager),
                menuCellShowPerformInteraction(with: manager, choiceSetManager: choiceSetManager),
                sliderMenuCell(with: manager),
                scrollableMessageMenuCell(with: manager),
                menuCellRecordInCarMicrophoneAudio(with: manager),
                menuCellDialNumber(with: manager),
                menuCellChangeTemplate(with: manager),
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
        return SDLMenuCell(title: ACSpeakAppNameMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: SpeakBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, voiceCommands: [ACSpeakAppNameMenuName], handler: { _ in
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
            SDLMenuCell(title: submenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(staticIcon: .settings), secondaryArtwork: nil, voiceCommands: nil, handler: { triggerSource in
                VehicleDataManager.getAllVehicleData(with: manager, triggerSource: triggerSource, vehicleDataType: submenuName)
            })
        }

        return SDLMenuCell(title: ACGetAllVehicleDataMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: CarBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, submenuLayout: .tiles, subCells: submenuItems)
    }

    /// A list of all possible vehicle data types
    static var allVehicleDataTypes: [String] {
        return [ACAccelerationPedalPositionMenuName, ACAirbagStatusMenuName, ACBeltStatusMenuName, ACBodyInformationMenuName, ACClusterModeStatusMenuName, ACDeviceStatusMenuName, ACDriverBrakingMenuName, ACECallInfoMenuName, ACElectronicParkBrakeStatus, ACEmergencyEventMenuName, ACEngineOilLifeMenuName, ACEngineTorqueMenuName, ACFuelLevelMenuName, ACFuelLevelStateMenuName, ACFuelRangeMenuName, ACGearStatusMenuName, ACGPSMenuName, ACHeadLampStatusMenuName, ACInstantFuelConsumptionMenuName, ACMyKeyMenuName, ACOdometerMenuName, ACPRNDLMenuName, ACRPMMenuName, ACSpeedMenuName, ACSteeringWheelAngleMenuName, ACTirePressureMenuName, ACTurnSignalMenuName, ACVINMenuName, ACWiperStatusMenuName]
    }

    /// Menu item that shows a custom menu (i.e. a Perform Interaction Choice Set) when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellShowPerformInteraction(with manager: SDLManager, choiceSetManager: PerformInteractionManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACShowChoiceSetMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, voiceCommands: [ACShowChoiceSetMenuName], handler: { triggerSource in
            choiceSetManager.show(from: triggerSource)
        })
    }

    /// Menu item that starts recording sounds via the in-car microphone when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellRecordInCarMicrophoneAudio(with manager: SDLManager) -> SDLMenuCell {
        let audioManager = AudioManager(sdlManager: manager)
        return SDLMenuCell(title: ACRecordInCarMicrophoneAudioMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: MicrophoneBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, voiceCommands: [ACRecordInCarMicrophoneAudioMenuName], handler: { _ in
            audioManager.startRecording()
        })
    }

    /// Menu item that dials a phone number when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellDialNumber(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACDialPhoneNumberMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: PhoneBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, voiceCommands: [ACDialPhoneNumberMenuName], handler: { _ in
            guard RPCPermissionsManager.isDialNumberRPCAllowed(with: manager) else {
                AlertManager.sendAlert(textField1: AlertDialNumberPermissionsWarningText, sdlManager: manager)
                return
            }

            VehicleDataManager.checkPhoneCallCapability(manager: manager, phoneNumber:"555-555-5555")
        })
    }
    
    /// Menu item that changes the default template
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellChangeTemplate(with manager: SDLManager) -> SDLMenuCell {
    
        // Lets give an example of 2 templates
        var submenuItems = [SDLMenuCell]()
        let errorMessage = "Changing the template failed"
        
        // Non-Media
        let submenuTitleNonMedia = "Non - Media (Default)"
        submenuItems.append(SDLMenuCell(title: submenuTitleNonMedia, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: nil, handler: { (triggerSource) in
            manager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .nonMedia)) { err in
                if err != nil {
                    AlertManager.sendAlert(textField1: errorMessage, sdlManager: manager)
                    return
                }
            }
        }))
        
        // Graphic with Text
        let submenuTitleGraphicText = "Graphic With Text"
        submenuItems.append(SDLMenuCell(title: submenuTitleGraphicText, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: nil, handler: { (triggerSource) in
            manager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .graphicWithText)) { err in
                if err != nil {
                    AlertManager.sendAlert(textField1: errorMessage, sdlManager: manager)
                    return
                }
            }
        }))
        
        return SDLMenuCell(title: ACSubmenuTemplateMenuName, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, submenuLayout: .list, subCells: submenuItems)
    }

    /// Menu item that opens a submenu when selected
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLMenuCell object
    class func menuCellWithSubmenu(with manager: SDLManager) -> SDLMenuCell {
        var submenuItems = [SDLMenuCell]()
        for i in 0 ..< 10 {
            let submenuTitle = "Submenu Item \(i)"
            submenuItems.append(SDLMenuCell(title: submenuTitle, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: UIImage(named: MenuBWIconImageName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, voiceCommands: nil, handler: { (triggerSource) in
                let message = "\(submenuTitle) selected!"
                switch triggerSource {
                case .menu:
                    AlertManager.sendAlert(textField1: message, sdlManager: manager)
                case .voiceRecognition:
                    manager.send(SDLSpeak(tts: message))
                default: break
                }
            }))
        }
        
        return SDLMenuCell(title: ACSubmenuMenuName, secondaryText: nil, tertiaryText: nil, icon: SDLArtwork(image: #imageLiteral(resourceName: "choice_set").withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG), secondaryArtwork: nil, submenuLayout: .list, subCells: submenuItems)
    }

    private class func sliderMenuCell(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACSliderMenuName, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: [ACSliderMenuName], handler: { _ in
            let slider = SDLSlider(numTicks: 3, position: 1, sliderHeader: "Select a letter", sliderFooters: ["A", "B", "C"], timeout: 3000)
            manager.send(request: slider, responseHandler: { (request, response, error) in
                guard let response = response else { return }
                guard response.resultCode == .success else {
                    if response.resultCode == .timedOut {
                        AlertManager.sendAlert(textField1: AlertSliderTimedOutWarningText, sdlManager: manager)
                    } else if response.resultCode == .aborted {
                        AlertManager.sendAlert(textField1: AlertSliderCancelledWarningText, sdlManager: manager)
                    } else {
                        AlertManager.sendAlert(textField1: AlertSliderGeneralWarningText, sdlManager: manager)
                    }
                    return
                }
            })
        })
    }

    private class func scrollableMessageMenuCell(with manager: SDLManager) -> SDLMenuCell {
        return SDLMenuCell(title: ACScrollableMessageMenuName, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: [ACScrollableMessageMenuName], handler: { _ in
            let scrollableMessage = SDLScrollableMessage(message: "This is a scrollable message\nIt can contain many lines")
            manager.send(request: scrollableMessage, responseHandler: { (request, response, error) in
                guard let response = response else { return }
                guard response.resultCode == .success else {
                    if response.resultCode == .timedOut {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageTimedOutWarningText, sdlManager: manager)
                    } else if response.resultCode == .aborted {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageCancelledWarningText, sdlManager: manager)
                    } else {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageGeneralWarningText, sdlManager: manager)
                    }
                    return
                }
            })
        })
    }

    /// Menu item that shows remote control example
    ///
    /// - Parameters:
    ///      - manager: The SDL Manager
    ///      - remoteManager: The manager for controling and viewing remote control data
    /// - Returns: A SDLMenuCell object
    class func menuCellRemoteControl(with manager: SDLManager, remoteManager: RemoteControlManager) -> SDLMenuCell {
        let remoteControlIcon = SDLArtwork(image: UIImage(named: RemoteControlIconName)!.withRenderingMode(.alwaysTemplate), persistent: true, as: .PNG)

        // Clicking on cell shows alert message when remote control permissions are disabled
        guard remoteManager.isEnabled else {
            return SDLMenuCell(title: ACRemoteMenuName, secondaryText: nil, tertiaryText: nil, icon: remoteControlIcon, secondaryArtwork: nil, voiceCommands: nil, handler: { _ in
                AlertManager.sendAlert(textField1: AlertRemoteControlNotEnabledWarningText, sdlManager: manager)
            })
        }

        var submenuItems = [SDLMenuCell]()
        // Climate Control Menu
        submenuItems.append(SDLMenuCell(title: ACRemoteControlClimateMenuName, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: nil, handler: { (triggerSource) in
            manager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .tilesOnly)) { err in
                if let error = err {
                    AlertManager.sendAlert(textField1: error.localizedDescription, sdlManager: manager)
                    return
                }
                remoteManager.showClimateControl()
            }
        }))

        // View Climate Data
        submenuItems.append(SDLMenuCell(title: ACRemoteViewClimateMenuName, secondaryText: nil, tertiaryText: nil, icon: nil, secondaryArtwork: nil, voiceCommands: nil, handler: { _ in
            let climateDataMessage = SDLScrollableMessage(message: remoteManager.climateDataString)
            manager.send(request: climateDataMessage, responseHandler: { (request, response, error) in
                guard let response = response else { return }
                guard response.resultCode == .success else {
                    if response.resultCode == .timedOut {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageTimedOutWarningText, sdlManager: manager)
                    } else if response.resultCode == .aborted {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageCancelledWarningText, sdlManager: manager)
                    } else {
                        AlertManager.sendAlert(textField1: AlertScrollableMessageGeneralWarningText, sdlManager: manager)
                    }
                    return
                }
            })
        }))

        return SDLMenuCell(title: ACRemoteMenuName, secondaryText: nil, tertiaryText: nil, icon: remoteControlIcon, secondaryArtwork: nil, submenuLayout: .list, subCells: submenuItems)
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
            AlertManager.sendAlert(textField1: "\(VCStart) voice command selected!", sdlManager: manager)
        })
    }

    /// Voice command menu item that shows an alert when triggered via the VR system
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: A SDLVoiceCommand object
    class func voiceCommandStop(with manager: SDLManager) -> SDLVoiceCommand {
        return SDLVoiceCommand(voiceCommands: [VCStop], handler: {
            AlertManager.sendAlert(textField1: "\(VCStop) voice command selected!", sdlManager: manager)
        })
    }
}
