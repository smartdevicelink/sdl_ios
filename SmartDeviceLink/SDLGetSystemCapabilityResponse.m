//
//  SDLGetSystemCapabilityResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapabilityResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemCapability.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetSystemCapabilityResponse

- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameGetSystemCapability];
    if (!self) {
        return nil;
    }

    return self;
}

- (void)setSystemCapability:(SDLSystemCapability *)systemCapability {
    [parameters sdl_setObject:systemCapability forName:SDLRPCParameterNameSystemCapability];
}

- (SDLSystemCapability *)systemCapability {
    NSError *error = nil;
    return [parameters sdl_objectForName:SDLRPCParameterNameSystemCapability ofClass:SDLSystemCapability.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
