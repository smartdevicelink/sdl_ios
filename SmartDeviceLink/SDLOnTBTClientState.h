//  SDLOnTBTClientState.h
//

#import "SDLRPCNotification.h"

#import "SDLTBTState.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Provides applications with notifications specific to the current TBT client status on the module
 */
@interface SDLOnTBTClientState : SDLRPCNotification

/**
 Current State of TBT client
 */
@property (strong, nonatomic) SDLTBTState state;

@end

NS_ASSUME_NONNULL_END
