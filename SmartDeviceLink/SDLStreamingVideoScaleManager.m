//
//  SDLStreamingVideoScaleManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 10/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLStreamingVideoScaleManager.h"
#import <simd/simd.h>

#import "SDLImageResolution.h"
#import "SDLOnTouchEvent.h"
#import "SDLRectangle.h"
#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"
#import "SDLHapticRect.h"
#import "SDLNotificationConstants.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStreamingVideoScaleManager

//TODO: use CGFloat instead
const float SDLDefaultScaleValue = 1.0f;
const float SDLMaxScaleValue = 10.0f;
const float SDLMinScaleValue = 1.0f/SDLMaxScaleValue;
CGSize const SDLDefaultDisplayViewportResolution = {0, 0};

- (instancetype)init {
    return [self initWithScale:SDLDefaultScaleValue displayViewportResolution:SDLDefaultDisplayViewportResolution];
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
    return (CGRect){CGPointZero, [self.class scale:self.scale size:self.displayViewportResolution]};
}

- (void)setScale:(float)scale {
    _scale = [self.class validateScale:scale];
}

- (SDLImageResolution *)makeScaledResolution {
    const CGSize size = [self.class scale:self.scale size:self.displayViewportResolution];
    return [[SDLImageResolution alloc] initWithWidth:(uint16_t)size.width height:(uint16_t)size.height];
}

#pragma mark - Helpers

/**
 Validates the scale value. Returns a clamped scale value in the range [SDLMinScaleValue...SDLMaxScaleValue]

 @param scale The scale value to be validated.
 @return The validated scale value
 */
+ (float)validateScale:(float)scale {
    return simd_clamp(scale, SDLMinScaleValue, SDLMaxScaleValue);
}

+ (CGSize)scale:(float)scale size:(CGSize)size {
    const float validScale = [self validateScale:scale];
    return CGSizeMake(roundf((float)size.width / validScale), roundf((float)size.height / validScale));
}

@end

NS_ASSUME_NONNULL_END
