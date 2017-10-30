//
//  SDLStreamingMediaConfiguration.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLStreamingMediaManagerConstants.h"

@protocol SDLSecurityType;
@protocol SDLStreamingMediaManagerDataSource;


NS_ASSUME_NONNULL_BEGIN

@interface SDLStreamingMediaConfiguration : NSObject <NSCopying>

/**
 *  Set security managers which could be used. This is primarily used with video streaming applications to authenticate and perhaps encrypt traffic data.
 */
@property (copy, nonatomic, nullable) NSArray<Class<SDLSecurityType>> *securityManagers;

/**
 *  What encryption level video/audio streaming should be. The default is SDLStreamingEncryptionFlagAuthenticateAndEncrypt.
 */
@property (assign, nonatomic) SDLStreamingEncryptionFlag maximumDesiredEncryption;

/**
 *  Properties to use for applications that utilitze the video encoder for streaming. See VTCompressionProperties.h for more details. For example, you can set kVTCompressionPropertyKey_ExpectedFrameRate to set your expected framerate.
 */
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *customVideoEncoderSettings;

/**
 Usable to change run time video stream setup behavior. Only use this and modify the results if you *really* know what you're doing. The head unit defaults are generally good.
 */
@property (weak, nonatomic, nullable) id<SDLStreamingMediaManagerDataSource> dataSource;

/**
 Set the window your video streaming content is within.

 Activates the haptic view parser when set. If the window contains `UIView` based views, these will be discovered and automatically sent to the head unit if it uses a haptic interface. Whether or not it supports the haptic interace, this library will also use that information to attempt to return the touched view to you in `SDLTouchManagerDelegate`.

 @warning Apps using views outside of the `UIView` heirarchy (such as OpenGL) are currently unsupported. If you app uses partial views in the heirarchy, only those views will be discovered. Your OpenGL views will not be discoverable to a haptic interface head unit and you will have to manually make these views discoverable via the `SDLSendHapticData` RPC request.

 @warning This is a weak property and it's therefore your job to hold a strong reference to this window.
 */
@property (weak, nonatomic, nullable) UIWindow *window;

/**
 Create an insecure video streaming configuration. No security managers will be provided and the encryption flag will be set to None. If you'd like custom video encoder settings, you can set the property manually.

 @return The configuration
 */
- (instancetype)init;

/**
 Manually set all the properties to the streaming media configuration

 @param securityManagers The security managers to use or nil for none.
 @param encryptionFlag The maximum encrpytion supported. If the connected head unit supports less than set here, it will still connect, but if it supports more than set here, it will not connect.
 @param videoSettings Custom video encoder settings to be used in video streaming.
 @param window The UIWindow you are running the content that is being streamed on, to use for haptics if needed and possible (only works for UIViews)
 @return The configuration
 */
- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *, id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource window:(nullable UIWindow *)window;

/**
 Create a secure configuration for each of the security managers provided.

 @param securityManagers The security managers to be used. The encryption flag will be set to AuthenticateAndEncrypt if any security managers are set.
 @return The configuration
 */
- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers;

/**
 Create a secure configuration for each of the security managers provided.

 @param securityManagers The security managers to be used. The encryption flag will be set to AuthenticateAndEncrypt if any security managers are set.
 @return The configuration
 */
+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers NS_SWIFT_UNAVAILABLE("Use an initializer instead");

/**
 Create an insecure video streaming configuration. No security managers will be provided and the encryption flag will be set to None. If you'd like custom video encoder settings, you can set the property manually. This is equivalent to `init`.

 @return The configuration
 */
+ (instancetype)insecureConfiguration NS_SWIFT_UNAVAILABLE("Use the standard initializer instead");

@end

NS_ASSUME_NONNULL_END
