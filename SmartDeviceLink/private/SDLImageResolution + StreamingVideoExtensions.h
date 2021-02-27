//  SDLImageResolution + StreamingVideoExtensions.h
//

#import <CoreGraphics/CGGeometry.h>
#import "SDLImageResolution.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SDLImageResolutionKind) {
    SDLImageResolutionKindUndefined,
    SDLImageResolutionKindLandscape,
    SDLImageResolutionKindPortrait,
    SDLImageResolutionKindSquare,
};

/**
 * The resolution of an image
 */
@interface SDLImageResolution (StreamingVideoExtensions)

/**
 * SDLImageResolutionKind
 */
@property (nonatomic, readonly) SDLImageResolutionKind kind;

/**
 * Creates and returns a CGSize struct initialized with the resolution width and height
 * @return CGSize struct
 */
- (CGSize)makeSize;

/**
 * The return value is always equals or above 1.0 if valid, or is 0.0 if size is invalid
 * @return The normalized aspect ratio
 */
- (float)normalizedAspectRatio;

@end

NS_ASSUME_NONNULL_END
