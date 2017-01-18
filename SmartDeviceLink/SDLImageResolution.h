//  SDLImageResolution.h
//


#import "SDLRPCMessage.h"

@interface SDLImageResolution : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLInt> *resolutionWidth;
@property (strong, nonatomic) NSNumber<SDLInt> *resolutionHeight;

@end
