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
 The resolution of an image
 */
@interface SDLImageResolution (StreamingVideoExtensions)

/**
 * SDLImageResolutionKind
 */
@property (nonatomic, readonly) SDLImageResolutionKind kind;

/**
 It creates and returns a CGSize struct initialized with the resolution width and height
 @return CGSize struct
 */
- (CGSize)makeSize;

// the return value is always equals or above 1.0 if valid, or is 0.0 if size is invalid
- (float)normalizedAspectRatio;

@end

NS_ASSUME_NONNULL_END
