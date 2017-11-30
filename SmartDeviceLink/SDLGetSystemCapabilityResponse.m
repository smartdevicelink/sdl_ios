//
//  SDLGetSystemCapabilityResponse.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/11/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLGetSystemCapabilityResponse.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLSystemCapability.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLGetSystemCapabilityResponse

- (instancetype)init {
    self = [super initWithName:SDLNameGetSystemCapability];
    if (!self) {
        return nil;
    }

    return self;
}

- (void)setSystemCapability:(SDLSystemCapability *)systemCapability {
    [parameters sdl_setObject:systemCapability forName:SDLNameSystemCapability];
}

- (SDLSystemCapability *)systemCapability {
    return [parameters sdl_objectForName:SDLNameSystemCapability ofClass:SDLSystemCapability.class];
}

@end

NS_ASSUME_NONNULL_END
