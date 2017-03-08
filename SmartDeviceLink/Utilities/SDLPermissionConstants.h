//
//  SDLPermissionsConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/18/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString *SDLPermissionRPCName;
typedef NSUUID *SDLPermissionObserverIdentifier;

/**
 *  A permission group type which will be used to tell the system what type of changes you want to be notified about for the group.
 */
typedef NS_ENUM(NSUInteger, SDLPermissionGroupType) {
    /**
     *  Be notified when all of the RPC in the group are allowed, or, when they all stop being allowed in some sense, that is, when they were all allowed, and now they are not.
     */
    SDLPermissionGroupTypeAllAllowed,
    /**
     *  Be notified when any change in availability occurs among the group.
     */
    SDLPermissionGroupTypeAny
};

/**
 *  The status of the group of RPCs permissions.
 */
typedef NS_ENUM(NSUInteger, SDLPermissionGroupStatus) {
    /**
     *  Every RPC in the group is currently allowed.
     */
    SDLPermissionGroupStatusAllowed,
    /**
     *  Every RPC in the group is currently disallowed.
     */
    SDLPermissionGroupStatusDisallowed,
    /**
     *  Some RPCs in the group are allowed and some disallowed.
     */
    SDLPermissionGroupStatusMixed,
    /**
     *  The current status of the group is unknown.
     */
    SDLPermissionGroupStatusUnknown
};

/**
 *  The PermissionObserver is a block that is passed in to some methods that will be stored and called when specified permissions change.
 *
 *  @param change  A dictionary of permission changes containing <key(String): RPC Name, object(BOOL): YES if the RPC is allowed, NO if it is not allowed>
 *  @param status       The change made to all of the RPCs in the changedDict. Allowed, if all RPCs are now allowed, Disallowed if all RPCs are now disallowed, or Mixed if some are allowed, and some are disallowed
 */
typedef void (^SDLPermissionsChangedHandler)(NSDictionary<SDLPermissionRPCName, NSNumber<SDLBool> *> *_Nonnull change, SDLPermissionGroupStatus status);

NS_ASSUME_NONNULL_END
