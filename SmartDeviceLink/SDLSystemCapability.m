//
//  SDLSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLNames.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLSystemCapabilityType.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemCapability

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypePhoneCall;
    self.phoneCapability = capability;

    return self;
}

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeNavigation;
    self.navigationCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [store sdl_setObject:type forName:SDLNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    return [store sdl_objectForName:SDLNameSystemCapabilityType];
}

// TODO: Nav / Phone Capability

- (void)setNavigationCapability:(nullable SDLNavigationCapability *)navigationCapability {
    [store sdl_setObject:navigationCapability forName:SDLNameNavigationCapability];
}

- (nullable SDLNavigationCapability *)navigationCapability {
    return [store sdl_objectForName:SDLNameNavigationCapability ofClass:SDLNavigationCapability.class];
}

- (void)setPhoneCapability:(nullable SDLPhoneCapability *)phoneCapability {
    [store sdl_setObject:phoneCapability forName:SDLNamePhoneCapability];
}

- (nullable SDLPhoneCapability *)phoneCapability {
    return [store sdl_objectForName:SDLNamePhoneCapability ofClass:SDLPhoneCapability.class];
}

@end

NS_ASSUME_NONNULL_END
