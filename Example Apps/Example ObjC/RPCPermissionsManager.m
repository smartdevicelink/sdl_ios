//
//  RPCPermissionsManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 5/11/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "RPCPermissionsManager.h"
#import "SDLLogMacros.h"

NS_ASSUME_NONNULL_BEGIN

@implementation RPCPermissionsManager

/**
 *  Examples of how to check the permissions of select RPCs
 *
 *  @param manager The SDL Manager
 */
+ (void)setupPermissionsCallbacksWithManager:(SDLManager *)manager {
    // Checks if the `SDLShow` RPC is allowed right at this moment
    NSString *showRPCName = @"Show";
    [self sdlex_checkCurrentPermissionWithManager:manager rpcName:showRPCName];

    // Checks if all the RPCs need to create menus are allowed right at this moment
    NSArray<SDLRPCFunctionName> *menuRPCNames = @[SDLRPCFunctionNameAddCommand, SDLRPCFunctionNameCreateInteractionChoiceSet, SDLRPCFunctionNamePerformInteraction];
    [self sdlex_checkCurrentGroupPermissionsWithManager:manager rpcNames:menuRPCNames];

    // Set up an observer for permissions changes to media template releated RPCs. Since the `groupType` is set to all allowed, this block is called when the group permissions changes from all allowed. This block is called immediately when created.
    NSArray<SDLRPCFunctionName> *mediaTemplateRPCs = @[SDLRPCFunctionNameSetMediaClockTimer, SDLRPCFunctionNameSubscribeButton];
    SDLPermissionObserverIdentifier allAllowedObserverId = [self sdlex_subscribeGroupPermissionsWithManager:manager rpcNames:mediaTemplateRPCs groupType:SDLPermissionGroupTypeAllAllowed];

    // Stop observing permissions changes for the media template releated RPCs
    [self sdlex_unsubscribeGroupPermissionsWithManager:manager observerId:allAllowedObserverId];

    // Set up an observer for permissions changes to media template releated RPCs. Since the `groupType` is set to any, this block is called when the permission status changes for any of the RPCs being observed. This block is called immediately when created.
    [self sdlex_subscribeGroupPermissionsWithManager:manager rpcNames:mediaTemplateRPCs groupType:SDLPermissionGroupTypeAny];
}

/**
 *  Checks if the `DialNumber` RPC is allowed
 *
 *  @param manager     The SDL Manager
 *  @return            True if allowed, false if not
 */
+ (BOOL)isDialNumberRPCAllowedWithManager:(SDLManager *)manager {
    SDLLogD(@"Checking if app has permission to dial a number");
    return [self sdlex_checkCurrentPermissionWithManager:manager rpcName:SDLRPCFunctionNameDialNumber];
}

#pragma mark - Check Permissions

#pragma mark Current Permissions

/**
 *  Checks the current permissions of a single RPC
 *
 *  @param manager  The SDL Manager
 *  @param rpcName  The name of the RPC
 *  @return         True if the RPC can be sent to Core right now, false if not
 */
+ (BOOL)sdlex_checkCurrentPermissionWithManager:(SDLManager *)manager rpcName:(SDLRPCFunctionName)rpcName {
    BOOL isRPCAllowed = [manager.permissionManager isRPCPermitted:rpcName];
    [self sdlex_logRPCPermission:rpcName isRPCAllowed:isRPCAllowed];
    return isRPCAllowed;
}

/**
 *  Checks the current permissions of a group of RPCs
 *
 *  @param manager  The SDL Manager
 *  @param rpcNames The names of the RPCs
 *  @return         The current permission status for all the RPCs in the group
 */
+ (SDLPermissionGroupStatus)sdlex_checkCurrentGroupPermissionsWithManager:(SDLManager *)manager rpcNames:(NSArray<SDLRPCFunctionName> *)rpcNames {
    SDLPermissionGroupStatus groupPermissionStatus = [manager.permissionManager groupStatusOfRPCNames:rpcNames];
    NSDictionary<NSString *, NSNumber *> *individualPermissionStatuses = [manager.permissionManager statusOfRPCNames:rpcNames];
    [self sdlex_logRPCGroupPermissions:rpcNames groupPermissionStatus:groupPermissionStatus individualPermissionStatuses:individualPermissionStatuses];
    return groupPermissionStatus;
}

#pragma mark Subscribe Permissions

/**
 *  Sets up a block for observing permission changes for a group of RPCs. This block is called immediately when created and when the permission status changes for the group of RPCs being observed.
 *
 *  @param manager      The SDL Manager
 *  @param rpcNames     The names of the RPCs to be subscribed
 *  @param groupType    The type of changes you want to be notified about for the group
 *  @return             A unique identifier for the subscription. This can be used to later to unsubscribe from the notifications.
 */
+ (SDLPermissionObserverIdentifier)sdlex_subscribeGroupPermissionsWithManager:(SDLManager *)manager rpcNames:(NSArray<SDLRPCFunctionName> *)rpcNames groupType:(SDLPermissionGroupType)groupType {
    SDLPermissionObserverIdentifier observerId = [manager.permissionManager subscribeToRPCs:rpcNames groupType:groupType withHandler:^(NSDictionary<SDLPermissionRPCName,NSNumber<SDLBool> *> * _Nonnull change, SDLPermissionGroupStatus status) {
        [self sdlex_logRPCGroupPermissions:rpcNames groupPermissionStatus:status individualPermissionStatuses:change];
    }];
    return observerId;
}

/**
 *  Unsubscribe to notifications about permissions changes for a group of RPCs
 *
 *  @param manager     The SDL Manager
 *  @param observerId  The unique identifier for a group of RPCs
 */
+ (void)sdlex_unsubscribeGroupPermissionsWithManager:(SDLManager *)manager observerId:(SDLPermissionObserverIdentifier)observerId {
    [manager.permissionManager removeObserverForIdentifier:observerId];
}

#pragma mark - Debug Logging

/**
 *  Logs permissions for a single RPC
 *
 *  @param rpcName      The name of the RPC
 *  @param isRPCAllowed The permission status for the RPC
 */
+ (void)sdlex_logRPCPermission:(NSString *)rpcName isRPCAllowed:(BOOL)isRPCAllowed {
    SDLLogD(@"%@ RPC can be sent to SDL Core? %@", rpcName, isRPCAllowed ? @"Yes" : @"No");
}

/**
 *  Logs permissions for a group of RPCs
 *
 *  @param rpcNames                        The names of the RPCs
 *  @param groupPermissionStatus           The permission status for all RPCs in the group
 *  @param individualPermissionStatuses    The permission status for each of the RPCs in the group
 */
+ (void)sdlex_logRPCGroupPermissions:(NSArray<NSString *> *)rpcNames groupPermissionStatus:(SDLPermissionGroupStatus)groupPermissionStatus individualPermissionStatuses:(NSDictionary<NSString *, NSNumber *> *)individualPermissionStatuses {
    SDLLogD(@"The group status for %@ has changed to: %lu", rpcNames, (unsigned long)groupPermissionStatus);
    [individualPermissionStatuses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        [self sdlex_logRPCPermission:key isRPCAllowed:obj.boolValue];
    }];
}

@end

NS_ASSUME_NONNULL_END
