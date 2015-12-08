//
//  SDLGetInteriorVehicleDataCapabilities.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequest.h"

@class SDLInteriorZone;
@class SDLModuleType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleDataCapabilities : SDLRPCRequest

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  Called to retrieve the available zones and supported control types.
 *
 *  If included, only the corresponding modules able to be controlled by that zone will be sent back. If not included, all modules will be returned regardless of their ability to be controlled by specifc zones.
 *
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLInteriorZone *interiorZone;

/**
 *  If included, only the corresponding type of modules a will be sent back. If not included, all module types will be returned.
 *
 *  Optional, Size 1 - 1000
 */
@property (copy, nonatomic, nullable) NSArray<SDLModuleType *> *moduleTypes;

@end

NS_ASSUME_NONNULL_END
