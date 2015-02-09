//
//  SDLProxyALMConstants.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  @const  SDLProxyALMLanguageDesiredKey
 *
 *  @discussion A SDLLanguage indicating the language desired for the SDL interface.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMLanguageDesiredKey;

/*!
 *  @const  SDLProxyALMHMIDisplayLanguageDesiredKey
 *
 *  @discussion A SDLLanguage indicating the language desired for the HMI.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMHMIDisplayLanguageDesiredKey;

/*!
 *  @const  SDLProxyALMVrSynonymsKey
 *
 *  @discussion A NSArray of NSStrings, all of which can be used as voice commands as well.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 *  @seealso    //TODO: Change link here. For VrSynonym NSString format see: @link linkMethod:goesHere: @/link
 */
extern NSString * const SDLProxyALMVrSynonymsKey;

/*!
 *  @const  SDLProxyALMSDLMsgVersionKey
 *
 *  @discussion A SDLMsgVersion indicating the version of SDL Messages desired. Must be less than or equal to the version of SDL running on the vehicle.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMSDLMsgVersionKey;

/*!
 *  @const  SDLProxyALMTTSNameKey
 *
 *  @discussion A NSArray of SDLTTSChunks indicating the TTS name.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMTTSNameKey;

/*!
 *  @const  SDLProxyALMNGNMediaScreenAppNameKey
 *
 *  @discussion A NSString indicating the name of the application displayed on SDL for Navigation equipped vehicles. Limited to five characters.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMNGNMediaScreenAppNameKey;

/*!
 *  @const  SDLProxyALMAutoActivateIDKey
 *
 *  @discussion A NSString indicating the ID used to re-register previously registered applications.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMAutoActivateIDKey;

/*!
 *  @const  SDLProxyALMCallbackToMainQueueKey
 *
 *  @discussion A NSNumber (Boolean) if true, all callbacks will occur on the main queue.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMCallbackToMainQueueKey;

/*!
 *  @const  SDLProxyALMSDLProxyConfigurationResourcesKey
 *
 *  @discussion A SDLProxyConfigurationResources to configure proxy resources.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMSDLProxyConfigurationResourcesKey;

/*!
 *  @const  SDLProxyALMPreRegisterKey
 *
 *  @discussion A NSNumber (Boolean) flag that indicates that the client should be pre-registered or not.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMPreRegisterKey;

/*!
 *  @const  SDLProxyALMTransportConfigKey
 *
 *  @discussion A SDLBaseTransportConfig that provides the initial configuration for transport.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMTransportConfigKey;

/*!
 *  @const  SDLProxyALMAppTypeKey
 *
 *  @discussion A SDLAppHMIType indicating the type of application.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMAppTypeKey;

/*!
 *  @const  SDLProxyALMHashIDKey
 *
 *  @discussion A NSString HashID used for app resumption.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMHashIDKey;

/*!
 *  @const  SDLProxyALMAppResumeEnabledKey
 *
 *  @discussion A NSNumber (Boolean) flag that indicates that the app resume is enabled or not.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMAppResumeEnabledKey;

/*!
 *  @const  SDLProxyALMIsMediaAppKey
 *
 *  @discussion A NSNumber (Boolean) flag that indicates that the app is a media application.
 *
 *  @see		initWithProxyDelegate:appName:isMediaApp:appID:options:
 */
extern NSString * const SDLProxyALMIsMediaAppKey;
