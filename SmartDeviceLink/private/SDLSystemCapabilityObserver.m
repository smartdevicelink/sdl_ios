//
//  SDLSystemCapabilityObserver.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 5/23/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLSystemCapabilityObserver.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSystemCapabilityObserver

- (instancetype)initWithObserver:(id<NSObject>)observer selector:(SEL)selector {
    self = [super init];
    if (!self) { return nil; }

    _observer = observer;
    _selector = selector;

    return self;
}

- (instancetype)initWithObserver:(id<NSObject>)observer updateHandler:(SDLCapabilityUpdateWithErrorHandler)block {
    self = [super init];
    if (!self) { return nil; }

    _observer = observer;
    _updateBlock = block;

    return self;
}

- (NSString *)description {
    if (self.selector) {
        return [NSString stringWithFormat:@"Observer: %@[%@] - %@", [_observer class], _observer, NSStringFromSelector(_selector)];
    } else {
        return [NSString stringWithFormat:@"Block Observer: %@", _observer];
    }
}

@end

NS_ASSUME_NONNULL_END
