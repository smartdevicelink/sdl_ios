//
//  SDLPermissionsConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 11/18/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSNumber+NumberType.h"

typedef NSString SDLPermissionRPCName;
typedef NSUUID SDLPermissionObserverIdentifier;

typedef NS_ENUM(NSUInteger, SDLPermissionGroupType) {
    SDLPermissionGroupTypeAllAllowed,
    SDLPermissionGroupTypeAny
};

typedef NS_ENUM(NSUInteger, SDLPermissionStatus) {
    SDLPermissionStatusAllowed,
    SDLPermissionStatusDisallowed,
    SDLPermissionStatusMixed,
    SDLPermissionStatusUnknown
};

/**
 *  The PermissionObserver is a block that is passed in to some methods that will be stored and called when specified permissions change.
 *
 *  @param changedDict  A dictionary of permission changes containing <key(String): RPC Name, object(BOOL): YES if the RPC is allowed, NO if it is not allowed>
 *  @param status       The change made to all of the RPCs in the changedDict. Allowed, if all RPCs are now allowed, Disallowed if all RPCs are now disallowed, or Mixed if some are allowed, and some are disallowed
 */
typedef void (^SDLPermissionObserver)(NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> * _Nonnull changedDict, SDLPermissionStatus status);
