//
//  SDLModuleDescription.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@class SDLInteriorZone;
@class SDLModuleType;


NS_ASSUME_NONNULL_BEGIN

@interface SDLModuleDescription : SDLRPCStruct

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (strong, nonatomic) SDLInteriorZone *moduleZone;
@property (strong, nonatomic) SDLModuleType *moduleType;

@end

NS_ASSUME_NONNULL_END
