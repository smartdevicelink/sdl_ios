//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

@class SDLTBTState;


@interface SDLOnTBTClientState : SDLRPCNotification

@property (strong) SDLTBTState *state;

@end
