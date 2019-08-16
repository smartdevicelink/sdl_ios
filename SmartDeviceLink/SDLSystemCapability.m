//
//  SDLSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapability.h"

#import "NSMutableDictionary+Store.h"
#import "SDLAppServicesCapabilities.h"
#import "SDLRPCParameterNames.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVideoStreamingCapability.h"
#import "SDLRemoteControlCapabilities.h"
#import "SDLDisplayCapability.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemCapability

- (instancetype)initWithAppServicesCapabilities:(SDLAppServicesCapabilities *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeAppServices;
    self.appServicesCapabilities = capability;

    return self;
}

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

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeVideoStreaming;
    self.videoStreamingCapability = capability;

    return self;
}

- (instancetype)initWithRemoteControlCapability:(SDLRemoteControlCapabilities *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = SDLSystemCapabilityTypeRemoteControl;
    self.remoteControlCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType)type {
    [self.store sdl_setObject:type forName:SDLRPCParameterNameSystemCapabilityType];
}

- (SDLSystemCapabilityType)systemCapabilityType {
    NSError *error = nil;
    return [self.store sdl_enumForName:SDLRPCParameterNameSystemCapabilityType error:&error];
}

- (void)setAppServicesCapabilities:(nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    [self.store sdl_setObject:appServicesCapabilities forName:SDLRPCParameterNameAppServicesCapabilities];
}

- (nullable SDLAppServicesCapabilities *)appServicesCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameAppServicesCapabilities ofClass:SDLAppServicesCapabilities.class error:nil];
}

- (void)setNavigationCapability:(nullable SDLNavigationCapability *)navigationCapability {
    [self.store sdl_setObject:navigationCapability forName:SDLRPCParameterNameNavigationCapability];
}

- (nullable SDLNavigationCapability *)navigationCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameNavigationCapability ofClass:SDLNavigationCapability.class error:nil];
}

- (void)setPhoneCapability:(nullable SDLPhoneCapability *)phoneCapability {
    [self.store sdl_setObject:phoneCapability forName:SDLRPCParameterNamePhoneCapability];
}

- (nullable SDLPhoneCapability *)phoneCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNamePhoneCapability ofClass:SDLPhoneCapability.class error:nil];
}

- (void)setVideoStreamingCapability:(nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    [self.store sdl_setObject:videoStreamingCapability forName:SDLRPCParameterNameVideoStreamingCapability];
}

- (nullable SDLVideoStreamingCapability *)videoStreamingCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameVideoStreamingCapability ofClass:SDLVideoStreamingCapability.class error:nil];
}

- (void)setRemoteControlCapability:(nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    [self.store sdl_setObject:remoteControlCapability forName:SDLRPCParameterNameRemoteControlCapability];
}

- (nullable SDLRemoteControlCapabilities *)remoteControlCapability {
    return [self.store sdl_objectForName:SDLRPCParameterNameRemoteControlCapability ofClass:SDLRemoteControlCapabilities.class error:nil];
}


- (void)setDisplayCapabilities:(nullable SDLDisplayCapability *)displayCapabilities {
    [self.store sdl_setObject:displayCapabilities forName:SDLRPCParameterNameDisplayCapabilities];
}

- (nullable SDLDisplayCapability *)displayCapabilities {
    return [self.store sdl_objectForName:SDLRPCParameterNameDisplayCapabilities ofClass:SDLDisplayCapability.class error:nil];
}

@end

NS_ASSUME_NONNULL_END
