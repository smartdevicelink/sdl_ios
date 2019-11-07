//  SDLSoftButton.h
//

#import "SDLRPCMessage.h"

#import "SDLNotificationConstants.h"
#import "SDLSoftButtonType.h"
#import "SDLSystemAction.h"

@class SDLImage;

NS_ASSUME_NONNULL_BEGIN

/**
 Describes an on-screen button which may be presented in various contexts, e.g. templates or alerts
 */
@interface SDLSoftButton : SDLRPCStruct

/// Convenience init
///
/// @param handler A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur
- (instancetype)initWithHandler:(nullable SDLRPCButtonNotificationHandler)handler;

/// Convenience init
///
/// @param type Describes whether this soft button displays only text, only an image, or both
/// @param text Optional text to display (if defined as TEXT or BOTH type)
/// @param image Optional image struct for SoftButton (if defined as IMAGE or BOTH type)
/// @param highlighted Displays in an alternate mode, e.g. with a colored background or foreground. Depends on the IVI system
/// @param buttonId Value which is returned via OnButtonPress / OnButtonEvent
/// @param systemAction Parameter indicating whether selecting a SoftButton shall call a specific system action
/// @param handler A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur.
- (instancetype)initWithType:(SDLSoftButtonType)type text:(nullable NSString *)text image:(nullable SDLImage *)image highlighted:(BOOL)highlighted buttonId:(UInt16)buttonId systemAction:(nullable SDLSystemAction)systemAction handler:(nullable SDLRPCButtonNotificationHandler)handler;

/// A handler that may optionally be run when the SDLSoftButton has a corresponding notification occur.
@property (copy, nonatomic) SDLRPCButtonNotificationHandler handler;

/**
 Describes whether this soft button displays only text, only an image, or both

 Required
 */
@property (strong, nonatomic) SDLSoftButtonType type;

/**
 Optional text to display (if defined as TEXT or BOTH type)

 Optional
 */
@property (strong, nonatomic, nullable) NSString *text;

/**
 Optional image struct for SoftButton (if defined as IMAGE or BOTH type)

 Optional
 */
@property (strong, nonatomic, nullable) SDLImage *image;

/**
 Displays in an alternate mode, e.g. with a colored background or foreground. Depends on the IVI system.

 Optional
 */
@property (strong, nonatomic, nullable) NSNumber<SDLBool> *isHighlighted;

/**
 Value which is returned via OnButtonPress / OnButtonEvent

 Required
 */
@property (strong, nonatomic) NSNumber<SDLInt> *softButtonID;

/**
 Parameter indicating whether selecting a SoftButton shall call a specific system action. This is intended to allow Notifications to bring the callee into full / focus; or in the case of persistent overlays, the overlay can persist when a SoftButton is pressed.

 Optional
 */
@property (strong, nonatomic, nullable) SDLSystemAction systemAction;

@end

NS_ASSUME_NONNULL_END
