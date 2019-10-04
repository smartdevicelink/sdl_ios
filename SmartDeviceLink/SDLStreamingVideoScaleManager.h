//
//  SDLStreamingVideoScaleManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 10/1/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDLOnTouchEvent;
@class SDLHapticRect;

NS_ASSUME_NONNULL_BEGIN

/**
 This class consolidates the logic of scaling between the view controller's coordinate system and the display's coordinate system.

 The main goal of using scaling is to align different screens and use a common range of "points per inch". This allows showing assets with a similar size on different screen resolutions.
 */
@interface SDLStreamingVideoScaleManager : NSObject

/**
 The scaling factor the app should use to change the size of the projecting view.
 */
@property (assign, nonatomic) float scale;

/**
 The current screen resolution of the connected display.
 */
@property (assign, nonatomic) CGSize displayViewportResolution;

/**
 The frame of the app's projecting view. This is calculated by dividing the display's viewport resolution by the scale. The video encoder uses the app's viewport frame size to encode the raw image data.
*/
@property (assign, nonatomic, readonly) CGRect appViewportFrame;

/**
 Creates a default streaming video scale manager.
*/
- (instancetype)init;

/**
 Convenience init for creating the manager with a scale and connected display viewport resolution.

 @param scale The scale factor value to scale coordinates from one coordinate space to another
 @param screenSize The current screen size of the connected display
 @return A SDLStreamingVideoScaleManager object
*/
- (instancetype)initWithScale:(float)scale displayViewportResolution:(CGSize)displayViewportResolution;

/**
 Scales the coordinates of the OnTouchEvent from the display's coordinate system to the view controller's coordinate system. If the scale value is less than 1.0, the touch events will be returned without being scaled.

 @param onTouchEvent A touch event with coordinates
 @return The touch event coordinates in the view controller's coordinate system
*/
- (SDLOnTouchEvent *)scaleTouchEventCoordinates:(SDLOnTouchEvent *)onTouchEvent;

/**
 Scales the haptic rectangle from the view controller's coordinate system to the display coordinate system. If the scale value is less than 1.0, the haptic rectangle will be returned without being scaled.

 @param hapticRect A haptic rectangle
 @return The position of the haptic rectangle in the display's coordinate system
*/
- (SDLHapticRect *)scaleHapticRect:(SDLHapticRect *)hapticRect;

/**
 Stops the manager. This method is used internally.
 */
- (void)stop;

@end

NS_ASSUME_NONNULL_END
