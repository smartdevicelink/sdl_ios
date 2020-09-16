//
//  SDLSeatLocation.h
//  SmartDeviceLink
//
//  Created by standa1 on 7/11/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCMessage.h"
#import "SDLGrid.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * Describes the location of a seat
 */
@interface SDLSeatLocation : SDLRPCStruct

/**
 * Optional
 */
@property (strong, nonatomic, nullable) SDLGrid *grid;

@end

NS_ASSUME_NONNULL_END
