//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

#import "SDLTBTState.h"

@interface SDLOnTBTClientState : SDLRPCNotification

@property (strong, nonatomic) SDLTBTState state;

@end
