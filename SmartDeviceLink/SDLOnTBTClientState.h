//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

@class SDLTBTState;


@interface SDLOnTBTClientState : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

@property (strong) SDLTBTState *state;

@end
