//  SDLOnTBTClientState.h
//



#import "SDLRPCNotification.h"

#import "SDLTBTState.h"

@interface SDLOnTBTClientState : SDLRPCNotification {}

-(instancetype) init;
-(instancetype) initWithDictionary:(NSMutableDictionary*) dict;

@property(strong) SDLTBTState* state;

@end
