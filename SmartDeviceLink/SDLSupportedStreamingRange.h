//
//  SDLSupportedStreamingRange.h
//  SmartDeviceLink
//
//  Created on 6/11/20.
//

#import <Foundation/Foundation.h>

@class SDLImageResolution;

NS_ASSUME_NONNULL_BEGIN

@interface SDLSupportedStreamingRange : NSObject

// The minimum supported normalized aspect ratio, Min value is 1
@property (nonatomic, assign) float minimumAspectRatio;

// The maximum supported normalized aspect ratio, Min value is 1
@property (nonatomic, assign) float maximumAspectRatio;

// The minimum supported diagonal screen size in inches, defaults to 0 (0 matches any size)
@property (nonatomic, assign) float minimumDiagonal;

// The minimum resolution to support, it overrides .minimumAspectRatio
@property (nonatomic, strong, nullable) SDLImageResolution *minimumResolution;

// The maximum resolution to support, it overrides .maximumAspectRatio
@property (nonatomic, strong, nullable) SDLImageResolution *maximumResolution;

// Check if the argument is within the [.minimumResolution, .maximumResolution] range
- (BOOL)isImageResolutionInRange:(SDLImageResolution*)imageResolution;

// Check if the argument is within the [.minimumAspectRatio, .maximumAspectRatio] range
- (BOOL)isAspectRatioInRange:(float)aspectRatio;

+ (instancetype)defaultPortraitRange;

+ (instancetype)defaultLandscapeRange;

- (instancetype)initWithResolutionsMinimum:(SDLImageResolution*)minResolution maximun:(SDLImageResolution*)maxResolution;

@end

NS_ASSUME_NONNULL_END
