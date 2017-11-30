//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLTouchCoord : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLFloat> *x;
@property (strong, nonatomic) NSNumber<SDLFloat> *y;

@end

NS_ASSUME_NONNULL_END
