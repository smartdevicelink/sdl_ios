//  SDLImageResolution.h
//


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

- (instancetype)initWithWidth:(uint16_t)width height:(uint16_t)height;

@end

NS_ASSUME_NONNULL_END
