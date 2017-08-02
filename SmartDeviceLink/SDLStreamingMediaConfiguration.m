//
//  SDLStreamingMediaConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaConfiguration.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLStreamingMediaConfiguration

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *_Nullable)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(NSDictionary<NSString *, id> *_Nullable)videoSettings {
    self = [super init];
    if (!self) {
        return nil;
    }

    _securityManagers = securityManagers;
    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;

    return self;
}

- (instancetype)initEnabledConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers customVideoEncoderSettings:(NSDictionary<NSString *, id> *_Nullable)customVideoEncoderSettings {
    SDLStreamingEncryptionFlag encryptionFlag = (securityManagers.count > 0) ? SDLStreamingEncryptionFlagAuthenticateAndEncrypt : SDLStreamingEncryptionFlagNone;

    return [self initWithSecurityManagers:securityManagers encryptionFlag:encryptionFlag videoSettings:customVideoEncoderSettings];
}

+ (instancetype)enabledConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers customVideoEncoderSettings:(NSDictionary<NSString *, id> *_Nullable)customVideoEncoderSettings {
    return [[self alloc] initEnabledConfigurationWithSecurityManagers:securityManagers customVideoEncoderSettings:customVideoEncoderSettings];
}

- (instancetype)initEnabledConfiguration {
    return [self initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil];
}

+ (instancetype)enabledConfiguration {
    return [[self alloc] initEnabledConfiguration];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithSecurityManagers:_securityManagers encryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings];
}

@end

NS_ASSUME_NONNULL_END
