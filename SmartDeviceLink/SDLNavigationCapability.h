//
//  SDLNavigationCapability.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@interface SDLNavigationCapability : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLNavigationCapability struct
 */
- (instancetype)init;

/**
 * @abstract Constructs a newly allocated SDLNavigationCapability struct indicated by the dictionary parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithSendLocation:(BOOL)sendLocationEnabled waypoints:(BOOL)waypointsEnabled;

/**
 Whether or not the SendLocation RPC is enabled.
 Boolean, optional
 */
@property (copy, nonatomic) NSNumber *sendLocationEnabled;

/**
 Whether or not Waypoint related RPCs are enabled.
 Boolean, optional
 */
@property (copy, nonatomic) NSNumber *getWayPointsEnabled;

@end
