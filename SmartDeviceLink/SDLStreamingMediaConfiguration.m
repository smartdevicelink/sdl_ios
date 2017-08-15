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

- (instancetype)initSecureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    NSAssert(securityManagers.count > 0, @"A secure streaming media configuration requires security managers to be passed.");
    SDLStreamingEncryptionFlag encryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;

    return [self initWithSecurityManagers:securityManagers encryptionFlag:encryptionFlag videoSettings:nil];
}

+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    return [[self alloc] initSecureConfigurationWithSecurityManagers:securityManagers];
}

- (instancetype)initInsecureConfiguration {
    return [self initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil];
}

+ (instancetype)insecureConfiguration {
    return [[self alloc] initInsecureConfiguration];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithSecurityManagers:_securityManagers encryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings];
}

@end

NS_ASSUME_NONNULL_END
