//
//  SDLGetInteriorVehicleDataCapabilitiesResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@class SDLModuleDescription;


NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleDataCapabilitiesResponse : SDLRPCResponse

/**
 *  Size 1 - 1000
 */
@property (copy, nonatomic) NSArray<SDLModuleDescription *> *interiorVehicleDataCapabilities;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
