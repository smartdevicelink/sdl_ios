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

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *_Nullable)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(NSDictionary<NSString *, id> *_Nullable)videoSettings;

- (instancetype)initEnabledConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers customVideoEncoderSettings:(NSDictionary<NSString *, id> *_Nullable)customVideoEncoderSettings;

+ (instancetype)enabledConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers customVideoEncoderSettings:(NSDictionary<NSString *, id> *_Nullable)customVideoEncoderSettings;

- (instancetype)initEnabledConfiguration;
+ (instancetype)enabledConfiguration;

@end

NS_ASSUME_NONNULL_END
