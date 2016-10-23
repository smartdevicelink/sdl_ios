//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

@interface SDLImageResolution : SDLRPCStruct

@property (strong) NSNumber<SDLInt> *resolutionWidth;
@property (strong) NSNumber<SDLInt> *resolutionHeight;

@end
