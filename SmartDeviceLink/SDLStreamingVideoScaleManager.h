//
//  SDLStreamingVideoScaleManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 10/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SDLOnTouchEvent.h"
#import "SDLRectangle.h"


NS_ASSUME_NONNULL_BEGIN

extern const float DefaultScaleValue;

/**
 This class consolidates the logic of scaling from the view controller's coordinate system to the head unit screen's coordinate system and vice-versa.

 The main goal of using scaling is to align different screens and use a common range of "points per inch". This will allow showing assets with a similar size on different screen resolutions.
 */
@interface SDLStreamingVideoScaleManager : NSObject

/**
 Calculates the frame of the view controller using the screen resolution and a scale value. If the scale value is less than 1.0, the frame will not be scaled and the screen size will be returned.

 @param screenSize The resolution of the screen
 @param scaleAmount The amount to scale the screenSize
 @return The size of the view controller's frame for capturing video
 */
+ (CGRect)scaleFrameForScreenSize:(CGSize)screenSize scale:(float)scaleAmount;

/**
 Scales the coordinates of the OnTouchEvent from the screen's coordinate sysytem to the view controller's coordinate system. If the scale value is less than 1.0, the touch events will not be scaled.

 @param onTouchEvent A SDLOnTouchEvent with coordinates.
 @param scaleAmount The amount to scale the touch event
 @return The touch event coordinates in the screen coordinate system
 */
+ (SDLOnTouchEvent *)scaleTouchEventCoordinates:(SDLOnTouchEvent *)onTouchEvent scale:(float)scaleAmount;

/**
 Scales the haptic rectangle from the view controller coordinate system to the screen coordinate system. If the scale value is less than 1.0, the haptic rectangle will not be scaled.

 @param rectangle The position of the haptic rectangle in the view controller coordinate system
 @param scaleAmount The amount to scale the haptic rectangle
 @return The position of the haptic rectangle in the screen coordinate system
*/
+ (SDLRectangle *)scaleHapticRectangle:(CGRect)rectangle scale:(float)scaleAmount;

@end

NS_ASSUME_NONNULL_END
