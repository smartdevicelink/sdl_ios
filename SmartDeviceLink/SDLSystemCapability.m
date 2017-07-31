//
//  SDLSystemCapability.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/10/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapability.h"

#import "SDLNames.h"
#import "SDLNavigationCapability.h"
#import "SDLPhoneCapability.h"
#import "SDLSystemCapabilityType.h"
#import "SDLVideoStreamingCapability.h"

@implementation SDLSystemCapability

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (instancetype)initWithDictionary:(NSMutableDictionary *)dict {
    if (self = [super initWithDictionary:dict]) {
    }
    return self;
}

- (instancetype)initWithPhoneCapability:(SDLPhoneCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = [SDLSystemCapabilityType PHONE_CALL];
    self.phoneCapability = capability;

    return self;
}

- (instancetype)initWithNavigationCapability:(SDLNavigationCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = [SDLSystemCapabilityType NAVIGATION];
    self.navigationCapability = capability;

    return self;
}

- (instancetype)initWithVideoStreamingCapability:(SDLVideoStreamingCapability *)capability {
    self = [self init];
    if (!self) {
        return nil;
    }

    self.systemCapabilityType = [SDLSystemCapabilityType VIDEO_STREAMING];
    self.videoStreamingCapability = capability;

    return self;
}

- (void)setSystemCapabilityType:(SDLSystemCapabilityType *)type {
    if (type != nil) {
        [store setObject:type forKey:NAMES_systemCapabilityType];
    } else {
        [store removeObjectForKey:NAMES_systemCapabilityType];
    }
}

- (SDLSystemCapabilityType *)systemCapabilityType {
    id obj = store[NAMES_systemCapabilityType];
    if (obj == nil || [obj isKindOfClass:SDLSystemCapabilityType.class]) {
        return (SDLSystemCapabilityType *)obj;
    } else {
        return [SDLSystemCapabilityType valueOf:(NSString *)obj];
    }
}

// TODO: Nav / Phone Capability

- (void)setNavigationCapability:(SDLNavigationCapability *)navigationCapability {
    if (navigationCapability != nil) {
        store[NAMES_navigationCapability] = navigationCapability;
    } else {
        [store removeObjectForKey:NAMES_navigationCapability];
    }
}

- (SDLNavigationCapability *)navigationCapability {
    NSObject *obj = store[NAMES_navigationCapability];
    if (obj == nil || [obj isKindOfClass:SDLNavigationCapability.class]) {
        return (SDLNavigationCapability *)obj;
    } else {
        return [[SDLNavigationCapability alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setPhoneCapability:(SDLPhoneCapability *)phoneCapability {
    if (phoneCapability != nil) {
        store[NAMES_phoneCapability] = phoneCapability;
    } else {
        [store removeObjectForKey:NAMES_phoneCapability];
    }
}

- (SDLPhoneCapability *)phoneCapability {
    NSObject *obj = store[NAMES_phoneCapability];
    if (obj == nil || [obj isKindOfClass:SDLPhoneCapability.class]) {
        return (SDLPhoneCapability *)obj;
    } else {
        return [[SDLPhoneCapability alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

- (void)setVideoStreamingCapability:(SDLVideoStreamingCapability *)videoStreamingCapability {
    if (videoStreamingCapability != nil) {
        store[NAMES_videoStreamingCapability] = videoStreamingCapability;
    } else {
        [store removeObjectForKey:NAMES_videoStreamingCapability];
    }
}

- (SDLVideoStreamingCapability *)videoStreamingCapability {
    NSObject *obj = store[NAMES_videoStreamingCapability];
    if (obj == nil || [obj isKindOfClass:SDLVideoStreamingCapability.class]) {
        return (SDLVideoStreamingCapability *)obj;
    } else {
        return [[SDLVideoStreamingCapability alloc] initWithDictionary:(NSMutableDictionary *)obj];
    }
}

@end
