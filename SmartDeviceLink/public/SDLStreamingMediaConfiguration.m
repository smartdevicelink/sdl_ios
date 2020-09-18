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
    return [self initWithEncryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil rootViewController:nil];
}

+ (instancetype)secureConfiguration {
    return [[self alloc] initWithEncryptionFlag:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoSettings:nil dataSource:nil rootViewController:nil];
}

+ (instancetype)insecureConfiguration {
    return [[self alloc] init];
}

- (instancetype)initWithEncryptionFlag:(SDLStreamingEncryptionFlag)encryptionFlag videoSettings:(nullable NSDictionary<NSString *, id> *)videoSettings dataSource:(nullable id<SDLStreamingMediaManagerDataSource>)dataSource rootViewController:(nullable UIViewController *)rootViewController {
    if (!self) {
        return nil;
    }

    _maximumDesiredEncryption = encryptionFlag;
    _customVideoEncoderSettings = videoSettings;
    _dataSource = dataSource;
    _rootViewController = rootViewController;
    _carWindowRenderingType = SDLCarWindowRenderingTypeLayer;
    _enableForcedFramerateSync = YES;
    _allowMultipleViewControllerOrientations = NO;

    return self;
}

+ (instancetype)autostreamingInsecureConfigurationWithInitialViewController:(UIViewController *)initialViewController {
    return [[self alloc] initWithEncryptionFlag:SDLStreamingEncryptionFlagNone videoSettings:nil dataSource:nil rootViewController:initialViewController];
}

+ (instancetype)autostreamingSecureConfigurationWithInitialViewController:(UIViewController *)initialViewController {
    return [[self alloc] initWithEncryptionFlag:SDLStreamingEncryptionFlagAuthenticateAndEncrypt videoSettings:nil dataSource:nil rootViewController:initialViewController];
}

#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLStreamingMediaConfiguration *newConfig = [[self.class allocWithZone:zone] initWithEncryptionFlag:_maximumDesiredEncryption videoSettings:_customVideoEncoderSettings dataSource:_dataSource rootViewController:_rootViewController];

    newConfig.carWindowRenderingType = self.carWindowRenderingType;
    newConfig.enableForcedFramerateSync = self.enableForcedFramerateSync;
    newConfig.allowMultipleViewControllerOrientations = self.allowMultipleViewControllerOrientations;
    
    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
