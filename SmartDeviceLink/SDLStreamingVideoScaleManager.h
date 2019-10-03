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
 The scale factor value to scale coordinates from one coordinate space to another.
 */
@property (assign, nonatomic) float scale;

/**
 The current screen size of a connected display
 */
@property (assign, nonatomic) CGSize screenSize;

/**
 The scaled frame for the view being streamed to the connected display.
*/
@property (assign, nonatomic, readonly) CGRect screenFrame;

- (instancetype)init NS_UNAVAILABLE;

/**
 Creates a default streaming video scale manager.

 @return A default configuration that may be customized.
 */
+ (instancetype)defaultConfiguration;

/**
 Convenience init for creating a scale manager with the scale and connecte display screen size.

 @param scale The scale factor value to scale coordinates from one coordinate space to another
 @param screenSize The current screen size of a connected display
 @return A SDLStreamingVideoScaleManager object
*/
- (instancetype)initWithScale:(nullable NSNumber *)scale screenSize:(CGSize)screenSize;

/**
 Scales the coordinates of the OnTouchEvent from the screen's coordinate sysytem to the view controller's coordinate system. If the scale value is less than 1.0, the touch events will not be scaled.

 @param onTouchEvent A touch event with coordinates
 @return The touch event coordinates in the screen coordinate system
*/
- (SDLOnTouchEvent *)scaleTouchEventCoordinates:(SDLOnTouchEvent *)onTouchEvent;

/**
 Scales the haptic rectangle from the view controller coordinate system to the screen coordinate system. If the scale value is less than 1.0, the haptic rectangle will not be scaled.

 @param hapticRect A haptic rectangle
 @return The position of the haptic rectangle in the screen coordinate system
*/
- (SDLHapticRect *)scaleHapticRect:(SDLHapticRect *)hapticRect;

@end

NS_ASSUME_NONNULL_END
