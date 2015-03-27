//  SDLScreenParams.h
//



#import "SDLRPCMessage.h"

#import "SDLImageResolution.h"
#import "SDLTouchEventCapabilities.h"

@interface SDLScreenParams : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLImageResolution* resolution;
@property(strong) SDLTouchEventCapabilities* touchEventAvailable;

@end
