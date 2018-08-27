//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The coordinate of a touch, used in a touch event
 */
@interface SDLTouchCoord : SDLRPCStruct

/**
 The x value of the touch coordinate

 Required, float 0 - 10000
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *x;

/**
 The y value of the touch coordinate

 Required, float 0 - 10000
 */
@property (strong, nonatomic) NSNumber<SDLFloat> *y;

@end

NS_ASSUME_NONNULL_END
