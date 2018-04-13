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

class VehicleDataManager {
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

    // MARK: Subscribe to odometer data

    class func subscribeToVehicleOdometer(with manager: SDLManager, refreshOdometerHandler: refreshOdometerHandler? = nil) {
        let subscribeToVehicleOdometer = SDLSubscribeVehicleData()
        subscribeToVehicleOdometer.odometer = true
        manager.send(request: subscribeToVehicleOdometer) { (request, response, error) in
            guard let handler = refreshOdometerHandler, let vehicleData = response as? SDLGetVehicleDataResponse, let odometer = vehicleData.odometer else { return }
            handler("Odometer: \(odometer)km")
        }
    }

    class func unsubscribeToVehicleOdometer(with manager: SDLManager) {
        let unsubscribeToVehicleOdometer = SDLUnsubscribeVehicleData()
        unsubscribeToVehicleOdometer.odometer = true
        manager.send(unsubscribeToVehicleOdometer)
    }
}

