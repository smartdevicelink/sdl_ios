//
//  RemoteControlManager.swift
//  SmartDeviceLink-Example-Swift
//
//  Created by Beharry, Justin (J.S.) on 7/28/22.
//  Copyright © 2022 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class RemoteControlManager {
    private var sdlManager: SDLManager!
    private var remoteControlCapabilities: SDLRemoteControlCapabilities!
    private var climateModuleId: String!
    private var consent: [Bool]!
    private var climateData: SDLClimateControlData!

    public var climateDataString: String! {
        get {
            let climateString = """
            AC Enable \(climateData.acEnable!.boolValue ? "On" : "Off")
            AC Max Enable \(climateData.acMaxEnable!.boolValue ? "On" : "Off")
            Auto Mode Enable \(climateData.autoModeEnable!.boolValue ? "On": "Off")
            Circulate Air Enable \(climateData.circulateAirEnable!.boolValue ? "On" : "Off")
            Climate Enable \(climateData.climateEnable!.boolValue ? "On" : " Off")
            Current Temperature \(climateData.currentTemperature?.description ?? "Nil")
            Defrost Zone \(climateData.defrostZone?.rawValue.rawValue ?? "Nil")
            Desired Temperature \(climateData.desiredTemperature?.description ?? "Nil")
            Dual Mode Enable \(climateData.dualModeEnable!.boolValue ? "On" : "Off")
            Fan Speed \(climateData.fanSpeed?.description ?? "Nil")
            Heated Mirrors Enable \(climateData.heatedMirrorsEnable!.boolValue ? "On" : " Off")
            Heated Rears Window Enable \(climateData.heatedRearWindowEnable!.boolValue ? "On" : " Off")
            Heated Steering Enable \(climateData.heatedSteeringWheelEnable!.boolValue ? "On" : " Off")
            Heated Windshield Enable \(climateData.heatedWindshieldEnable!.boolValue ? "On" : " Off")
            Ventilation \(climateData.ventilationMode?.rawValue.rawValue ?? "Nil")
            """
            return climateString
        }
    }

    /// Creates and returns the menu items
    ///
    /// - Parameter sdlManager: The SDL Manager
    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        /// Retrieve remote control information and store module ids
        self.sdlManager.systemCapabilityManager.subscribe(capabilityType: .remoteControl) { (capability, subscribed, error) in
            guard capability?.remoteControlCapability != nil else { return }
            self.remoteControlCapabilities = capability?.remoteControlCapability

            let firstClimateModule = self.remoteControlCapabilities.climateControlCapabilities?.first
            let moduleId = firstClimateModule?.moduleInfo?.moduleId
            self.climateModuleId = moduleId

            /// Get Consent to control module
            let getInteriorVehicleDataConsent = SDLGetInteriorVehicleDataConsent(moduleType: .climate, moduleIds: [self.climateModuleId])
            self.sdlManager.send(request: getInteriorVehicleDataConsent, responseHandler: { (request, response, error) in
                guard let res = response as? SDLGetInteriorVehicleDataConsentResponse else { return }
                guard let allowed = res.allowed else { return }
                let boolAllowed = allowed.map({ (bool) -> Bool in
                    return bool.boolValue
                })

                self.consent = boolAllowed

                // initialize climate data and setup subscription
                if self.consent[0] == true {
                    self.initializeClimateData()
                    self.subscribeVehicleData()
                    self.subscribeClimateControlData()
                }
            })
        }
    }

    /// Displays Buttons for the user to control the climate
    func showClimateControl() {
        /// Check that the climate module id has been set and consent has been given
        if climateModuleId == nil && consent[0] == false {
            AlertManager.sendAlert(textField1: "The climate module id was not set or consent was not given", sdlManager: self.sdlManager)
        }

        let screenManager = self.sdlManager.screenManager
        screenManager.beginUpdates()
        screenManager.softButtonObjects = climateButtons
        screenManager.endUpdates()
    }

    private func initializeClimateData() {
        /// Check that the climate module id has been set and consent has been given
        if climateModuleId == nil && consent[0] == false {
            AlertManager.sendAlert(textField1: "The climate module id was not set or consent was not given", sdlManager: self.sdlManager)
        }

        let getInteriorVehicleData =  SDLGetInteriorVehicleData(moduleType: .climate, moduleId: self.climateModuleId)
        self.sdlManager.send(request: getInteriorVehicleData) { (req, res, err) in
            guard let response = res as? SDLGetInteriorVehicleDataResponse else { return }
            self.climateData = response.moduleData?.climateControlData
        }
    }

    private func subscribeVehicleData() {
        sdlManager.subscribe(to: .SDLDidReceiveInteriorVehicleData) { (message) in
            guard let onInteriorVehicleData = message as? SDLOnInteriorVehicleData else { return }
            self.climateData = onInteriorVehicleData.moduleData.climateControlData
        }
    }

    private func subscribeClimateControlData() {
        let getInteriorVehicleData = SDLGetInteriorVehicleData(andSubscribeToModuleType: .climate, moduleId: self.climateModuleId)
        sdlManager.send(request: getInteriorVehicleData) { (req, res, err) in
            guard let response = res as? SDLGetInteriorVehicleDataResponse else { return }
        }
    }

    private func turnOnAC() {
        let climateDictionary: [String: Any] = [
            "acEnable": true as NSNumber & SDLBool
        ]

        let climateControlData = SDLClimateControlData(dictionary: climateDictionary)
        let moduleData = SDLModuleData(climateControlData: climateControlData)
        let setInteriorVehicleData = SDLSetInteriorVehicleData(moduleData: moduleData)

        self.sdlManager.send(request: setInteriorVehicleData) { (request, response, error) in
            guard response?.success.boolValue == true else { return }
        }
    }

    private func turnOffAC() {
        let climateDictionary: [String: Any] = [
            "acEnable": false as NSNumber & SDLBool
        ]

        let climateControlData = SDLClimateControlData(dictionary: climateDictionary)
        let moduleData = SDLModuleData(climateControlData: climateControlData)
        let setInteriorVehicleData = SDLSetInteriorVehicleData(moduleData: moduleData)

        self.sdlManager.send(request: setInteriorVehicleData) { (request, response, error) in
            guard response?.success.boolValue == true else { return }
        }
    }

    /// Changes multiple climate variables at once
    private func setClimate() {
        let climateDictionary: [String: Any] = [
            "acEnable": true as NSNumber & SDLBool,
            "fanSpeed": NSNumber(100),
            "desiredTemperature": SDLTemperature(fahrenheitValue: 73),
            "ventilationMode": SDLVentilationMode(rawValue: SDLVentilationMode.both.rawValue)
        ]


        let climateControlData = SDLClimateControlData(dictionary: climateDictionary)
        let moduleData = SDLModuleData(climateControlData: climateControlData)
        let setInteriorVehicleData = SDLSetInteriorVehicleData(moduleData: moduleData)

        self.sdlManager.send(request: setInteriorVehicleData) { (request, response, error) in
            guard response?.success.boolValue == true else { return }
        }
    }

    /// An array of button objects to control the climate
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
            let buttonPress = SDLButtonPress(buttonName: .acMax, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: buttonPress) { (request, response, error) in
                guard response?.success.boolValue == true else { return }
            }
        }

        let temperatureDecreaseButton = SDLSoftButtonObject(name: "Temperature Decrease", text: "Temperature -", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let buttonPress = SDLButtonPress(buttonName: .tempDown, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: buttonPress) { (request, response, error) in
                guard response?.success.boolValue == true else { return }
            }
        }

        let temperatureIncreaseButton = SDLSoftButtonObject(name: "Temperature Increase", text: "Temperature +", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            let buttonPress = SDLButtonPress(buttonName: .tempUp, moduleType: .climate, moduleId: self.climateModuleId, buttonPressMode: .short)
            self.sdlManager.send(request: buttonPress) { (request, response, error) in
                guard response?.success.boolValue == true else { return }
            }
        }

        let setClimateButton = SDLSoftButtonObject(name: "Set Climate", text: "Set Climate", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            self.setClimate()
        }

        return [acOnButton, acOffButton, acMaxToggle, temperatureDecreaseButton, temperatureIncreaseButton, setClimateButton]
    }
}
