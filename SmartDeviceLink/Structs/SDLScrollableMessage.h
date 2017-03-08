//  SDLScrollableMessage.h
//


#import "SDLRPCRequest.h"

@class SDLSoftButton;

/**
 * Creates a full screen overlay containing a large block of formatted text that
 * can be scrolled with up to 8 SoftButtons defined
 * <p>
 * Function Group: ScrollableMessage
 * <p>
 * <b>HMILevel needs to be FULL</b>
 * <p>
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLScrollableMessage : SDLRPCRequest

- (instancetype)initWithMessage:(NSString *)message;

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(nullable NSArray<SDLSoftButton *> *)softButtons;

/**
 * @abstract A Body of text that can include newlines and tabs
 * @discussion A String value representing the Body of text that can include
 *            newlines and tabs
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong, nonatomic) NSString *scrollableMessageBody;
/**
 * @abstract Gets/Sets an App defined timeout. Indicates how long of a timeout in milliseconds from the
 * last action
 * @discussion An Integer value representing an App defined timeout in milliseconds
 *            <p>
 *            <b>Notes</b>:Minval=0; Maxval=65535;Default=30000
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *timeout;
/**
 * @abstract Gets/Sets App defined SoftButtons.If omitted on supported displays, only the
 * system defined "Close" SoftButton will be displayed
 * @discussion A Vector<SoftButton> value representing App defined
 *            SoftButtons
 *            <p>
 *            <b>Notes: </b>Minsize=0, Maxsize=8
 */
@property (nullable, strong, nonatomic) NSArray<SDLSoftButton *> *softButtons;

@end

NS_ASSUME_NONNULL_END
