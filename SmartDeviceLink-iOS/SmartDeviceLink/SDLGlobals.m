//
//  SDLGlobals.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/5/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "SDLGlobals.h"

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
    
    return self;
}


#pragma mark - Custom Getters

- (NSUInteger)maxMTUSize {
    switch (self.protocolVersion) {
        case 1:
        case 2: {
            // HAX: This was set to 1024 at some point, for an unknown reason. We can't change it because of backward compatibility & validation concerns. The actual MTU for v1/2 is 1500 bytes.
            return 1024;
        } break;
        case 3:
        case 4: {
            return 128000;
        } break;
        default: {
            NSAssert(NO, @"Unknown version number: %@", @(self.protocolVersion));
            return 0;
        }
    }
}

@end
