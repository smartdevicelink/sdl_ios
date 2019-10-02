//
//  SDLStreamingVideoScaleManager.m
//  SmartDeviceLink
//
//  Created by Nicole on 10/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLStreamingVideoScaleManager.h"

#import "SDLTouchCoord.h"
#import "SDLTouchEvent.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLStreamingVideoScaleManager

const float DefaultScaleValue = 1.0;

+ (CGRect)scaleFrameForScreenSize:(CGSize)screenSize scale:(float)scaleAmount {
    float scale = [self validateScale:scaleAmount];
    // Screen capture in the CarWindow API only works if the width and height are integer values
    return CGRectMake(0,
                      0,
                      roundf((float)screenSize.width / scale),
                      roundf((float)screenSize.height / scale));
}

+ (SDLOnTouchEvent *)scaleTouchEventCoordinates:(SDLOnTouchEvent *)onTouchEvent scale:(float)scaleAmount {
    float scale = [self validateScale:scaleAmount];
    if (scale <= DefaultScaleValue) {
        return onTouchEvent;
    }
    for (SDLTouchEvent *touchEvent in onTouchEvent.event) {
        for (SDLTouchCoord *coord in touchEvent.coord) {
            coord.x = @(coord.x.floatValue / scale);
            coord.y = @(coord.y.floatValue / scale);
        }
    }
    return onTouchEvent;
}

+ (SDLRectangle *)scaleHapticRectangle:(CGRect)rectangle scale:(float)scaleAmount {
    float scale = [self validateScale:scaleAmount];
    return [[SDLRectangle alloc]
            initWithX:(float)rectangle.origin.x * scale
            y:(float)rectangle.origin.y * scale
            width:(float)rectangle.size.width * scale
            height:(float)rectangle.size.height * scale];
}

/**
 Validates the scale value. Returns the default scale value if the scale value is less than 1.0

 @param scale The scale value to be validated.
 @return The validated scale value
*/
+ (float)validateScale:(float)scale {
    return (scale > DefaultScaleValue) ? scale : DefaultScaleValue;
}

@end

NS_ASSUME_NONNULL_END
