//
//  SDLOnSystemCapabilityUpdated.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/6/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLOnSystemCapabilityUpdated.h"
#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLOnSystemCapabilityUpdated

- (instancetype)init {
    if (self = [super initWithName:SDLNameOnSystemCapabilityUpdated]) {
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
