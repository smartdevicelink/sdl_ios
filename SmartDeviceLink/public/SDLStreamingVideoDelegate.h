//
//  SDLStreamingVideoDelegate.h
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import <CoreGraphics/CGGeometry.h>

NS_ASSUME_NONNULL_BEGIN

/// A delegate method about changes to streaming video for streaming video apps
@protocol SDLStreamingVideoDelegate <NSObject>

/// Callback notifying of a size update for the video streaming window on the module UI
/// @param displaySize The new size of the video streaming window on the module
- (void)videoStreamingSizeDidUpdate:(CGSize)displaySize NS_SWIFT_NAME(videoStreamingSizeDidUpdate(toSize:));

@end

NS_ASSUME_NONNULL_END
