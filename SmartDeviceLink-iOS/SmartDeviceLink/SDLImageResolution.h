//  SDLImageResolution.h
//



#import "SDLRPCMessage.h"

@interface SDLImageResolution : SDLRPCStruct {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) NSNumber* resolutionWidth;
@property(strong) NSNumber* resolutionHeight;

@end
