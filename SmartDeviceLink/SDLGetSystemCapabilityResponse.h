//
//  SDLGetSystemCapabilityResponse.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLRPCResponse.h"

@class SDLSystemCapability;

@interface SDLGetSystemCapabilityResponse : SDLRPCResponse

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong, nonatomic) SDLSystemCapability *systemCapability;

@end
