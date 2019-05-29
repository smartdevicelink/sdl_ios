//
//  SDLOnSystemCapabilityUpdated.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLOnSystemCapabilityUpdated.h"

#import "NSMutableDictionary+Store.h"
#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSystemCapability.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSystemCapabilityUpdated

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (instancetype)init {
    if (self = [super initWithName:SDLRPCFunctionNameOnSystemCapabilityUpdated]) {
    }
    return self;
}
#pragma clang diagnostic pop

- (instancetype)initWithSystemCapability:(SDLSystemCapability *)systemCapability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapability = systemCapability;

    return self;
}

- (void)setSystemCapability:(SDLSystemCapability *)systemCapability {
    [self.parameters sdl_setObject:systemCapability forName:SDLRPCParameterNameSystemCapability];
}

- (SDLSystemCapability *)systemCapability {
    NSError *error = nil;
    return [self.parameters sdl_objectForName:SDLRPCParameterNameSystemCapability ofClass:SDLSystemCapability.class error:&error];
}

@end

NS_ASSUME_NONNULL_END
