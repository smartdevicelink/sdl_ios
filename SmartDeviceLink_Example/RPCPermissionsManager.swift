//
//  RPCPermissionsManager.swift
//  SmartDeviceLink
//
//  Created by Nicole on 4/13/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

import Foundation
import SmartDeviceLink

class RPCPermissionsManager {
    /// Checks if an RPC has the required permission to be sent to SDL Core and gets notifications if those permissions change.
    ///
    /// - Parameter manager: The SDL Manager
    class func setupPermissionsCallbacks(with manager: SDLManager) {
        // Check the current permissions for a single RPC
        let showRPCPermission = checkShowRPCCurrentPermission(with: manager)
        logRPCPermission(rpcName: showRPCPermission.rpcName, isRPCAllowed: showRPCPermission.isAllowed)

        // Check the current permissions of a group of RPCs
        let menuRPCPermissions = checkMenuRPCsPermissions(with: manager)
        logRPCGroupPermissions(rpcNames: menuRPCPermissions.rpcs, groupPermissionStatus: menuRPCPermissions.groupPermissionStatus, individualPermissionStatuses: menuRPCPermissions.individualPermissionStatuses)

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to all allowed, this block is called when the group permissions changes from all allowed to some not allowed. This block is called immediately when created.
        let permissionAllAllowedObserverId = checkMediaTemplateRPCsPermissions(with: manager, groupType: .allAllowed)

        // To stop observing permissions changes for a group of RPCs, remove the observer.
        manager.permissionManager.removeObserver(forIdentifier: permissionAllAllowedObserverId)

        // Sets up a block for observing permission changes for a group of RPCs. Since the `groupType` is set to any, this block is called when the permission status changes for any of the RPCs being observed. This block is called immediately when created.
        let _ = checkMediaTemplateRPCsPermissions(with: manager, groupType: .any)
    }
}

// MARK: - Check Permissions

private extension RPCPermissionsManager {
    /// Checks if the `Show` RPC is allowed right at this moment
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: true if allowed, false if not
    class func checkShowRPCCurrentPermission(with manager: SDLManager) -> (rpcName: String, isAllowed: Bool) {
        let rpcName = "Show"
        let isShowRPCAllowed = manager.permissionManager.isRPCAllowed(rpcName)
        return (rpcName, isShowRPCAllowed)
    }

    /// Checks if all the RPCs need to create menus are allowed right at this moment
    ///
    /// - Parameter manager: The SDL Manager
    /// - Returns: The rpc names, the group permission status and the permission status for each rpc in the group
    class func checkMenuRPCsPermissions(with manager: SDLManager) -> (rpcs: [String], groupPermissionStatus: SDLPermissionGroupStatus, individualPermissionStatuses: [String:NSNumber]) {
        let rpcNames = ["AddCommand", "SDLCreateInteractionChoiceSet", "PerformInteraction"]
        let groupPermissionStatus = manager.permissionManager.groupStatus(ofRPCs: rpcNames)
        let individualPermissionStatuses = manager.permissionManager.status(ofRPCs: rpcNames)
        return (rpcNames, groupPermissionStatus, individualPermissionStatuses)
    }

    /// Sets up an observer for permissions changes to media template releated RPCs.
    ///
    /// - Parameters:
    ///   - manager: The SDL Manager
    ///   - groupType: The type of changes to get notified about
    /// - Returns: A unique id assigned to observer. Use the id to unsubsribe to notifications
    class func checkMediaTemplateRPCsPermissions(with manager: SDLManager, groupType: SDLPermissionGroupType) -> UUID {
        let observedRPCGroup = ["SetMediaClockTimer", "SubscribeButton"]
        let permissionAllAllowedObserverId = manager.permissionManager.addObserver(forRPCs: observedRPCGroup, groupType: groupType, withHandler: { (individualStatuses, groupStatus) in
            self.logRPCGroupPermissions(rpcNames: observedRPCGroup, groupPermissionStatus: groupStatus, individualPermissionStatuses: individualStatuses)
        })

        return permissionAllAllowedObserverId
    }
}

// MARK: - Debug Logging

private extension RPCPermissionsManager {
    /// Logs permissions for a single RPC
    ///
    /// - Parameters:
    ///   - rpcName: The name of the RPC
    ///   - isRPCAllowed: The permission status for the RPC
    class func logRPCPermission(rpcName: String, isRPCAllowed: Bool) {
        print("\(rpcName) RPC can be sent to SDL Core? \(isRPCAllowed ? "yes" : "no")")
    }

    /// Logs permissions for a group of RPCs
    ///
    /// - Parameters:
    ///   - rpcNames: The names of the RPCs
    ///   - groupPermissionStatus: The permission status for all RPCs in the group
    ///   - individualPermissionStatuses: The permission status for each of the RPCs in the group
    class func logRPCGroupPermissions(rpcNames: [String], groupPermissionStatus: SDLPermissionGroupStatus, individualPermissionStatuses: [String:NSNumber]) {
        print("The group status for \(rpcNames) has changed to: \(groupPermissionStatus)")
        for (rpcName, rpcAllowed) in individualPermissionStatuses {
            logRPCPermission(rpcName: rpcName as String, isRPCAllowed: rpcAllowed.boolValue)
        }
    }
}
