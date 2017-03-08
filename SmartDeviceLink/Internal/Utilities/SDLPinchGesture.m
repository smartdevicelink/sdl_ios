//
//  SDLPinchGesture.m
//  SmartDeviceLink-iOS
//
//  Created by Muller, Alexander (A.) on 6/14/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLPinchGesture.h"

#import "CGPoint_Util.h"
#import "SDLTouch.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLPinchGesture

@synthesize distance = _distance;
@synthesize center = _center;

- (instancetype)initWithFirstTouch:(SDLTouch *)firstTouch secondTouch:(SDLTouch *)secondTouch {
    self = [super init];
    if (!self) {
        return nil;
    }

    _firstTouch = firstTouch;
    _secondTouch = secondTouch;
    _distance = -1;
    _center = CGPointZero;

    return self;
}

#pragma mark - Setters
- (void)setFirstTouch:(SDLTouch *)firstTouch {
    if (firstTouch.identifier == SDLTouchIdentifierFirstFinger) {
        _firstTouch = firstTouch;
        [self sdl_invalidate];
    }
}

- (void)setSecondTouch:(SDLTouch *)secondTouch {
    if (secondTouch.identifier == SDLTouchIdentifierSecondFinger) {
        _secondTouch = secondTouch;
        [self sdl_invalidate];
    }
}

#pragma mark - Getters
- (CGFloat)distance {
    if (_distance == -1) {
        _distance = CGPointDistanceBetweenPoints(self.firstTouch.location,
                                                 self.secondTouch.location);
    }
    return _distance;
}

- (CGPoint)center {
    if (CGPointEqualToPoint(_center, CGPointZero)) {
        _center = CGPointCenterOfPoints(self.firstTouch.location,
                                        self.secondTouch.location);
    }
    return _center;
}

- (BOOL)isValid {
    return (self.firstTouch != nil) && (self.secondTouch != nil);
}

#pragma mark - Private
- (void)sdl_invalidate {
    _distance = -1;
    _center = CGPointZero;
}

@end

NS_ASSUME_NONNULL_END