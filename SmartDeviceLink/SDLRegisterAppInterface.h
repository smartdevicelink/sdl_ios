//  SDLRegisterAppInterface.h
//

#import "SDLRPCRequest.h"

#import "SDLAppHMIType.h"
#import "SDLLanguage.h"

@class SDLAppInfo;
@class SDLDeviceInfo;
@class SDLLifecycleConfiguration;
@class SDLSyncMsgVersion;
@class SDLTemplateColorScheme;
@class SDLTTSChunk;

/**
 * Registers the application's interface with SDL. The `RegisterAppInterface` RPC declares the properties of the app, including the messaging interface version, the app name, etc. The mobile application must establish its interface registration with SDL before any other interaction with SDL can take place. The registration lasts until it is terminated either by the application calling the `SDLUnregisterAppInterface` method, or by SDL sending an `SDLOnAppInterfaceUnregistered` notification, or by loss of the underlying transport connection, or closing of the underlying message transmission protocol RPC session.
 *
 * Until the application receives its first `SDLOnHMIStatus` notification, its `SDLHMILevel` is assumed to be `NONE`, the `SDLAudioStreamingState` is assumed to be `NOT_AUDIBLE`, and the `SDLSystemContext` is assumed to be `MAIN`.
 *
 * All SDL resources which the application creates or uses (e.g. choice sets, command menu, etc.) are associated with the application's interface registration. Therefore, when the interface registration ends, the SDL resources associated with the application are disposed of. As a result, even though the application itself may continue to run on its host platform (e.g. mobile device) after the interface registration terminates, the application will not be able to use the SDL HMI without first establishing a new interface registration and re-creating its required SDL resources. That is, SDL resources created by (or on behalf of) an application do not persist beyond the life-span of the interface registration. Resources and settings whose lifespan is tied to the duration of an application's interface registration include: choice sets, command menus, and the media clock timer display value
 *
 * If the application intends to stream audio it is important to indicate so via the `isMediaApp` parameter. When set to true, audio will reliably stream without any configuration required by the user. When not set, audio may stream, depending on what the user might have manually configured as a media source on SDL.
 *
 * @since SDL 1.0
 *
 * @see SDLUnregisterAppInterface, SDLOnAppInterfaceUnregistered
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLRegisterAppInterface : SDLRPCRequest

/**
 * Convenience init for registering the application with a lifecycle configuration.
 *
 * @param lifecycleConfiguration Configuration options for SDLManager
 */
- (instancetype)initWithLifecycleConfiguration:(SDLLifecycleConfiguration *)lifecycleConfiguration;

/**
 * Convenience init for registering the application.
 *
 * @param appName                   The mobile application's name
 * @param appId                     An appId used to validate app with policy table entries
 * @param languageDesired           The language the application intends to use for user interaction
 * @return                          A SDLRegisterAppInterface object
 */
- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired;

/**
 * Convenience init for registering the application.
 *
 * @param appName                   The mobile application's name
 * @param appId                     An appId used to validate app with policy table entries
 * @param languageDesired           The language the application intends to use for user interaction
 * @param isMediaApp                Indicates if the application is a media or a non-media application
 * @param appTypes                  A list of all applicable app types stating which classifications to be given to the app
 * @param shortAppName              An abbreviated version of the mobile application's name
 * @return                          A SDLRegisterAppInterface object
 */
- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName __deprecated_msg(("Use initWithAppName:appId:fullAppId:languageDesired:isMediaApp:appTypes:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash:dayColorScheme:nightColorScheme: instead"));

/**
 * Convenience init for registering the application.
 *
 * @param appName                   The mobile application's name
 * @param appId                     An appId used to validate app with policy table entries
 * @param languageDesired           The language the application intends to use for user interaction
 * @param isMediaApp                Indicates if the application is a media or a non-media application
 * @param appTypes                  A list of all applicable app types stating which classifications to be given to the app
 * @param shortAppName              An abbreviated version of the mobile application's name
 * @param ttsName                   TTS string for VR recognition of the mobile application name
 * @param vrSynonyms                Additional voice recognition commands
 * @param hmiDisplayLanguageDesired Current app's expected VR+TTS language
 * @param resumeHash                ID used to uniquely identify current state of all app data that can persist through connection cycles
 * @return                          A SDLRegisterAppInterface object
 */
- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash __deprecated_msg(("Use initWithAppName:appId:fullAppId:languageDesired:isMediaApp:appTypes:shortAppName:ttsName:vrSynonyms:hmiDisplayLanguageDesired:resumeHash:dayColorScheme:nightColorScheme: instead"));

/**
 * Convenience init for registering the application with all possible options.
 *
 * @param appName                   The mobile application's name
 * @param appId                     An appId used to validate app with policy table entries
 * @param fullAppId                 A full UUID appID used to validate app with policy table entries.
 * @param languageDesired           The language the application intends to use for user interaction
 * @param isMediaApp                Indicates if the application is a media or a non-media application
 * @param appTypes                  A list of all applicable app types stating which classifications to be given to the app
 * @param shortAppName              An abbreviated version of the mobile application's name
 * @param ttsName                   TTS string for VR recognition of the mobile application name
 * @param vrSynonyms                Additional voice recognition commands
 * @param hmiDisplayLanguageDesired Current app's expected VR+TTS language
 * @param resumeHash                ID used to uniquely identify current state of all app data that can persist through connection cycles
 * @param dayColorScheme            The color scheme to be used on a head unit using a "light" or "day" color scheme.
 * @param nightColorScheme          The color scheme to be used on a head unit using a "dark" or "night" color scheme
 * @return                          A SDLRegisterAppInterface object
 */
- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId fullAppId:(nullable NSString *)fullAppId languageDesired:(SDLLanguage)languageDesired isMediaApp:(BOOL)isMediaApp appTypes:(NSArray<SDLAppHMIType> *)appTypes shortAppName:(nullable NSString *)shortAppName ttsName:(nullable NSArray<SDLTTSChunk *> *)ttsName vrSynonyms:(nullable NSArray<NSString *> *)vrSynonyms hmiDisplayLanguageDesired:(SDLLanguage)hmiDisplayLanguageDesired resumeHash:(nullable NSString *)resumeHash dayColorScheme:(nullable SDLTemplateColorScheme *)dayColorScheme nightColorScheme:(nullable SDLTemplateColorScheme *)nightColorScheme;

/**
 * The version of the SDL interface
 *
 * Required
 */
@property (strong, nonatomic) SDLSyncMsgVersion *syncMsgVersion;

/**
 * The mobile application's name. This name is displayed in the SDL Mobile Applications menu. It also serves as the unique identifier of the application for SmartDeviceLink.
 *
 * 1. Needs to be unique over all applications. Applications with the same name will be rejected.
 * 2. May not be empty.
 * 3. May not start with a new line character.
 * 4. May not interfere with any name or synonym of previously registered applications and any predefined blacklist of words (global commands).
 *
 * Required, Max length 100 chars
 */
@property (strong, nonatomic) NSString *appName;

/**
 * TTS string for VR recognition of the mobile application name.
 *
 * @discussion Meant to overcome any failing on speech engine in properly pronouncing / understanding app name.
 * 1. Needs to be unique over all applications.
 * 2. May not be empty.
 * 3. May not start with a new line character.
 *
 * Optional, Array of SDLTTSChunk, Array size 1 - 100
 *
 * @since SDL 2.0
 * @see SDLTTSChunk
 */
@property (nullable, strong, nonatomic) NSArray<SDLTTSChunk *> *ttsName;

/**
 * A String representing an abbreviated version of the mobile application's name (if necessary) that will be displayed on the media screen.
 *
 * @discussion If not provided, the appName is used instead (and will be truncated if too long)
 *
 * Optional, Max length 100 chars
 */
@property (nullable, strong, nonatomic) NSString *ngnMediaScreenAppName;

/**
 * Defines additional voice recognition commands
 *
 * @discussion May not interfere with any app name of previously registered applications and any predefined blacklist of words (global commands).
 *
 * Optional, Array of Strings, Array length 1 - 100, Max String length 40
 */
@property (nullable, strong, nonatomic) NSArray<NSString *> *vrSynonyms;

/**
 * Indicates if the application is a media or a non-media application.
 *
 * @discussion Only media applications will be able to stream audio to head units that is audible outside of the BT media source.
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *isMediaApplication;

/**
 * A Language enumeration indicating what language the application intends to use for user interaction (TTS and VR).
 *
 * @discussion If there is a mismatch with the head unit, the app will be able to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Required
 */
@property (strong, nonatomic) SDLLanguage languageDesired;

/**
 * An enumeration indicating what language the application intends to use for user interaction (Display).
 *
 * @discussion If there is a mismatch with the head unit, the app will be able to change this registration with changeRegistration prior to app being brought into focus.
 *
 * Required
 *
 * @since SDL 2.0
 */
@property (strong, nonatomic) SDLLanguage hmiDisplayLanguageDesired;

/**
 * A list of all applicable app types stating which classifications to be given to the app.
 *
 * Optional, Array of SDLAppHMIType, Array size 1 - 100
 *
 * @since SDL 2.0
 * @see SDLAppHMIType
 */
@property (nullable, strong, nonatomic) NSArray<SDLAppHMIType> *appHMIType;

/**
 * ID used to uniquely identify current state of all app data that can persist through connection cycles (e.g. ignition cycles).
 *
 * @discussion This registered data (commands, submenus, choice sets, etc.) can be reestablished without needing to explicitly reregister each piece. If omitted, then the previous state of an app's commands, etc. will not be restored. 
 *
 * When sending hashID, all RegisterAppInterface parameters should still be provided (e.g. ttsName, etc.).
 *
 * Optional, max length 100 chars
 */
@property (nullable, strong, nonatomic) NSString *hashID;

/**
 * Information about the connecting device
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLDeviceInfo *deviceInfo;

/**
 * ID used to validate app with policy table entries
 *
 * Required, max length 100
 *
 * @see `fullAppID`
 *
 * @since SDL 2.0
 */
@property (strong, nonatomic) NSString *appID;

/**
 * A full UUID appID used to validate app with policy table entries.
 *
 *  Optional
 *
 *  @discussion  The `fullAppId` is used to authenticate apps that connect with head units that implement SDL Core v.5.0 and newer. If connecting with older head units, the `fullAppId` can be truncated to create the required `appId` needed to register the app. The `appId` is the first 10 non-dash ("-") characters of the `fullAppID` (e.g. if you have a `fullAppId` of 123e4567-e89b-12d3-a456-426655440000, the `appId` will be 123e4567e8).
 */
@property (nullable, strong, nonatomic) NSString *fullAppID;

/**
 * Information about the application running
 *
 * Optional
 */
@property (nullable, strong, nonatomic) SDLAppInfo *appInfo;

/**
 * The color scheme to be used on a head unit using a "light" or "day" color scheme. The OEM may only support this theme if their head unit only has a light color scheme.
 *
 * Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *dayColorScheme;

/**
 * The color scheme to be used on a head unit using a "dark" or "night" color scheme. The OEM may only support this theme if their head unit only has a dark color scheme.
 *
 * Optional
 */
@property (strong, nonatomic, nullable) SDLTemplateColorScheme *nightColorScheme;

@end

NS_ASSUME_NONNULL_END
