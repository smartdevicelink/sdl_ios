//  SDLTouchCoord.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchCoord : SDLRPCStruct

@property (strong) NSNumber<SDLFloat> *x;
@property (strong) NSNumber<SDLFloat> *y;

@end
