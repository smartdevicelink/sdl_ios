//
//  SDLNavigationCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Extended capabilities for an onboard navigation system
 */
@interface SDLNavigationCapability : SDLRPCStruct

/// Convenience init with all parameters
///
/// @param sendLocationEnabled Whether or not the SendLocation RPC is enabled
/// @param waypointsEnabled Whether SDLNavigationInstruction.hor not Waypoint related RPCs are enabled
/// @return An SDLNavigationCapability object
- (instancetype)initWithSendLocation:(BOOL)sendLocationEnabled waypoints:(BOOL)waypointsEnabled;

/**
 Whether or not the SendLocation RPC is enabled.

 Boolean, optional
 */
@property (nullable, copy, nonatomic) NSNumber *sendLocationEnabled;

/**
 Whether or not Waypoint related RPCs are enabled.

 Boolean, optional
 */
@property (nullable, copy, nonatomic) NSNumber *getWayPointsEnabled;

@end

NS_ASSUME_NONNULL_END
