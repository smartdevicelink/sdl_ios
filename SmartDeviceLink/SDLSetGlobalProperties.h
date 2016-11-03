//  SDLSetGlobalProperties.h
//

#import "SDLRPCRequest.h"

@class SDLImage;
@class SDLKeyboardProperties;


/**
 * Sets value(s) for the specified global property(ies)
 * <p>
 * Function Group: Base <p>
 * <b>HMILevel needs to be FULL, LIMITED or BACKGROUND</b>
 * </p>
 *
 * Since SmartDeviceLink 1.0
 * See SDLResetGlobalProperties
 */
@interface SDLSetGlobalProperties : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLSetGlobalProperties object
 */
- (instancetype)init;
/**
 * @abstract Constructs a new SDLSetGlobalProperties object indicated by the NSMutableDictionary
 * parameter
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText;

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray *)vrHelp;

- (instancetype)initWithHelpText:(NSString *)helpText timeoutText:(NSString *)timeoutText vrHelpTitle:(NSString *)vrHelpTitle vrHelp:(NSArray *)vrHelp menuTitle:(NSString *)menuTitle menuIcon:(SDLImage *)menuIcon keyboardProperties:(SDLKeyboardProperties *)keyboardProperties;

/**
 * @abstract Sets a Vector<TTSChunk> for Help Prompt that Array of one or more
 * TTSChunk elements specifying the help prompt used in an interaction
 * started by PTT
 * @discussion helpPrompt
 *            a Vector<TTSChunk> of one or more TTSChunk elements
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Array must have at least one element</li>
 *            <li>Only optional it timeoutPrompt has been specified</li>
 *            </ul>
 */
@property (strong) NSMutableArray *helpPrompt;
/**
 * @abstract A Vector<TTSChunk> for Timeout Prompt representing Array of one or
 * more TTSChunk elements specifying the help prompt used in an interaction
 * started by PTT
 *
 */
@property (strong) NSMutableArray *timeoutPrompt;
/**
 * @abstract Sets a voice recognition Help Title
 *
 * @discussion A String value representing a voice recognition Help Title
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>If omitted on supported displays, the default SDL help
 *            title will be used</li>
 *            <li>If omitted and one or more vrHelp items are provided, the
 *            request will be rejected.</li>
 *            <li>String Maxlength = 500</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property (strong) NSString *vrHelpTitle;
/**
 * @abstract Sets the items listed in the VR help screen used in an interaction
 * started by PTT
 *
 * @discussion A Vector value representing items listed in the VR help screen
 *            used in an interaction started by PTT
 *            <p>
 *            <b>Notes: </b><br/>
 *            <ul>
 *            <li>If omitted on supported displays, the default SmartDeviceLink VR
 *            help / What Can I Say? screen will be used</li>
 *            <li>If the list of VR Help Items contains nonsequential
 *            positions (e.g. [1,2,4]), the RPC will be rejected</li>
 *            <li>If omitted and a vrHelpTitle is provided, the request
 *            will be rejected</li>
 *            <li>Array Minsize: = 1</li>
 *            <li>Array Maxsize = 100</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property (strong) NSMutableArray *vrHelp;
@property (strong) NSString *menuTitle;
@property (strong) SDLImage *menuIcon;
@property (strong) SDLKeyboardProperties *keyboardProperties;

@end
