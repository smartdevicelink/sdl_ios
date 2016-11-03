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
@interface SDLScrollableMessage : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLScrollableMessage object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLScrollableMessage object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithMessage:(NSString *)message;

- (instancetype)initWithMessage:(NSString *)message timeout:(UInt16)timeout softButtons:(NSArray<SDLSoftButton *> *)softButtons;

/**
 * @abstract A Body of text that can include newlines and tabs
 * @discussion A String value representing the Body of text that can include
 *            newlines and tabs
 *            <p>
 *            <b>Notes: </b>Maxlength=500
 */
@property (strong) NSString *scrollableMessageBody;
/**
 * @abstract Gets/Sets an App defined timeout. Indicates how long of a timeout in milliseconds from the
 * last action
 * @discussion An Integer value representing an App defined timeout in milliseconds
 *            <p>
 *            <b>Notes</b>:Minval=0; Maxval=65535;Default=30000
 */
@property (strong) NSNumber *timeout;
/**
 * @abstract Gets/Sets App defined SoftButtons.If omitted on supported displays, only the
 * system defined "Close" SoftButton will be displayed
 * @discussion A Vector<SoftButton> value representing App defined
 *            SoftButtons
 *            <p>
 *            <b>Notes: </b>Minsize=0, Maxsize=8
 */
@property (strong) NSMutableArray *softButtons;

@end
