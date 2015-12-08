//
//  SDLGetInteriorVehicleData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLModuleDescription;


NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleData : SDLRPCRequest

/**
 *  The zone and module data to retrieve from the vehicle for that zone.
 */
@property (strong, nonatomic) SDLModuleDescription *moduleDescription;

/**
 *  If subscribe is true, the head unit will send onInteriorVehicleData notifications for the moduleDescription.
 *
 *  Optional, Bool, defaults to false
 */
@property (copy, nonatomic, nullable) NSNumber *subscribe;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
