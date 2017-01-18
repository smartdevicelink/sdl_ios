//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchCoord : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLFloat> *x;
@property (strong, nonatomic) NSNumber<SDLFloat> *y;

@end
