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

typedef NS_ENUM(NSUInteger, SDLPermissionChangeType) {
    SDLPermissionChangeTypeAllAllowed,
    SDLPermissionChangeTypeAllDisallowed,
    SDLPermissionChangeTypeAny
};

/**
 *  The PermissionObserver is a block that is passed in to some methods that will be stored and called when specified permissions change.
 *
 *  @param changedDict  A dictionary of permission changes containing <key(String): RPC Name, object(BOOL): YES if the RPC is allowed, NO if it is not allowed>
 *  @param changeType   The change made to all of the RPCs in the changedDict. All allowed, if all RPCs are now allowed, All disallowed if all RPCs are now disallowed, or Any if some are allowed, and some are disallowed
 */
typedef void (^SDLPermissionObserver)(NSDictionary<SDLPermissionRPCName *, NSNumber<SDLBool> *> *changedDict, SDLPermissionChangeType changeType);
