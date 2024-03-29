//
//  RemoteControlManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Beharry, Justin (J.S.) on 7/28/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class RemoteControlManager {
    private let sdlManager: SDLManager
    private let homeButtons: [SDLSoftButtonObject]
    private var remoteControlCapabilities: SDLRemoteControlCapabilities?
    private var climateModuleId: String?
    private var hasConsent: Bool?
    private var climateData: SDLClimateControlData?

    let isEnabled: Bool
    var climateDataString: String {
            """
            AC: \(optionalNumberBoolToString(climateData?.acEnable))
            AC Max: \(optionalNumberBoolToString(climateData?.acMaxEnable))
            Auto Mode: \(optionalNumberBoolToString(climateData?.autoModeEnable))
            Circulate Air: \(optionalNumberBoolToString(climateData?.circulateAirEnable))
            Climate: \(optionalNumberBoolToString(climateData?.climateEnable))
            Current Temperature: \(optionalTemperatureToString(climateData?.currentTemperature))
            Defrost Zone: \(optionalSDLEnumToString(climateData?.defrostZone?.rawValue))
            Desired Temperature: \(optionalTemperatureToString(climateData?.desiredTemperature))
            Dual Mode: \(optionalNumberBoolToString(climateData?.dualModeEnable))
            Fan Speed: \(optionalNumberToString(climateData?.fanSpeed))
            Heated Mirrors: \(optionalNumberBoolToString(climateData?.heatedMirrorsEnable))
            Heated Rears Window: \(optionalNumberBoolToString(climateData?.heatedRearWindowEnable))
            Heated Steering: \(optionalNumberBoolToString(climateData?.heatedSteeringWheelEnable))
            Heated Windshield: \(optionalNumberBoolToString(climateData?.heatedWindshieldEnable))
            Ventilation: \(optionalSDLEnumToString(climateData?.ventilationMode?.rawValue))
            """
    }

    /// Initialize the RemoteControlManager Object
    ///
    /// - Parameters:
    ///     - sdlManager: The SDL Manager.
    ///     - enabled: Permission from the proxy manager to access remote control data
    ///     - homeButton: An array of SDLSoftButtonObjects that remote control manager can reset to.
    init(sdlManager: SDLManager, enabled: Bool, homeButtons: [SDLSoftButtonObject]) {
        self.sdlManager = sdlManager
        self.isEnabled = enabled
        self.homeButtons = homeButtons
    }

    func start() {
        if !self.isEnabled {
            return SDLLog.w("Missing permissions for Remote Control Manager. Example remote control works only on TCP.")
        }

        // Retrieve remote control information and store module ids
        self.sdlManager.systemCapabilityManager.subscribe(capabilityType: .remoteControl) { (capability, subscribed, error) in
            guard capability?.remoteControlCapability != nil else {
                return SDLLog.e("SDL errored getting remote control module information: \(String(describing: error))")
            }
            self.remoteControlCapabilities = capability?.remoteControlCapability

            let firstClimateModule = self.remoteControlCapabilities?.climateControlCapabilities?.first
            let moduleId = firstClimateModule?.moduleInfo?.moduleId
            self.climateModuleId = moduleId

            // Get Consent to control module
            let getInteriorVehicleDataConsent = SDLGetInteriorVehicleDataConsent(moduleType: .climate, moduleIds: [self.climateModuleId!])
            self.sdlManager.send(request: getInteriorVehicleDataConsent, responseHandler: { (request, response, error) in
                guard let response = response as? SDLGetInteriorVehicleDataConsentResponse else {
                    return SDLLog.e("SDL errored getting remote control consent: \(String(describing: error))");
                }
                guard let allowed = response.allowed?.first?.boolValue else { return }

                self.hasConsent = allowed

                // initialize climate data and setup subscription
                if self.hasConsent == true {
                    self.initializeClimateData()
                    self.subscribeClimateControlData()
                }
            })
        }
    }

    /// Displays Buttons for the user to control the climate
    func showClimateControl() {
        // Check that the climate module id has been set and consent has been given
        guard climateModuleId != nil && hasConsent == true else {
            return AlertManager.sendAlert(textField1: "The climate module id was not set or consent was not given", sdlManager: self.sdlManager)
        }
        self.sdlManager.screenManager.softButtonObjects = climateButtons
    }

    private func optionalNumberBoolToString(_ number: NSNumber?) -> String {
        guard let number = number else { return "Unknown" }
        return number.boolValue ? "On" : "Off"
    }

    private func optionalNumberToString(_ number: NSNumber?) -> String {
        guard let number = number else { return "Unknown" }
        return number.stringValue
    }

    private func optionalTemperatureToString(_ temperature: SDLTemperature?) -> String {
        guard let temperature = temperature else { return "Unknown" }
        return temperature.description
    }

    private func optionalSDLEnumToString(_ sdlEnum: SDLEnum?) -> String {
        guard let sdlEnum = sdlEnum else { return "Unknown" }
        return sdlEnum.rawValue
    }

    private func initializeClimateData() {
        // Check that the climate module id has been set and consent has been given
        guard climateModuleId != nil && hasConsent == true else {
            return AlertManager.sendAlert(textField1: "The climate module id was not set or consent was not given", sdlManager: self.sdlManager)
        }

        let getInteriorVehicleData =  SDLGetInteriorVehicleData(moduleType: .climate, moduleId: self.climateModuleId!)
        self.sdlManager.send(request: getInteriorVehicleData) { (req, res, err) in
            guard let response = res as? SDLGetInteriorVehicleDataResponse else { return }
            self.climateData = response.moduleData?.climateControlData
        }
    }

    private func subscribeClimateControlData() {
        // Start the subscription to remote control data
        sdlManager.subscribe(to: .SDLDidReceiveInteriorVehicleData) { (message) in
            guard let onInteriorVehicleData = message as? SDLOnInteriorVehicleData else { return }
            self.climateData = onInteriorVehicleData.moduleData.climateControlData
        }

        // Start the subscription to climate data
        let getInteriorVehicleData = SDLGetInteriorVehicleData(andSubscribeToModuleType: .climate, moduleId: self.climateModuleId!)
        sdlManager.send(request: getInteriorVehicleData) { (req, res, err) in
            guard let response = res as? SDLGetInteriorVehicleDataResponse, response.success.boolValue == true else {
                return SDLLog.e("SDL errored trying to subscribe to climate data: \(String(describing: err))")
            }
            SDLLog.d("Subscribed to climate control data");
        }
    }

    private func turnOnAC() {
        let climateControlData = SDLClimateControlData(dictionary: [
            "acEnable": true
        ])
        let moduleData = SDLModuleData(climateControlData: climateControlData)
        let setInteriorVehicleData = SDLSetInteriorVehicleData(moduleData: moduleData)

        self.sdlManager.send(request: setInteriorVehicleData) { (request, response, error) in
            guard response?.success.boolValue == true else {
                return SDLLog.e("SDL errored trying to turn on climate AC: \(String(describing: error))")
            }
        }
    }

    private func turnOffAC() {
        let climateControlData = SDLClimateControlData(dictionary: [
            "acEnable": false
        ])
        let moduleData = SDLModuleData(climateControlData: climateControlData)
        let setInteriorVehicleData = SDLSetInteriorVehicleData(moduleData: moduleData)

        self.sdlManager.send(request: setInteriorVehicleData) { (request, response, error) in
            guard response?.success.boolValue == true else {
                return SDLLog.e("SDL errored trying to turn off climate AC: \(String(describing: error))")
            }
        }
    }

    // An array of button objects to control the climate
    private var climateButtons : [SDLSoftButtonObject] {
        let acOnButton = SDLSoftButtonObject(name: "AC On", text: "AC On", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.turnOnAC()
        }

        let acOffButton = SDLSoftButtonObject(name: "AC Off", text: "AC Off", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.turnOffAC()
        }

        let acMaxToggle = SDLSoftButtonObject(name: "AC Max", text: "AC Max", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let remoteButtonPress = SDLButtonPress(buttonName: .acMax, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: remoteButtonPress) { (request, response, error) in
                guard response?.success.boolValue == true else {
                    return SDLLog.e("SDL errored toggling AC Max with remote button press: \(String(describing: error))")
                }
            }
        }

        let temperatureDecreaseButton = SDLSoftButtonObject(name: "Temperature Decrease", text: "Temperature -", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let remoteButtonPress = SDLButtonPress(buttonName: .tempDown, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: remoteButtonPress) { (request, response, error) in
                guard response?.success.boolValue == true else {
                    return SDLLog.e("SDL errored decreasing target climate temperature with remote button: \(String(describing: error))")
                }
            }
        }

        let temperatureIncreaseButton = SDLSoftButtonObject(name: "Temperature Increase", text: "Temperature +", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let remoteButtonPress = SDLButtonPress(buttonName: .tempUp, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: remoteButtonPress) { (request, response, error) in
                guard response?.success.boolValue == true else {
                    return SDLLog.e("SDL errored increasing target climate temperature with remote button:: \(String(describing: error))")
                }
            }
        }

        let backToHomeButton = SDLSoftButtonObject(name: "Home", text: "Back to Home", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.sdlManager.screenManager.softButtonObjects = self.homeButtons
            self.sdlManager.screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .nonMedia))
        }

        return [acOnButton, acOffButton, acMaxToggle, temperatureDecreaseButton, temperatureIncreaseButton, backToHomeButton]
    }
}
