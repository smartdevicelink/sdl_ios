//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

@class SDLTBTState;


@interface SDLOnTBTClientState : SDLRPCNotification {
}

- (instancetype)init;
- (instancetype)initWithDictionary:(NSMutableDictionary<NSString *, id> *)dict;

@property (strong) SDLTBTState *state;

@end
