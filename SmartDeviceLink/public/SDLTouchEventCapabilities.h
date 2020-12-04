//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The capabilities of touches during projection applications
 */
@interface SDLTouchEventCapabilities : SDLRPCStruct

/**
 Whether or not long presses are available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *pressAvailable;

/**
 Whether or not multi-touch (e.g. a pinch gesture) is available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *multiTouchAvailable;

/**
 Whether or not a double tap is available
 */
@property (strong, nonatomic) NSNumber<SDLBool> *doublePressAvailable;

@end

NS_ASSUME_NONNULL_END
