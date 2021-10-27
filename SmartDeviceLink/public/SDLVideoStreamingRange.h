//
//  SDLVideoStreamingRange.h
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import <Foundation/Foundation.h>

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

/// A range of supported video streaming sizes from minimum to maximum
@interface SDLVideoStreamingRange : NSObject <NSCopying>

/// The minimum supported normalized aspect ratio, min value is 1.0, defaults to 1.0
@property (nonatomic, assign) float minimumAspectRatio;

/// The maximum supported normalized aspect ratio, min value is 1.0, defaults to 9999.0
@property (nonatomic, assign) float maximumAspectRatio;

/// The minimum supported diagonal screen size in inches, defaults to 0.0 (matches any size)
@property (nonatomic, assign) float minimumDiagonal;

/// The minimum resolution to support, it overrides .minimumAspectRatio
@property (nonatomic, strong, nullable) SDLImageResolution *minimumResolution;

/// The maximum resolution to support, it overrides .maximumAspectRatio
@property (nonatomic, strong, nullable) SDLImageResolution *maximumResolution;

/// Create a video streaming range based on a minimum and maximum resolution
/// @param minResolution The minimum supported height / width resolution
/// @param maxResolution The maximum supported height / width resolution
- (instancetype)initWithMinimumResolution:(nullable SDLImageResolution *)minResolution maximumResolution:(nullable SDLImageResolution *)maxResolution;

/// Create a video streaming range with all supported options
/// @param minResolution The minimum supported height / width resolution
/// @param maxResolution The maximum supported height / width resolution
/// @param minimumAspectRatio The minimum supported normalized aspect ratio, min value is 1.0, defaults to 1.0
/// @param maximumAspectRatio The maximum supported normalized aspect ratio, min value is 1.0, defaults to 9999.0
/// @param minimumDiagonal The minimum supported diagonal screen size in inches, defaults to 0 (0 matches any size)
- (instancetype)initWithMinimumResolution:(nullable SDLImageResolution *)minResolution maximumResolution:(nullable SDLImageResolution *)maxResolution minimumAspectRatio:(float)minimumAspectRatio maximumAspectRatio:(float)maximumAspectRatio minimumDiagonal:(float)minimumDiagonal;

/// A convenience method to create a disabled range with the min and max resolutions equal to zero
+ (instancetype)disabled;

/// Check if the argument is within the [.minimumResolution, .maximumResolution] range
- (BOOL)isImageResolutionInRange:(SDLImageResolution *)imageResolution;

/// Check if the argument is within the [.minimumAspectRatio, .maximumAspectRatio] range
- (BOOL)isAspectRatioInRange:(float)aspectRatio;

@end

NS_ASSUME_NONNULL_END
