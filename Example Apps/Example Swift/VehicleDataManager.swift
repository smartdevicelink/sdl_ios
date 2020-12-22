//
//  VehicleDataManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/13/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift


class VehicleDataManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    fileprivate var refreshUIHandler: RefreshUIHandler?
    public fileprivate(set) var vehicleOdometerData: String

    init(sdlManager: SDLManager, refreshUIHandler: RefreshUIHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshUIHandler = refreshUIHandler
        self.vehicleOdometerData = ""
        super.init()

        resetOdometer()
        self.sdlManager.subscribe(to: .SDLDidReceiveVehicleData, observer: self, selector: #selector(vehicleDataNotification(_:)))
    }
}

// MARK: - Subscribe Vehicle Data

extension VehicleDataManager {
    /// Subscribes to odometer data. You must subscribe to a notification with name `SDLDidReceiveVehicleData` to get the new data when the odometer data changes.
    func subscribeToVehicleOdometer() {
        let subscribeToVehicleOdometer = SDLSubscribeVehicleData()
        subscribeToVehicleOdometer.odometer = true as NSNumber & SDLBool
        sdlManager.send(request: subscribeToVehicleOdometer) { [unowned self] (request, response, error) in
            guard let result = response?.resultCode else { return }

            if error != nil {
                SDLLog.e("Error sending Get Vehicle Data RPC: \(error!.localizedDescription)")
            }

            var message = "\(VehicleDataOdometerName): "
            switch result {
            case .success:
                SDLLog.d("Subscribed to vehicle odometer data")
                message += "Subscribed"
            case .disallowed:
                SDLLog.d("Access to vehicle data disallowed")
                message += "Disallowed"
            case .userDisallowed:
                SDLLog.d("Vehicle user disabled access to vehicle data")
                message += "Disabled"
            case .ignored:
                SDLLog.d("Already subscribed to odometer data")
                message += "Subscribed"
            case .dataNotAvailable:
                SDLLog.d("You have permission to access to vehicle data, but the vehicle you are connected to did not provide any data")
                message += "Unknown"
            default:
                SDLLog.e("Unknown reason for failure to get vehicle data: \(error != nil ? error!.localizedDescription : "no error message")")
                message += "Unsubscribed"
                return
            }
            self.vehicleOdometerData = message

            guard let handler = self.refreshUIHandler else { return }
            handler()
        }
    }

    /// Unsubscribes to vehicle odometer data.
    func unsubscribeToVehicleOdometer() {
        let unsubscribeToVehicleOdometer = SDLUnsubscribeVehicleData()
        unsubscribeToVehicleOdometer.odometer = true as NSNumber & SDLBool
        sdlManager.send(request: unsubscribeToVehicleOdometer) { (request, response, error) in
            guard let response = response, response.resultCode == .success else { return }
            self.resetOdometer()
        }
    }

    /// Notification containing the updated vehicle data.
    ///
    /// - Parameter notification: A SDLOnVehicleData notification
    @objc func vehicleDataNotification(_ notification: SDLRPCNotificationNotification) {
        guard let handler = refreshUIHandler, let onVehicleData = notification.notification as? SDLOnVehicleData, let odometer = onVehicleData.odometer else {
            return
        }

        vehicleOdometerData = "\(VehicleDataOdometerName): \(odometer) km"
        handler()
    }

    /// Resets the odometer data
    fileprivate func resetOdometer() {
        vehicleOdometerData = "\(VehicleDataOdometerName): Unsubscribed"
    }
}

// MARK: - Get Vehicle Data

extension VehicleDataManager {
    /// Retreives the current vehicle data
    ///
    /// - Parameters:
    ///   - manager: The SDL manager
    ///   - triggerSource: Whether the menu item was selected by voice or touch
    ///   - parameter: The vehicle data to look for
    class func getAllVehicleData(with manager: SDLManager, triggerSource: SDLTriggerSource, vehicleDataType: String) {
        guard hasPermissionToAccessVehicleData(with: manager) else { return }

        SDLLog.d("App has permission to access vehicle data. Requesting all vehicle data...")
        let getAllVehicleData = SDLGetVehicleData(accelerationPedalPosition: true, airbagStatus: true, beltStatus: true, bodyInformation: true, cloudAppVehicleID: true, clusterModeStatus: true, deviceStatus: true, driverBraking: true, eCallInfo: true, electronicParkBrakeStatus: true, emergencyEvent: true, engineOilLife: true, engineTorque: true, externalTemperature: true, fuelLevel: true, fuelLevelState: true, fuelRange: true, gps: true, headLampStatus: true, instantFuelConsumption: true, myKey: true, odometer: true, prndl: true, rpm: true, speed: true, steeringWheelAngle: true, tirePressure: true, turnSignal: true, vin: true, wiperStatus: true)

