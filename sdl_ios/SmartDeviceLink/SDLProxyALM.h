//
//  SDLProxyALM.h
//  SmartDeviceLink
//
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProxyBase.h>
#import <SmartDeviceLink/SDLProxyListener.h>

@interface SDLProxyALM : SDLProxyBase

-(instancetype)init NS_UNAVAILABLE;

/*!
 * @brief Initializes proxy for communicating between the App and SDL.
 *
 * @discussion Disconnects the application from SDL, then recreates the transport such that
 *             the next time a SDL unit discovers applications, this application will be
 *             available.
 *
 * @param Delegate that receives callbacks from SDL.
 *
 * @param appName - Name of the application displayed on SDL.
 *
 * @param isMediaApp - Indicates if the app is a media application.
 *
 * @param appID - Name of the application displayed on SDL.
 *
 * @param options - An optional dictionary specifying options for the proxy.
 *
 * @see SDLProxyALMConstants.h for valid options keys
 */
-(instancetype)initWithProxyDelegate:(id<SDLProxyListener>)delegate
                             appName:(NSString*)appName
                          isMediaApp:(NSNumber*)isMediaApp
                               appID:(NSString*)appID
                             options:(NSDictionary*)options NS_DESIGNATED_INITIALIZER;

/*!
 * @brief Allow applications using ALM to reset the proxy (dispose and reinstantiate)
 *
 * @discussion Disconnects the application from SDL, then recreates the transport such that
               the next time a SDL unit discovers applications, this application will be
               available.
 */
-(void)resetProxy;

/*!
 * @brief Gets buttonCapabilities set when application interface is registered.
 *
 * @return A list of <code>SDLButtonCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* buttonCapabilities;

/*!
 * @brief Gets softButtonCapabilities set when application interface is registered.
 *
 * @return A list of <code>SDLSoftButtonCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* softButtonCapabilities;

/*!
 * @brief Gets hmiZoneCapabilities set when application interface is registered.
 *
 * @return A list of <code>SDLHMIZoneCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* hmiZoneCapabilities;

/*!
 * @brief Gets speechCapabilities set when application interface is registered.
 *
 * @return A list of <code>SDLSpeechCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* speechCapabilities;

/*!
 * @brief Gets prerecordedSpeech set when application interface is registered.
 *
 * @return A list of <code>SDLPrerecordedSpeechCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* prerecordedSpeech;

/*!
 * @brief Gets vrCapabilities set when application interface is registered.
 *
 * @return A list of <code>SDLVrCapabilities</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* vrCapabilities;

/*!
 * @brief Gets supportedDiagModes set when application interface is registered.
 *
 * @return A list of <code>SDLSupportedDiagModes</code> objects.
 */
@property (strong, nonatomic, readonly) NSArray* supportedDiagModes;

/*!
 * @brief Gets the current version information of the proxy.
 */
@property (strong, nonatomic, readonly) NSString* proxyVersionInfo;

/*!
 * @brief Gets presetBankCapabilities set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLPresetBankCapabilities* presetBankCapabilities;

/*!
 * @brief Gets displayCapabilities set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLDisplayCapabilities* displayCapabilities;

/*!
 * @brief Gets sdlLanguage set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLLanguage* sdlLanguage;

/*!
 * @brief Gets hmiDisplayLanguage set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLLanguage* hmiDisplayLanguage;

/*!
 * @brief Gets sdlSyncMsgVersion set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLSyncMsgVersion* sdlSyncMsgVersion;

/*!
 * @brief Gets vehicleType set when application interface is registered.
 */
@property (strong, nonatomic, readonly) SDLVehicleType* vehicleType;

/*!
 * @brief Gets vehicleType set when application interface is registered.
 */
@property (nonatomic, readonly, getter=isAppResumeSuccess) BOOL appResumeSuccess;

@end