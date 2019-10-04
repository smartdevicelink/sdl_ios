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

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    self = [super initWithName:SDLRPCFunctionNameGetSystemCapability];
    if (!self) {
        return nil;
    }

    return self;
}
#pragma clang diagnostic pop

- (void)setSystemCapability:(nullable SDLSystemCapability *)systemCapability {
    [self.parameters sdl_setObject:systemCapability forName:SDLRPCParameterNameSystemCapability];
}

- (nullable SDLSystemCapability *)systemCapability {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSystemCapability ofClass:SDLSystemCapability.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
