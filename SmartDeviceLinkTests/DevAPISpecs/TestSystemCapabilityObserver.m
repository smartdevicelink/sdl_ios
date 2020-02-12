//
//  TestSystemCapabilityObserver.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "TestSystemCapabilityObserver.h"

#import "SDLSystemCapability.h"

@implementation TestSystemCapabilityObserver

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _selectorCalledCount = 0;
    _capabilitiesReceived = [NSMutableArray<SDLSystemCapability *> array];
    _errorsReceived = [NSMutableArray<NSError *> array];
    _subscribedValuesReceived = [NSMutableArray<NSNumber *> array];

    return self;
}

- (void)capabilityUpdated {
    self.selectorCalledCount++;
}

- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability {
    self.selectorCalledCount++;

    if (capability != nil) {
        [self.capabilitiesReceived addObject:capability];
    }
}

- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability error:(NSError *)error {
    self.selectorCalledCount++;

    if (capability != nil) {
        [self.capabilitiesReceived addObject:capability];
    }

    if (error != nil) {
        [self.errorsReceived addObject:error];
    }
}

- (void)capabilityUpdatedWithCapability:(SDLSystemCapability *)capability error:(NSError *)error subscribed:(BOOL)subscribed {
    self.selectorCalledCount++;

    if (capability != nil) {
        [self.capabilitiesReceived addObject:capability];
    }

    if (error != nil) {
        [self.errorsReceived addObject:error];
    }
    
    [self.subscribedValuesReceived addObject:@(subscribed)];
}

@end
