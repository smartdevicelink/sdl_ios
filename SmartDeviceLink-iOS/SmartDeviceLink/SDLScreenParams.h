//  SDLScreenParams.h
//



#import "SDLRPCMessage.h"

#import "SDLImageResolution.h"
#import "SDLTouchEventCapabilities.h"

@interface SDLScreenParams : SDLRPCStruct {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageResolution* resolution;
@property(strong) SDLTouchEventCapabilities* touchEventAvailable;

@end
