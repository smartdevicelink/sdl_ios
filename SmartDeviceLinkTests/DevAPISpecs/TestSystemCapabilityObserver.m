//
//  TestSystemCapabilityObserver.m
//  SmartDeviceLinkTests
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "TestSystemCapabilityObserver.h"

@implementation TestSystemCapabilityObserver

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    _selectorCalledCount = 0;

    return self;
}

- (void)capabilityUpdated {
    self.selectorCalledCount++;
}

- (void)capabilityUpdatedWithNotification:(SDLSystemCapabilityManager *)capabilityManager {
    self.selectorCalledCount++;
}

@end
