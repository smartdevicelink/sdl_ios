//
//  SDLNavigationServiceManifest.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *  A navigation service manifest.
 */
@interface SDLNavigationServiceManifest : SDLRPCStruct

/**
 *  Convenience init.
 *
 *  @param acceptsWayPoints Informs the subscriber if this service can actually accept way points
 *  @return A SDLNavigationServiceManifest object
 */
- (instancetype)initWithAcceptsWayPoints:(BOOL)acceptsWayPoints;

/**
 *  Informs the subscriber if this service can actually accept way points.
 *
 *  Boolean, Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *acceptsWayPoints;

@end

NS_ASSUME_NONNULL_END
