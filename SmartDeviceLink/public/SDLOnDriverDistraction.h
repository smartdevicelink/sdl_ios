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
 If enabled, the lock screen will be able to be dismissed while connected to SDL, allowing users the ability to interact with the app.
 
 Optional, Boolean
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *lockScreenDismissalEnabled;

/**
 Warning message to be displayed on the lock screen when dismissal is enabled.  This warning should be used to ensure that the user is not the driver of the vehicle, ex. `Swipe up to dismiss, acknowledging that you are not the driver.`.  This parameter must be present if "lockScreenDismissalEnabled" is set to true.
 
 Optional,  String
 */
@property (strong, nonatomic, nullable) NSString *lockScreenDismissalWarning;

@end

NS_ASSUME_NONNULL_END
