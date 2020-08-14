//
//  SDLSubscribeButtonObserver.m
//  SmartDeviceLink
//
//  Created by Nicole on 5/21/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLSubscribeButtonObserver.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLSubscribeButtonObserver

- (instancetype)initWithObserver:(id<NSObject>)observer selector:(SEL)selector {
    self = [super init];
    if (!self) { return nil; }

    _observer = observer;
    _selector = selector;

    return self;
}

- (instancetype)initWithObserver:(id<NSObject>)observer updateHandler:(SDLSubscribeButtonUpdateHandler)block {
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
