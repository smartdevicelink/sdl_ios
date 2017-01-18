//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

#import "SDLTBTState.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnTBTClientState : SDLRPCNotification

@property (strong, nonatomic) SDLTBTState state;

@end

NS_ASSUME_NONNULL_END
