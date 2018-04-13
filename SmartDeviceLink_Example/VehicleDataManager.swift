//
//  VehicleDataManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/13/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

typealias refreshOdometerHandler = ((String) -> Void)

class VehicleDataManager: NSObject {
    fileprivate let sdlManager: SDLManager!
    var refreshOdometerHandler: refreshOdometerHandler?

    init(sdlManager: SDLManager, refreshOdometerHandler: refreshOdometerHandler? = nil) {
        self.sdlManager = sdlManager
        self.refreshOdometerHandler = refreshOdometerHandler
        super.init()

        NotificationCenter.default.addObserver(self, selector: #selector(vehicleDataNotification(_:)), name: .SDLDidReceiveVehicleData, object: nil)
    }

    // MARK: Subscribe to odometer data

    func subscribeToVehicleOdometer() {
        let subscribeToVehicleOdometer = SDLSubscribeVehicleData()
        subscribeToVehicleOdometer.odometer = true
        sdlManager.send(request: subscribeToVehicleOdometer) { [unowned self] (request, response, error) in
            guard let result = response?.resultCode else { return }

            var message = ""
            switch result {
            case .success:
                message = "Subscribed to vehicle odometer data"
            case .disallowed:
                message = "Access to vehicle data disallowed."
            case .userDisallowed:
                message = "Vehicle user disabled access to vehicle data"
            case .ignored:
                message = "Already subscribed to odometer data"
            case .dataNotAvailable:
                message = "You have permission to access to vehicle data, but the vehicle you are connected to did not provide anything"
            default:
                message = "Unknown reason for failure to get vehicle data: \(error != nil ? error!.localizedDescription : "no error message") "
            }

            guard let handler = self.refreshOdometerHandler else { return }
            handler(message)
        }
    }

    func unsubscribeToVehicleOdometer() {
        let unsubscribeToVehicleOdometer = SDLUnsubscribeVehicleData()
        unsubscribeToVehicleOdometer.odometer = true
        sdlManager.send(unsubscribeToVehicleOdometer)
    }

    func vehicleDataNotification(_ notification: SDLRPCNotificationNotification) {
        guard let handler = refreshOdometerHandler, let onVehicleData = notification.notification as? SDLOnVehicleData, let odometer = onVehicleData.odometer else {
            return
        }

        handler("Odometer: \(odometer)km")
    }

    // MARK: - Get Odometer Data

    class func getVehicleSpeed(with manager: SDLManager) {
        guard manager.permissionManager.isRPCAllowed("GetVehicleData") else {
            let warningAlert = AlertManager.alertWithMessageAndCloseButton("This app does not have the required permissions to access vehicle data")
            manager.send(request: warningAlert)
            return
        }

        let getVehicleSpeed = SDLGetVehicleData()
        getVehicleSpeed.speed = true

        manager.send(request: getVehicleSpeed) { (request, response, error) in
            guard let response = response, error == nil else {
                let alert = AlertManager.alertWithMessageAndCloseButton("Something went wrong while getting vehicle speed")
                manager.send(request: alert)
                return
            }

            var alertMessage = ""
            switch response.resultCode {
            case .rejected:
                alertMessage = "The request for vehicle speed was rejected by SDL Core."
            case .disallowed:
                alertMessage = "This app does not have the required permissions to access vehicle data."
            case .success:
                if let vehicleData = response as? SDLGetVehicleDataResponse, let speed = vehicleData.speed {
                    alertMessage = "Speed: \(speed)kph"
                } else {
                    alertMessage = "Speed: unkown"
                }
            default: break
            }

            let alert = AlertManager.alertWithMessageAndCloseButton(alertMessage)
            manager.send(request: alert)
        }
    }
}

