//  SDLTouchEventCapabilities.h
//


#import "SDLRPCMessage.h"

@interface SDLTouchEventCapabilities : SDLRPCStruct

@property (strong, nonatomic) NSNumber<SDLBool> *pressAvailable;
@property (strong, nonatomic) NSNumber<SDLBool> *multiTouchAvailable;
@property (strong, nonatomic) NSNumber<SDLBool> *doublePressAvailable;

@end
