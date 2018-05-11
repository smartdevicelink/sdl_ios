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
    fileprivate var refreshUIHandler: refreshUIHandler?
    public fileprivate(set) var vehicleOdometerData: String

    init(sdlManager: SDLManager, refreshUIHandler: refreshUIHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshUIHandler = refreshUIHandler
        self.vehicleOdometerData = ""
        super.init()

        resetOdometer()
        NotificationCenter.default.addObserver(self, selector: #selector(vehicleDataNotification(_:)), name: .SDLDidReceiveVehicleData, object: nil)
    }

    func stopManager() {
        resetOdometer()
    }
}

// MARK: - Subscribe Vehicle Data

extension VehicleDataManager {
    /// Subscribes to odometer data. You must subscribe to a notification with name `SDLDidReceiveVehicleData` to get the new data when the odometer data changes.
    func subscribeToVehicleOdometer() {
        let subscribeToVehicleOdometer = SDLSubscribeVehicleData()
        subscribeToVehicleOdometer.odometer = true
        sdlManager.send(request: subscribeToVehicleOdometer) { [unowned self] (request, response, error) in
            guard let result = response?.resultCode else { return }

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
                SDLLog.d("Unknown reason for failure to get vehicle data: \(error != nil ? error!.localizedDescription : "no error message")")
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
        unsubscribeToVehicleOdometer.odometer = true
        sdlManager.send(request: unsubscribeToVehicleOdometer) { (request, response, error) in
            guard let response = response, response.resultCode == .success else { return }
            self.resetOdometer()
        }
    }

    /// Notification containing the updated vehicle data.
    ///
    /// - Parameter notification: A SDLOnVehicleData notification
    func vehicleDataNotification(_ notification: SDLRPCNotificationNotification) {
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
    /// Retreives the current vehicle speed
    ///
    /// - Parameter manager: The SDL manager
    class func getVehicleSpeed(with manager: SDLManager) {
        SDLLog.d("Checking if app has permission to access vehicle data...")
        guard manager.permissionManager.isRPCAllowed("GetVehicleData") else {
            let alert = AlertManager.alertWithMessageAndCloseButton("This app does not have the required permissions to access vehicle data")
            manager.send(request: alert)
            return
        }

        SDLLog.d("App has permission to access vehicle data. Requesting vehicle speed data...")
        let getVehicleSpeed = SDLGetVehicleData()
        getVehicleSpeed.speed = true
        manager.send(request: getVehicleSpeed) { (request, response, error) in
            guard let response = response, error == nil else {
                let alert = AlertManager.alertWithMessageAndCloseButton("Something went wrong while getting vehicle speed")
                manager.send(request: alert)
                return
            }

            var alertMessage = "\(VehicleDataSpeedName): "
            switch response.resultCode {
            case .rejected:
                SDLLog.d("The request for vehicle speed was rejected")
                alertMessage += "Rejected"
            case .disallowed:
                SDLLog.d("This app does not have the required permissions to access vehicle data")
                alertMessage += "Disallowed"
            case .success:
                if let vehicleData = response as? SDLGetVehicleDataResponse, let speed = vehicleData.speed {
                    SDLLog.d("Request for vehicle speed successful: \(speed)")
                    alertMessage += "\(speed) kph"
                } else {
                    SDLLog.e("Request for vehicle speed successful but no data returned")
                    alertMessage += "Unknown"
                }
            default: break
            }

            let alert = AlertManager.alertWithMessageAndCloseButton(alertMessage)
            manager.send(request: alert)
        }
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
