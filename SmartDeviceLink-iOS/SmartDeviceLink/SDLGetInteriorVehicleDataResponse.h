//
//  SDLGetInteriorVehicleDataResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponse.h"

@class SDLModuleData;


NS_ASSUME_NONNULL_BEGIN

@interface SDLGetInteriorVehicleDataResponse : SDLRPCResponse

@property (strong, nonatomic) SDLModuleData *moduleData;

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