        manager.send(request: getAllVehicleData) { (request, response, error) in
            guard didAccessVehicleDataSuccessfully(with: manager, response: response, error: error) else { return }

            var alertTitle: String = ""
            var alertMessage: String = ""

            switch response!.resultCode {
            case .rejected:
                SDLLog.d("The request for vehicle data was rejected")
                alertTitle = "Rejected"
            case .disallowed:
                SDLLog.d("This app does not have the required permissions to access vehicle data")
                alertTitle = "Disallowed"
            case .success, .dataNotAvailable:
                if let vehicleData = response as? SDLGetVehicleDataResponse {
                    alertTitle = vehicleDataType
                    alertMessage = vehicleDataDescription(vehicleData, vehicleDataType: vehicleDataType)
                    SDLLog.d("Request for \(vehicleDataType) vehicle data successful, \(alertMessage)")
                } else {
                    alertTitle = "No vehicle data returned"
                    SDLLog.e(alertTitle)
                }
            default: break
            }

            alertTitle = TextValidator.validateText(alertTitle, length: 25)
            alertMessage = TextValidator.validateText(alertMessage, length: 200)

            if triggerSource == .menu {
                let title = !alertTitle.isEmpty ? alertTitle : "No Vehicle Data Available"
                let detailMessage = !alertMessage.isEmpty ? alertMessage : nil
                let alert = AlertManager.alertWithMessageAndCloseButton(title,
                    textField2: detailMessage)
                manager.send(alert)
            } else {
                let spokenAlert = !alertMessage.isEmpty ? alertMessage : alertTitle
                manager.send(SDLSpeak(tts: spokenAlert))
            }
        }
    }

    /// Returns a description of the vehicle data.
    ///
    /// - Parameters:
    ///   - vehicleData: All vehicle data
    ///   - vehicleDataType: The vehicle data to get a description of
    /// - Returns: A description of the vehicle data
    class func vehicleDataDescription(_ vehicleData: SDLGetVehicleDataResponse, vehicleDataType: String) -> String {
        let notAvailable = "Vehicle data not available"

        var vehicleDataDescription = ""
        switch vehicleDataType {
        case ACAccelerationPedalPositionMenuName:
            vehicleDataDescription = vehicleData.accPedalPosition?.description ?? notAvailable
        case ACAirbagStatusMenuName:
            vehicleDataDescription = vehicleData.airbagStatus?.description ?? notAvailable
        case ACBeltStatusMenuName:
            vehicleDataDescription = vehicleData.beltStatus?.description ?? notAvailable
        case ACBodyInformationMenuName:
            vehicleDataDescription = vehicleData.bodyInformation?.description ?? notAvailable
        case ACClusterModeStatusMenuName:
            vehicleDataDescription = vehicleData.clusterModeStatus?.description ?? notAvailable
        case ACDeviceStatusMenuName:
            vehicleDataDescription = vehicleData.deviceStatus?.description ?? notAvailable
        case ACDriverBrakingMenuName:
            vehicleDataDescription = vehicleData.driverBraking?.rawValue.rawValue ?? notAvailable
        case ACECallInfoMenuName:
            vehicleDataDescription = vehicleData.eCallInfo?.description ?? notAvailable
        case ACElectronicParkBrakeStatus:
            vehicleDataDescription = vehicleData.electronicParkBrakeStatus?.rawValue.rawValue ?? notAvailable
        case ACEmergencyEventMenuName:
            vehicleDataDescription = vehicleData.emergencyEvent?.description ?? notAvailable
        case ACEngineOilLifeMenuName:
            vehicleDataDescription = vehicleData.engineOilLife?.description ?? notAvailable
        case ACEngineTorqueMenuName:
            vehicleDataDescription = vehicleData.engineTorque?.description ?? notAvailable
        case ACExternalTemperatureMenuName:
            vehicleDataDescription = vehicleData.externalTemperature?.description ?? notAvailable
        case ACFuelLevelMenuName:
            vehicleDataDescription = vehicleData.fuelLevel?.description ?? notAvailable
        case ACFuelLevelStateMenuName:
            vehicleDataDescription = vehicleData.fuelLevel_State?.rawValue.rawValue ?? notAvailable
        case ACFuelRangeMenuName:
            vehicleDataDescription = vehicleData.fuelRange?.description ?? notAvailable
        case ACGPSMenuName:
            vehicleDataDescription = vehicleData.gps?.description ?? notAvailable
        case ACHeadLampStatusMenuName:
            vehicleDataDescription = vehicleData.headLampStatus?.description ?? notAvailable
        case ACInstantFuelConsumptionMenuName:
            vehicleDataDescription = vehicleData.instantFuelConsumption?.description ?? notAvailable
        case ACMyKeyMenuName:
            vehicleDataDescription = vehicleData.myKey?.description ?? notAvailable
        case ACOdometerMenuName:
            vehicleDataDescription = vehicleData.odometer?.description ?? notAvailable
        case ACPRNDLMenuName:
            vehicleDataDescription = vehicleData.prndl?.rawValue.rawValue ?? notAvailable
        case ACSpeedMenuName:
            vehicleDataDescription = vehicleData.speed?.description ?? notAvailable
        case ACSteeringWheelAngleMenuName:
            vehicleDataDescription = vehicleData.steeringWheelAngle?.description ?? notAvailable
        case ACTirePressureMenuName:
            vehicleDataDescription = vehicleData.tirePressure?.description ?? notAvailable
        case ACTurnSignalMenuName:
            vehicleDataDescription = vehicleData.turnSignal?.rawValue.rawValue ?? notAvailable
        case ACVINMenuName:
            vehicleDataDescription = vehicleData.vin?.description ?? notAvailable
        default: break
        }

