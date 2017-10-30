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


NS_ASSUME_NONNULL_BEGIN

@interface SDLGetSystemCapabilityResponse : SDLRPCResponse

@property (strong, nonatomic) SDLSystemCapability *systemCapability;

@end

NS_ASSUME_NONNULL_END
