//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchEventCapabilities : SDLRPCStruct

@property (strong) NSNumber *pressAvailable;
@property (strong) NSNumber *multiTouchAvailable;
@property (strong) NSNumber *doublePressAvailable;

@end
