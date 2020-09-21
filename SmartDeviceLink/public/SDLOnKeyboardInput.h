//  SDLOnKeyboardInput.h
//

#import "SDLRPCNotification.h"

#import "SDLKeyboardEvent.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Sent when a keyboard presented by a PerformInteraction has a keyboard input.
 */
@interface SDLOnKeyboardInput : SDLRPCNotification

/**
 The type of keyboard input
 */
@property (strong, nonatomic) SDLKeyboardEvent event;

/**
 The current keyboard string input from the user
 */
@property (nullable, strong, nonatomic) NSString *data;

@end

NS_ASSUME_NONNULL_END
