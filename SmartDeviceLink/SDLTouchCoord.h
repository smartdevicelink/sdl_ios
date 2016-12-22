//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchCoord : SDLRPCStruct

@property (strong) NSNumber<SDLFloat> *x;
@property (strong) NSNumber<SDLFloat> *y;

@end

NS_ASSUME_NONNULL_END
