//  SDLOnTBTClientState.h
//


#import "SDLRPCNotification.h"

#import "SDLTBTState.h"

@interface SDLOnTBTClientState : SDLRPCNotification {
}

- (id)init;
- (id)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLTBTState *state;

@end
