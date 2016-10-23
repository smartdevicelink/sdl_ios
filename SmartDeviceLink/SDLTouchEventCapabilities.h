//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchEventCapabilities : SDLRPCStruct

@property (strong) NSNumber<SDLBool> *pressAvailable;
@property (strong) NSNumber<SDLBool> *multiTouchAvailable;
@property (strong) NSNumber<SDLBool> *doublePressAvailable;

@end
