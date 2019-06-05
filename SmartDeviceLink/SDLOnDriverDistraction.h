//  SDLOnDriverDistraction.h
//

#import "SDLRPCNotification.h"

#import "SDLDriverDistractionState.h"

/**
 Notifies the application of the current driver distraction state (whether driver distraction rules are in effect, or not).

 HMI Status Requirements:

 HMILevel: Can be sent with FULL, LIMITED or BACKGROUND

 AudioStreamingState: Any

 SystemContext: Any

 @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLOnDriverDistraction : SDLRPCNotification

/**
 The driver distraction state (i.e. whether driver distraction rules are in effect, or not)
 */
@property (strong, nonatomic) SDLDriverDistractionState state;

/**
 If enabled, the lock screen will be able to be dismissed while connected to SDL, allowing users
 the ability to interact with the app.
 */
@property (strong, nonatomic) NSNumber<SDLBool> *lockScreenDismissalEnabled;

@end

NS_ASSUME_NONNULL_END
