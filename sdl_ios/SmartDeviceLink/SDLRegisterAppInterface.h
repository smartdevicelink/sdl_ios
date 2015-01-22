//  SDLRegisterAppInterface.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCRequest.h>

#import <SmartDeviceLink/SDLSyncMsgVersion.h>
#import <SmartDeviceLink/SDLLanguage.h>
#import <SmartDeviceLink/SDLDeviceInfo.h>

/**
 * Registers the application's interface with SDL&reg;, declaring properties of
 * the registration, including the messaging interface version, the app name,
 * etc. The mobile application must establish its interface registration with
 * SDL&reg; before any other interaction with SDL&reg; can take place. The
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
 * Since SmartDeviceLink 1.0
 * See SDLUnregisterAppInterface SDLOnAppInterfaceUnregistered
 */
@interface SDLRegisterAppInterface : SDLRPCRequest {}

/**
 * @abstract Constructs a new SDLRegisterAppInterface object
 */
-(id) init;
/**
 * @abstract Constructs a new SDLRegisterAppInterface object indicated by the NSMutableDictionary
 * parameter
 * @param dict The NSMutableDictionary to use
 */
-(id) initWithDictionary:(NSMutableDictionary*) dict;

/**
 * @abstract the version of the SDL&reg; SmartDeviceLink interface
 */
@property(strong) SDLSyncMsgVersion* syncMsgVersion;
/**
 * @abstract Mobile Application's Name, This name is displayed in the SDL&reg;
 * Mobile Applications menu. It also serves as the unique identifier of the
 * application for SmartDeviceLink
 *
 * <br/>appName<br/>
 *            a String value representing the Mobile Application's Name
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Must be 1-100 characters in length</li>
 *            <li>May not be the same (by case insensitive comparison) as
 *            the name or any synonym of any currently-registered
 *            application</li>
 *            </ul>
 */
@property(strong) NSString* appName;
/**
 * @abstract TTS string for VR recognition of the mobile application name
 * @since SmartDeviceLink 2.0
 */
@property(strong) NSMutableArray* ttsName;
/**
 * @abstract a String representing an abbreviated version of the mobile
 * applincation's name (if necessary) that will be displayed on the NGN
 * media screen
 *
 * <br/> ngnMediaScreenAppName<br/>
 *            a String value representing an abbreviated version of the
 *            mobile applincation's name
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Must be 1-5 characters</li>
 *            <li>If not provided, value will be derived from appName
 *            truncated to 5 characters</li>
 *            </ul>
 */
@property(strong) NSString* ngnMediaScreenAppName;
/**
 * @abstract A vrSynonyms representing the an array of 1-100 elements, each
 * element containing a voice-recognition synonym
 *
 * <br/> vrSynonyms<br/>
 *            a Vector<String> value representing the an array of 1-100
 *            elements
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Each vr synonym is limited to 40 characters, and there can
 *            be 1-100 synonyms in array</li>
 *            <li>May not be the same (by case insensitive comparison) as
 *            the name or any synonym of any currently-registered
 *            application</li>
 *            </ul>
 */
@property(strong) NSMutableArray* vrSynonyms;
/**
 * @abstract A Boolean to indicate a mobile application that is a media
 * application or not
 */
@property(strong) NSNumber* isMediaApplication;
/**
 * @abstract A Language enumeration indicating what language the application
 * intends to use for user interaction (Display, TTS and VR)
 */
@property(strong) SDLLanguage* languageDesired;
/**
 * @abstract An enumeration indicating what language the application intends to
 * use for user interaction ( Display)
 * @since SmartDeviceLink 2.0
 */
@property(strong) SDLLanguage* hmiDisplayLanguageDesired;
/**
 * @abstract A list of all applicable app types stating which classifications
 * to be given to the app. e.g. for platforms , like GEN2, this will
 * determine which "corner(s)" the app can populate
 *
 * <br/> appHMIType</br>
 *            a Vector<AppHMIType>
 *            <p>
 *            <b>Notes: </b>
 *            <ul>
 *            <li>Array Minsize: = 1</li>
 *            <li>Array Maxsize = 100</li>
 *            </ul>
 * @since SmartDeviceLink 2.0
 */
@property(strong) NSMutableArray* appHMIType;
@property(strong) NSString* hashID;
@property(strong) SDLDeviceInfo* deviceInfo;
/**
 * @abstract A unique ID, which an app will be given when approved
 *
 * <br/> appID<br/>
 *            a String value representing a unique ID, which an app will be
 *            given when approved 
 *            <p>
 *            <b>Notes: </b>Maxlength = 100
 * @since SmartDeviceLink 2.0
 */
@property(strong) NSString* appID;

@end
