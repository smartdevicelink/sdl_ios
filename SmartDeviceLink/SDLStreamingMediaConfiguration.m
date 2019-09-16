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
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [self initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil rootViewController:nil];
#pragma clang diagnostic pop
}

+ (instancetype)secureConfiguration {
    return [[self alloc]  initWithEncryptionFlag:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoSettings:nil dataSource:nil rootViewController:nil];
}

+ (instancetype)insecureConfiguration {
    return [[self alloc] init];
}

- (instancetype)initWithSecurityManagers:(nullable NSArray<Class<SDLSecurityType>> *)securityManagers encryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *,id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource rootViewController:(nullable UIViewController *)rootViewController {
    self = [super init];
    if (!self) {
        return nil;
    }

    _securityManagers = securityManagers;
    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;
    _dataSource = dataSource;
    _rootViewController = rootViewController;
    _carWindowRenderingType = SDLCarWindowRenderingTypeLayer;
    _enableForcedFramerateSync = YES;
    _allowMultipleViewControllerOrientations = NO;

    return self;
}

- (instancetype)initWithEncryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *, id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource rootViewController:(nullable UIViewController *)rootViewController {
    if (!self) {
        return nil;
    }

    _securityManagers = nil;
    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;
    _dataSource = dataSource;
    _rootViewController = rootViewController;
    _carWindowRenderingType = SDLCarWindowRenderingTypeLayer;
    _enableForcedFramerateSync = YES;
    _allowMultipleViewControllerOrientations = NO;

    return self;
}

- (instancetype)initWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
    NSAssert(securityManagers.count > 0, @"A secure streaming media configuration requires security managers to be passed.");
    SDLStreamingEncryptionFlag encryptionFlag = SDLStreamingEncryptionFlagAuthenticateAndEncrypt;

    return [self initWithSecurityManagers:securityManagers encryptionFlag:encryptionFlag videoSettings:nil dataSource:nil rootViewController:nil];
}

+ (instancetype)secureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [[self alloc] initWithSecurityManagers:securityManagers];
#pragma clang diagnostic pop
}

+ (instancetype)autostreamingInsecureConfigurationWithInitialViewController:(UIViewController *)initialViewController {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    return [[self alloc] initWithSecurityManagers:nil encryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil rootViewController:initialViewController];
#pragma clang diagnostic pop
}

+ (instancetype)autostreamingSecureConfigurationWithSecurityManagers:(NSArray<Class<SDLSecurityType>> *)securityManagers initialViewController:(UIViewController *)initialViewController {
    return [[self alloc] initWithSecurityManagers:securityManagers encryptionFlag:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoSettings:nil dataSource:nil rootViewController:initialViewController];
}

+ (instancetype)autostreamingSecureConfigurationWithInitialViewController:(UIViewController *)initialViewController {
    return [[self alloc] initWithEncryptionFlag:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoSettings:nil dataSource:nil rootViewController:initialViewController];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    SDLStreamingMediaConfiguration *newConfig = [[self.class allocWithZone:zone] initWithSecurityManagers:_securityManagers encryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings dataSource:_dataSource rootViewController:_rootViewController];
#pragma clang diagnostic pop

    newConfig.carWindowRenderingType = self.carWindowRenderingType;
    newConfig.enableForcedFramerateSync = self.enableForcedFramerateSync;
    newConfig.allowMultipleViewControllerOrientations = self.allowMultipleViewControllerOrientations;
    
    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
