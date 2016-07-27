//
//  SDLGlobals.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLGlobals.h"

static const NSUInteger maxProxyVersion = 4;


@interface SDLGlobals ()

@property (assign, nonatomic) NSUInteger protocolVersion;

@end


@implementation SDLGlobals

+ (instancetype)globals {
    static SDLGlobals *sharedGlobals = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGlobals = [[SDLGlobals alloc] init];
    });

    return sharedGlobals;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _protocolVersion = 1;
    _maxHeadUnitVersion = 0;

    return self;
}


#pragma mark - Custom Getters / Setters

- (void)setMaxHeadUnitVersion:(NSUInteger)maxHeadUnitVersion {
    self.protocolVersion = MIN(maxHeadUnitVersion, maxProxyVersion);

    _maxHeadUnitVersion = maxHeadUnitVersion;
}

- (NSUInteger)maxMTUSize {
    switch (self.protocolVersion) {
        case 1: // fallthrough
        case 2: {
            // HAX: This was set to 1024 at some point, for an unknown reason. We can't change it because of backward compatibility & validation concerns. The actual MTU for v1/2 is 1500 bytes.
            return 1024;
        } break;
        case 3: // fallthrough
        case 4: {
            // If the head unit isn't running v3/4, but that's the connection scheme we're using, then we have to know that they could be running an MTU that's not 128k, so we default back to the v1/2 MTU for safety.
            if (self.maxHeadUnitVersion > maxProxyVersion) {
                return 1024;
            } else {
                return 131084;
            }
        } break;
        default: {
            NSAssert(NO, @"Unknown version number: %@", @(self.protocolVersion));
            return 0;
        }
    }
}

@end
