//
//  TestSmartConnection.m
//  SmartDeviceLinkTests
//
//  Copyright © 2020 Luxoft. All rights reserved
//

#import "TestSmartConnection.h"
#import "SDLGetSystemCapability.h"

@implementation TestSmartConnection

- (BOOL)isEqual:(id)object {
    if (!object) {
        return NO;
    }
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    TestSmartConnection *theOther = (TestSmartConnection *)object;
    if ([self.request isEqual:theOther]) {
        return YES;
    }
    if ([self.request isKindOfClass:[SDLGetSystemCapability class]] && [theOther.request isKindOfClass:[SDLGetSystemCapability class]]) {
        SDLGetSystemCapability *getSCRequest1 = (SDLGetSystemCapability *)self.request;
        SDLGetSystemCapability *getSCRequest2 = (SDLGetSystemCapability *)theOther.request;
        if ([getSCRequest1.systemCapabilityType isEqualToEnum:getSCRequest2.systemCapabilityType]) {
            return YES;
        }
    }
    return NO;
}

@end
