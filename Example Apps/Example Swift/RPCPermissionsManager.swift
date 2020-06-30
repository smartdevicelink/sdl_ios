//
//  RPCPermissionsManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/13/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink
import SmartDeviceLinkSwift

class RPCPermissionsManager {
    /// Checks if an RPC has the required permission to be sent to SDL Core and gets notifications if those permissions change.
    ///
    /// - Parameter manager: The SDL Manager
    class func setupPermissionsCallbacks(with manager: SDLManager) {
        // Checks if the `SDLShow` RPC is allowed right at this moment
        let showRPCName = SDLRPCFunctionName.show
        _ = checkCurrentPermission(with: manager, rpcName: showRPCName)

        // Checks if all the RPCs need to create menus are allowed right at this moment
        let addCommandPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.addCommand, parameterPermissions: nil)
        let createInteractionPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.createInteractionChoiceSet, parameterPermissions: nil)
        let performInteractionPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.performInteraction, parameterPermissions: nil)
        let menuRPCNames = [addCommandPermissionElement, createInteractionPermissionElement, performInteractionPermissionElement]
        _ = checkCurrentGroupPermissions(with: manager, rpcNames: menuRPCNames)

        // Set up an observer for permissions changes to media template releated RPCs. Since the `groupType` is set to all allowed, this block is called when the group permissions changes from all allowed. This block is called immediately when created.
        let setMediaClockPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.setMediaClockTimer, parameterPermissions: nil)
        let subscribeButtonPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.subscribeButton, parameterPermissions: nil)
        let mediaTemplateRPCs = [setMediaClockPermissionElement, subscribeButtonPermissionElement]
        let allAllowedObserverId = subscribeGroupPermissions(with: manager, rpcNames: mediaTemplateRPCs, groupType: .allAllowed)

        // Stop observing permissions changes for the media template releated RPCs
        unsubscribeGroupPermissions(with: manager, observerId: allAllowedObserverId)

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to any, this block is called when the permission status changes for any of the RPCs being observed. This block is called immediately when created.
       _ = subscribeGroupPermissions(with: manager, rpcNames: mediaTemplateRPCs, groupType: .any)
    }

    /// Checks if the `DialNumber` RPC is allowed
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: True if allowed, false if not
    class func isDialNumberRPCAllowed(with manager: SDLManager) -> Bool {
        SDLLog.d("Checking if app has permission to dial a number")
        return checkCurrentPermission(with: manager, rpcName: SDLRPCFunctionName.dialNumber)
    }
}

// MARK: - Check Permissions

private extension RPCPermissionsManager {
    /// Checks if the `Show` RPC is allowed right at this moment
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: true if allowed, false if not
    class func checkCurrentPermission(with manager: SDLManager, rpcName: SDLRPCFunctionName) -> Bool {
        let isRPCAllowed = manager.permissionManager.isRPCNameAllowed(rpcName)
        logRPCPermission(rpcName: rpcName, isRPCAllowed: isRPCAllowed)
        return isRPCAllowed
    }

    /// Checks if all the RPCs need to create menus are allowed right at this moment
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: The rpc names, the group permission status and the permission status for each rpc in the group
    class func checkCurrentGroupPermissions(with manager: SDLManager, rpcNames: [SDLPermissionElement]) -> SDLPermissionGroupStatus {
        let groupPermissionStatus = manager.permissionManager.groupStatus(ofRPCNames: rpcNames)
        let individualPermissionStatuses = manager.permissionManager.statuses(ofRPCNames: rpcNames)
        logRPCGroupPermissions(rpcNames: rpcNames, groupPermissionStatus: groupPermissionStatus, individualPermissionStatuses: individualPermissionStatuses)
        return groupPermissionStatus
    }

    /// Sets up an observer for permissions changes to media template releated RPCs.
    ///
    /// - Parameters:
    ///   - manager: The SDL Manager
    ///   - groupType: The type of changes to get notified about
    /// - Returns: A unique id assigned to observer. Use the id to unsubscribe to notifications
    class func subscribeGroupPermissions(with manager: SDLManager, rpcNames: [SDLPermissionElement], groupType: SDLPermissionGroupType) -> UUID {
        let permissionAllAllowedObserverId = manager.permissionManager.subscribe(toRPCNames: rpcNames, groupType: groupType, withHandler: { (individualStatuses, groupStatus) in
            self.logRPCGroupPermissions(rpcNames: rpcNames, groupPermissionStatus: groupStatus, individualPermissionStatuses: individualStatuses)
        })

        return permissionAllAllowedObserverId
    }

    /// Unsubscribe to notifications about permissions changes for a group of RPCs
    ///
    /// - Parameters:
    ///   - manager: The SDL Manager
    ///   - observerId: The unique identifier for a group of RPCs
    class func unsubscribeGroupPermissions(with manager: SDLManager, observerId: UUID) {
        manager.permissionManager.removeObserver(forIdentifier: observerId)
    }
}

// MARK: - Debug Logging

private extension RPCPermissionsManager {
    /// Logs permissions for a single RPC
    ///
    /// - Parameters:
    ///   - rpcName: The name of the RPC
    ///   - isRPCAllowed: The permission status for the RPC
    class func logRPCPermission(rpcName: SDLRPCFunctionName, isRPCAllowed: Bool) {
        SDLLog.d("\(rpcName.rawValue.rawValue) RPC can be sent to SDL Core? \(isRPCAllowed ? "yes" : "no")")
    }

    /// Logs permissions for a group of RPCs
    ///
    /// - Parameters:
    ///   - rpcNames: The names of the RPCs
    ///   - groupPermissionStatus: The permission status for all RPCs in the group
    ///   - individualPermissionStatuses: The permission status for each of the RPCs in the group
    class func logRPCGroupPermissions(rpcNames: [SDLPermissionElement], groupPermissionStatus: SDLPermissionGroupStatus, individualPermissionStatuses: [SDLRPCFunctionName:SDLRPCPermissionStatus]) {
        SDLLog.d("The group status for \(rpcNames.map { $0.rpcName.rawValue } ) has changed to: \(groupPermissionStatus.rawValue)")
        for (rpcName, rpcAllowed) in individualPermissionStatuses {
            logRPCPermission(rpcName: rpcName, isRPCAllowed: rpcAllowed.isRPCAllowed)
        }
    }
}
