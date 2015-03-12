//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

@class SDLTBTState;


@interface SDLOnTBTClientState : SDLRPCNotification {}

-(id) init;
-(id) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTBTState* state;

@end