        return vehicleDataDescription
    }

    /// Checks if the app has the required permissions to access vehicle data
    ///
    /// - Parameter manager: The SDL manager
    /// - Returns: True if the app has permission to access vehicle data, false if not
    class func hasPermissionToAccessVehicleData(with manager: SDLManager) -> Bool {
        SDLLog.d("Checking if app has permission to access vehicle data...")

        guard manager.permissionManager.isRPCNameAllowed(SDLRPCFunctionName.getVehicleData) else {
            let alert = AlertManager.alertWithMessageAndCloseButton("This app does not have the required permissions to access vehicle data")
            manager.send(request: alert)
            return false
        }

        return true
    }

    /// Checks if Core sent back vehicle data
    ///
    /// - Parameters:
    ///   - manager: The SDL manager
    ///   - response: The response from Core
    ///   - error: An error from Core
    /// - Returns: True if Core sent back vehicle data, false if not
    class func didAccessVehicleDataSuccessfully(with manager:SDLManager, response: SDLRPCResponse?, error: Error?) -> Bool {
        SDLLog.d("Checking if Core returned vehicle data")

        guard response != nil, error == nil else {
            let alert = AlertManager.alertWithMessageAndCloseButton("Something went wrong while getting vehicle data")
            manager.send(request: alert)
            return false
        }

        return true
    }
}

// MARK: - Phone Calls

extension VehicleDataManager {
    /// Checks if the head unit has the ability and/or permissions to make a phone call. If it does, the phone number is dialed.
    ///
    /// - Parameter manager: The SDL manager
    /// - phoneNumber: A phone number to dial
    class func checkPhoneCallCapability(manager: SDLManager, phoneNumber: String) {
        SDLLog.d("Checking phone call capability")
        manager.systemCapabilityManager.updateCapabilityType(.phoneCall, completionHandler: { (error, systemCapabilityManager) in
            guard let phoneCapability = systemCapabilityManager.phoneCapability else {
                manager.send(AlertManager.alertWithMessageAndCloseButton("The head unit does not support the phone call capability"))
                return
            }
            if phoneCapability.dialNumberEnabled?.boolValue ?? false {
                SDLLog.d("Dialing phone number \(phoneNumber)...")
                dialPhoneNumber(phoneNumber, manager: manager)
            } else {
                manager.send(AlertManager.alertWithMessageAndCloseButton("A phone call can not be made"))
            }
        })
    }

    /// Dials a phone number.
    ///
    /// - Parameters:
    ///   - phoneNumber: A phone number to dial
    ///   - manager: The SDL manager
    private class func dialPhoneNumber(_ phoneNumber: String, manager: SDLManager) {
        let dialNumber = SDLDialNumber(number: phoneNumber)
        manager.send(request: dialNumber) { (requst, response, error) in
            guard let success = response?.resultCode else { return }
            SDLLog.d("Sent dial number request: \(success == .success ? "successfully" : "unsuccessfully").")
        }
    }
}
