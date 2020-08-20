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
        let menuRPCPermissions = [addCommandPermissionElement, createInteractionPermissionElement, performInteractionPermissionElement]
        _ = checkCurrentGroupPermissions(with: manager, permissionElements: menuRPCPermissions)

        // Set up an observer for permissions changes to media template releated RPCs. Since the `groupType` is set to all allowed, this block is called when the group permissions changes to all-allowed or from all-allowed to some-not-allowed.
        let setMediaClockPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.setMediaClockTimer, parameterPermissions: nil)
        let subscribeButtonPermissionElement = SDLPermissionElement(rpcName: SDLRPCFunctionName.subscribeButton, parameterPermissions: nil)
        let mediaTemplatePermissions = [setMediaClockPermissionElement, subscribeButtonPermissionElement]
        let allAllowedObserverId = subscribeGroupPermissions(with: manager, permissionElements: mediaTemplatePermissions, groupType: .allAllowed)

        // Stop observing permissions changes for the media template releated RPCs
        unsubscribeGroupPermissions(with: manager, observerId: allAllowedObserverId)

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to any, this block is called when the permission status changes for any of the RPCs being observed. This block is called immediately when created.
        _ = subscribeGroupPermissions(with: manager, permissionElements: mediaTemplatePermissions, groupType: .any)
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
    /// Checks if the RPC is allowed at the time of the call
    ///
    /// - Parameter manager: The SDL Manager
    /// - Parameter rpcName: The name of the RPC to check
    /// - Returns: true if allowed, false if not
    class func checkCurrentPermission(with manager: SDLManager, rpcName: SDLRPCFunctionName) -> Bool {
        let isRPCAllowed = manager.permissionManager.isRPCNameAllowed(rpcName)
        SDLLog.d("\(rpcName.rawValue.rawValue) RPC can be sent to SDL Core? \(isRPCAllowed ? "YES" : "NO")")
        return isRPCAllowed
    }

    /// Checks if all the given RPCs are allowed or not at the time of the call
    ///
    /// - Parameter manager: The SDL Manager
    /// - Parameter permissionElements: The RPCs and parameters to be checked
    /// - Returns: The group permission status
    class func checkCurrentGroupPermissions(with manager: SDLManager, permissionElements: [SDLPermissionElement]) -> SDLPermissionGroupStatus {
        let groupPermissionStatus = manager.permissionManager.groupStatus(ofRPCPermissions: permissionElements)
        let individualPermissionStatuses = manager.permissionManager.statuses(ofRPCPermissions: permissionElements)
        logRPCGroupPermissions(permissionElements: permissionElements, groupPermissionStatus: groupPermissionStatus, individualPermissionStatuses: individualPermissionStatuses)
        return groupPermissionStatus
    }

    /// Sets up an observer for permissions changes to media template releated RPCs.
    ///
    /// - Parameters:
    ///   - manager: The SDL Manager
    ///   - groupType: The type of changes to get notified about
    ///   - permissionElements: The RPCs and parameters to be checked
    /// - Returns: A unique id assigned to observer. Use the id to unsubscribe to notifications
    class func subscribeGroupPermissions(with manager: SDLManager, permissionElements: [SDLPermissionElement], groupType: SDLPermissionGroupType) -> UUID {
        let permissionAllAllowedObserverId = manager.permissionManager.subscribe(toRPCPermissions: permissionElements, groupType: groupType, withHandler: { (individualStatuses, groupStatus) in
            self.logRPCGroupPermissions(permissionElements: permissionElements, groupPermissionStatus: groupStatus, individualPermissionStatuses: individualStatuses)
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
    class func logRPCPermission(status: SDLRPCPermissionStatus) {
        SDLLog.d("\(status.rpcName.rawValue.rawValue) RPC can be sent to SDL Core? \(status.isRPCAllowed ? "YES" : "NO"), parameters: \(status.rpcParameters ?? [:])")
    }

    /// Logs permissions for a group of RPCs
    ///
    /// - Parameters:
    ///   - rpcNames: The names of the RPCs
    ///   - groupPermissionStatus: The permission status for all RPCs in the group
    ///   - individualPermissionStatuses: The permission status for each of the RPCs in the group
    class func logRPCGroupPermissions(permissionElements: [SDLPermissionElement], groupPermissionStatus: SDLPermissionGroupStatus, individualPermissionStatuses: [SDLRPCFunctionName: SDLRPCPermissionStatus]) {
        SDLLog.d("The group status for \(permissionElements.map { $0.rpcName.rawValue } ) has changed to: \(groupPermissionStatus.rawValue)")
        for (_, status) in individualPermissionStatuses {
            logRPCPermission(status: status)
        }
    }
}
