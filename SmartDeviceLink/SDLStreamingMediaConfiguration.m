//
//  SDLStreamingMediaConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLStreamingMediaConfiguration.h"

#import "SDLStreamingMediaManagerDataSource.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLStreamingMediaConfiguration

- (instancetype)init {
    return [self initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil window:nil];
}

+ (instancetype)insecureConfiguration {
    return [[self alloc] init];
}

- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *,id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource window:(nullable UIWindow *)window {
    self = [super init];
    if (!self) {
        return nil;
    }

    _securityManagers = securityManagers;
    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;
    _dataSource = dataSource;
    _window = window;

    return self;
}

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    NSAssert(securityManagers.count > 0, @"A secure streaming media configuration requires security managers to be passed.");
    SDLStreamingEncryptionFlag encryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;

    return [self initWithSecurityManagers:securityManagers encryptionFlag:encryptionFlag videoSettings:nil dataSource:nil window:nil];
}

+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    return [[self alloc] initWithSecurityManagers:securityManagers];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithSecurityManagers:_securityManagers encryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings dataSource:_dataSource window:_window];
}

@end

NS_ASSUME_NONNULL_END
