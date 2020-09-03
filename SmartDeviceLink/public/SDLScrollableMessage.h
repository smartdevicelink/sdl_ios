//  SDLScrollableMessage.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;

NS_ASSUME_NONNULL_BEGIN

/**
 Creates a full screen overlay containing a large block of formatted text that can be scrolled with buttons available.

 If connecting to SDL Core v.6.0+, the scrollable message can be canceled programmatically using the `cancelID`. On older versions of SDL Core, the scrollable message will persist until the user has interacted with the scrollable message or the specified timeout has elapsed.

 @since SDL 2.0
 */
@interface SDLScrollableMessage : SDLRPCRequest

/**
 Convenience init for creating a scrolling message with text.

 @param message Body of text that can include newlines and tabs
 @return A SDLScrollableMessage object
 */
- (instancetype)initWithMessage:(NSString *)message;

/**
 Convenience init for creating a scrolling message with text and buttons.

 @param message Body of text that can include newlines and tabs
 @param timeout Indicates how long of a timeout from the last action (i.e. scrolling message resets timeout)
 @param softButtons Buttons for the displayed scrollable message
 @param cancelID An ID for this specific scrollable message to allow cancellation through the `CancelInteraction` RPC
 @return A SDLScrollableMessage object
 */
- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons cancelID:(UInt32)cancelID;

/**
 Body of text that can include newlines and tabs.

 String, Required, Max length 500 chars

 @since SDL 2.0
 */
@property (strong, nonatomic) NSString *scrollableMessageBody;

/**
 App defined timeout. Indicates how long of a timeout from the last action (i.e. scrolling message resets timeout). If not set, a default value of 30 seconds is used by Core.

 Integer, Optional, Min value: 1000, Max value: 65535, Default value: 30000

 @since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;

/**
 Buttons for the displayed scrollable message. If omitted on supported displays, only the system defined "Close" SoftButton will be displayed.

 Array of SDLSoftButton, Optional, Array size: 0-8

 Since SDL 2.0
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

/**
 An ID for this specific scrollable message to allow cancellation through the `CancelInteraction` RPC.

 Integer, Optional

 @see SDLCancelInteraction
 @since SDL 6.0
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *cancelID;

@end

NS_ASSUME_NONNULL_END
