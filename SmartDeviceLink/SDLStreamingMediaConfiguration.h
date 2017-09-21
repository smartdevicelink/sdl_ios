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
 *  Properties to use for applications that utilitze the video encoder for streaming.
 */
@property (copy, nonatomic, nullable) NSDictionary<NSString *, id> *customVideoEncoderSettings;

/**
 Usable to change run time video stream setup behavior. Only use this and modify the results if you *really* know what you're doing. The head unit defaults are generally good.
 */
@property (weak, nonatomic, nullable) id<SDLStreamingMediaManagerDataSource> dataSource;

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
 @return The configuration
 */
- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *_Nullable)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(NSDictionary<NSString *, id> *_Nullable)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource;

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
+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers;

/**
 Create an insecure video streaming configuration. No security managers will be provided and the encryption flag will be set to None. If you'd like custom video encoder settings, you can set the property manually. This is equivalent to `init`.

 @return The configuration
 */
+ (instancetype)insecureConfiguration NS_SWIFT_UNAVAILABLE("Use the standard initializer instead");

@end

NS_ASSUME_NONNULL_END
