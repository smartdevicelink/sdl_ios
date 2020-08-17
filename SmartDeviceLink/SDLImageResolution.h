//  SDLImageResolution.h
//

#import <UIKit/UIKit.h>
#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The resolution of an image
 */
@interface SDLImageResolution : SDLRPCStruct

/**
 Resolution width

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *resolutionWidth;

/**
 Resolution height

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *resolutionHeight;

/// Convenience init with all parameters
///
/// @param width Resolution width
/// @param height Resolution height
/// @return An SDLImageResolution object
- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height;

- (CGSize)makeSize;

- (float)normalizedAspectRatio;

// string representation, for debug only
- (NSString*)stringValue;

@end

NS_ASSUME_NONNULL_END
