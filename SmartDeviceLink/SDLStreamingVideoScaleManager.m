//
//  SDLStreamingVideoScaleManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 10/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLStreamingVideoScaleManager.h"

#import "SDLOnTouchEvent.h"
#import "SDLRectangle.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLHapticRect.h"
#import "SDLNotificationConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingVideoScaleManager ()

@property (assign, nonatomic, readwrite) CGRect appViewportFrame;

@end

@implementation SDLStreamingVideoScaleManager

const float SDLDefaultScaleValue = 1.0;
CGSize const SDLDefaultDisplayViewportResolution = {0, 0};

- (instancetype)init {
    return [[self.class alloc] initWithScale:SDLDefaultScaleValue displayViewportResolution:SDLDefaultDisplayViewportResolution];
}

- (void)stop {
    self.displayViewportResolution = SDLDefaultDisplayViewportResolution;
    self.scale = SDLDefaultScaleValue;
}

- (instancetype)initWithScale:(float)scale displayViewportResolution:(CGSize)displayViewportResolution {
    self = [super init];
    if (!self) {
        return nil;
    }

    _scale = [self.class validateScale:scale];
    _displayViewportResolution = displayViewportResolution;

    return self;
}

- (SDLOnTouchEvent *)scaleTouchEventCoordinates:(SDLOnTouchEvent *)onTouchEvent {
    if (self.scale <= SDLDefaultScaleValue) {
        return onTouchEvent;
    }
    for (SDLTouchEvent *touchEvent in onTouchEvent.event) {
        for (SDLTouchCoord *coord in touchEvent.coord) {
            coord.x = @(coord.x.floatValue / self.scale);
            coord.y = @(coord.y.floatValue / self.scale);
        }
    }
    return onTouchEvent;
}

- (SDLHapticRect *)scaleHapticRect:(SDLHapticRect *)hapticRect {
    hapticRect.rect.x = @(hapticRect.rect.x.floatValue * self.scale);
    hapticRect.rect.y = @(hapticRect.rect.y.floatValue * self.scale);
    hapticRect.rect.width = @(hapticRect.rect.width.floatValue * self.scale);
    hapticRect.rect.height = @(hapticRect.rect.height.floatValue * self.scale);
    return hapticRect;
}

#pragma mark - Getters and Setters

- (CGRect)appViewportFrame {
    // Screen capture in the CarWindow API only works if the width and height are integer values
    return CGRectMake(0, 0, roundf((float)self.displayViewportResolution.width / self.scale), roundf((float)self.displayViewportResolution.height / self.scale));
}

- (void)setScale:(float)scale {
    _scale = [self.class validateScale:scale];
}

#pragma mark - Helpers

/**
 Validates the scale value. Returns the default scale value for 1.0 if the scale value is less than 1.0

 @param scale The scale value to be validated.
 @return The validated scale value
 */
+ (float)validateScale:(float)scale {
    return (scale > SDLDefaultScaleValue) ? scale : SDLDefaultScaleValue;
}

@end

NS_ASSUME_NONNULL_END
