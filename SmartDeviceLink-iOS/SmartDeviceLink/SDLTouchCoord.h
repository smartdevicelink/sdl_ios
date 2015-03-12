//  SDLTouchCoord.h
//



#import "SDLRPCMessage.h"

@interface SDLTouchCoord : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* x;
@property(strong) NSNumber* y;

@end
