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
    
    
    init(sdlManager: SDLManager) {
        self.sdlManager = sdlManager
        /// Retrieve remote control information and store module ids
        self.sdlManager.systemCapabilityManager.subscribe(capabilityType: .remoteControl) { (capability, subscribed, error) in
            guard capability?.remoteControlCapability != nil else { return }
            self.remoteControlCapabilities = capability?.remoteControlCapability
            
            
            let firstClimateModule = self.remoteControlCapabilities.climateControlCapabilities?.first
            let moduleId = firstClimateModule?.moduleInfo?.moduleId
            
            self.climateModuleId = moduleId
            print("Climate Control Module Id ------------------------------------------------------------------------- \(self.climateModuleId ?? "Missing")")

            /// Get Consent to control module
            let getInteriorVehicleDataConsent = SDLGetInteriorVehicleDataConsent(moduleType: .climate, moduleIds: [self.climateModuleId])
            self.sdlManager.send(request: getInteriorVehicleDataConsent, responseHandler: { (request, response, error) in
                guard let res = response as? SDLGetInteriorVehicleDataConsentResponse else { return }
                guard let allowed = res.allowed else { return }
                let boolAllowed = allowed.map({ (bool) -> Bool in
                    return bool.boolValue
                })
                
                self.consent = boolAllowed
                
                self.showClimateControl()
            })
        }
    }
    
    private func subscribeVehicleData() {
        sdlManager.subscribe(to: .SDLDidReceiveInteriorVehicleData) { (message) in
            guard let onInteriorVehicleData = message as? SDLOnInteriorVehicleData else { return }
            
            print("Climate Data Changing")
            print(onInteriorVehicleData.moduleData.climateControlData as Any)
        }
    }
    
    private func subscribeClimateData() {
        let getInteriorVehicleData = SDLGetInteriorVehicleData(andSubscribeToModuleType: .climate, moduleId: climateModuleId)
        self.sdlManager.send(request: getInteriorVehicleData) { (req, res, err) in
            guard let response = res as? SDLGetInteriorVehicleDataResponse else { return }
            
            print(response)
        }
    }
    
    func turnOnAC() {
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
    
    func turnOffAC() {
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
    
    func showClimateControl() {
        let screenManager = self.sdlManager.screenManager
        screenManager.beginUpdates()
        
        screenManager.textField1 = "Climate Control Data"
        screenManager.textField2 = "Press Buttons"
        screenManager.textField3 = "Remote Control"
        
        self.subscribeVehicleData()
        self.subscribeClimateData()
        
        
        screenManager.changeLayout(SDLTemplateConfiguration(predefinedLayout: .nonMedia)) { err in
            // This listener will be ignored, and will use the handler set in the endUpdates call.
        }
        
        let acOnButton = SDLSoftButtonObject(name: "AC On", text: "AC On", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
            
            self.turnOnAC()
        }
        
        let acOffButton = SDLSoftButtonObject(name: "AC Off", text: "AC Off", artwork: nil) { (buttonPress, buttonEvent) in
            guard buttonPress != nil else { return }
                        
            self.turnOffAC()
        }
        
        screenManager.softButtonObjects = [acOnButton, acOffButton]
                
        screenManager.endUpdates { error in
            if error != nil {
                // Print out the error if there is one and return early
                print("Issue updating UI")
                return
            }
        }
    }
}
