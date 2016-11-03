//  SDLRegisterAppInterface.h
//

#import "SDLRPCRequest.h"

@class SDLAppInfo;
@class SDLAppHMIType;
@class SDLDeviceInfo;
@class SDLLanguage;
@class SDLLifecycleConfiguration;
@class SDLSyncMsgVersion;
@class SDLTTSChunk;

/**
 * Registers the application's interface with SDL&reg;, declaring properties of
 * the registration, including the messaging interface version, the app name,
 * etc. The mobile application must establish its interface registration with
 * SDL before any other interaction with SDL&reg; can take place. The
 * registration lasts until it is terminated either by the application calling
 * the <i> SDLUnregisterAppInterface</i> method, or by SDL&reg;
 * sending an <i> SDLOnAppInterfaceUnregistered</i> notification, or
 * by loss of the underlying transport connection, or closing of the underlying
 * message transmission protocol RPC session
 * <p>
 * Until the application receives its first <i>SDLOnHMIStatus</i>
 * Notification, its HMI Status is assumed to be: <i>
 * SDLHMILevel</i>=NONE, <i>
 * SDLAudioStreamingState
 * </i>=NOT_AUDIBLE, <i>
 * SDLSystemContext</i>=MAIN
 * <p>
 * All SDL&reg; resources which the application creates or uses (e.g. Choice
 * Sets, Command Menu, etc.) are associated with the application's interface
 * registration. Therefore, when the interface registration ends, the SDL&reg;
 * resources associated with the application are disposed of. As a result, even
 * though the application itself may continue to run on its host platform (e.g.
 * mobile device) after the interface registration terminates, the application
 * will not be able to use the SDL&reg; HMI without first establishing a new
 * interface registration and re-creating its required SDL&reg; resources. That
 * is, SDL&reg; resources created by (or on behalf of) an application do not
 * persist beyond the life-span of the interface registration
 * <p>
 * Resources and settings whose lifespan is tied to the duration of an
 * application's interface registration:<br/>
 * <ul>
 * <li>Choice Sets</li>
 * <li>Command Menus (built by successive calls to <i>SDLAddCommand
 * </i>)</li>
 * <li>Media clock timer display value</li>
 * <li>Media clock timer display value</li>
 * <li>Media clock timer display value</li>
 * </ul>
 * <p>
 * The autoActivateID is used to grant an application the HMILevel and
 * AudioStreamingState it had when it last disconnected
 * <p>
 * <b>Notes: </b>The autoActivateID parameter, and associated behavior, is
 * currently ignored by SDL&reg;
 * <p>
 * When first calling this method (i.e. first time within life cycle of mobile
 * app), an autoActivateID should not be included. After successfully
 * registering an interface, an autoActivateID is returned to the mobile
 * application for it to use in subsequent connections. If the connection
 * between SDL&reg; and the mobile application is lost, such as the vehicle is
 * turned off while the application is running, the autoActivateID can then be
 * passed in another call to RegisterAppInterface to re-acquire <i>
 * SDLHMILevel</i>=FULL
 * <p>
 * If the application intends to stream audio it is important to indicate so via
 * the isMediaApp parameter. When set to true, audio will reliably stream
 * without any configuration required by the user. When not set, audio may
 * stream, depending on what the user might have manually configured as a media
 * source on SDL&reg;
 * <p>
 * There is no time limit for how long the autoActivateID is "valid" (i.e. would
 * confer focus and opt-in)
 * <p>
 * <b>HMILevel is not defined before registering</b><br/>
 * </p>
 *
 * @since SDL 1.0
 *
 * @see SDLUnregisterAppInterface SDLOnAppInterfaceUnregistered
 */
@interface SDLRegisterAppInterface : SDLRPCRequest {
}

/**
 * @abstract Constructs a new SDLRegisterAppInterface object
 */
- (instancetype)init;

/**
 * @abstract Constructs a new SDLRegisterAppInterface object indicated by the dictionary parameter
 *
 * @param dict The dictionary to use
 */
- (instancetype)initWithDictionary:(NSMutableDictionary *)dict;

- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration;

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired;

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType *)appType shortAppName:(NSString *)shortAppName;

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage *)languageDesired isMediaApp:(BOOL)isMediaApp appType:(SDLAppHMIType *)appType shortAppName:(NSString *)shortAppName ttsName:(NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage *)hmiDisplayLanguageDesired resumeHash:(NSString *)resumeHash;

/**
 * @abstract The version of the SDL interface
 *
 * Required
 */
@property (strong) SDLSyncMsgVersion *syncMsgVersion;

/**
 * @abstract The Mobile Application's Name, This name is displayed in the SDL Mobile Applications menu. It also serves as the unique identifier of the application for SmartDeviceLink
 *
 * @discussion 
 * <li>Needs to be unique over all applications.</li>
 * <li>May not be empty.</li>
 * <li>May not start with a new line character.</li>
 * <li>May not interfere with any name or synonym of previously registered applications and any predefined blacklist of words (global commands).</li>
 * <li>Needs to be unique over all applications. Applications with the same name will be rejected.</li>
 *
 * Required, Max length 100 chars
 */
@property (strong) NSString *appName;

/**
 * @abstract TTS string for VR recognition of the mobile application name.
 *
 * @discussion Meant to overcome any failing on speech engine in properly pronouncing / understanding app name.
 * <li>Needs to be unique over all applications.</li>
 * <li>May not be empty.</li>
 * <li>May not start with a new line character.</li>
 *
 * Optional, Array of SDLTTSChunk, Array size 1 - 100
 *
 * @since SDL 2.0
 * @see SDLTTSChunk
 */
@property (strong) NSMutableArray *ttsName;

/**
 * @abstract A String representing an abbreviated version of the mobile application's name (if necessary) that will be displayed on the media screen
 *
 * @discussion If not provided, the appName is used instead (and will be truncated if too long)
 *
 * Optional, Max length 100 chars
 */
@property (strong) NSString *ngnMediaScreenAppName;

/**
 * @abstract Defines a additional voice recognition commands
 *
 * @discussion May not interfere with any app name of previously registered applications and any predefined blacklist of words (global commands)
 *
 * Optional, Array of Strings, Array length 1 - 100, Max String length 40
 */
@property (strong) NSMutableArray *vrSynonyms;

/**
 * @abstract Indicates if the application is a media or a non-media application.
 *
 * @discussion Only media applications will be able to stream audio to head units that is audible outside of the BT media source.
 *
 * Required, Boolean
 */
@property (strong) NSNumber *isMediaApplication;

/**
 * @abstract A Language enumeration indicating what language the application intends to use for user interaction (TTS and VR).
 *
 * @discussion If there is a mismatch with the head unit, the app will be able to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Required
 */
@property (strong) SDLLanguage *languageDesired;

/**
 * @abstract An enumeration indicating what language the application intends to use for user interaction (Display).
 *
 * @discussion If there is a mismatch with the head unit, the app will be able to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Required
 *
 * @since SDL 2.0
 */
@property (strong) SDLLanguage *hmiDisplayLanguageDesired;

/**
 * @abstract A list of all applicable app types stating which classifications to be given to the app.
 *
 * Optional, Array of SDLAppHMIType, Array size 1 - 100
 *
 * @since SDL 2.0
 * @see SDLAppHMIType
 */
@property (strong) NSMutableArray *appHMIType;

/**
 * @abstract ID used to uniquely identify current state of all app data that can persist through connection cycles (e.g. ignition cycles).
 *
 * @discussion This registered data (commands, submenus, choice sets, etc.) can be reestablished without needing to explicitly reregister each piece. If omitted, then the previous state of an app's commands, etc. will not be restored. 
 *
 * When sending hashID, all RegisterAppInterface parameters should still be provided (e.g. ttsName, etc.).
 *
 * Optional, max length 100 chars
 */
@property (strong) NSString *hashID;

/**
 * @abstract Information about the connecting device
 *
 * Optional
 */
@property (strong) SDLDeviceInfo *deviceInfo;

/**
 * @abstract ID used to validate app with policy table entries
 *
 * Required, max length 100
 *
 * @since SDL 2.0
 */
@property (strong) NSString *appID;

/**
 * @abstract Information about the application running
 *
 * Optional
 */
@property (strong) SDLAppInfo *appInfo;

@end
