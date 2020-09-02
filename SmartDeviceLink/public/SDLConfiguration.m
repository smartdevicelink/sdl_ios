//
//  SDLConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/13/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLConfiguration.h"

#import "SDLFileManagerConfiguration.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLockScreenConfiguration.h"
#import "SDLLogConfiguration.h"
#import "SDLStreamingMediaConfiguration.h"
#import "SDLEncryptionConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLConfiguration

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [self initWithLifecycle:lifecycleConfiguration lockScreen:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:nil fileManager:nil encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig fileManager:nil encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig fileManager:fileManagerConfig encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig encryption:(nullable SDLEncryptionConfiguration *)encryptionConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:nil fileManager:fileManagerConfig encryption:encryptionConfig];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfiguration {
    return [self configurationWithLifecycle:lifecycleConfiguration lockScreen:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:nil fileManager:nil encryption:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig {
    return [self configurationWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig fileManager:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig fileManager:fileManagerConfig encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:streamingMediaConfig fileManager:nil encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig {
    return [self initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:streamingMediaConfig fileManager:fileManagerConfig encryption:nil];
}

- (instancetype)initWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig encryption:(nullable SDLEncryptionConfiguration *)encryptionConfig {
    self = [super init];
    if (!self) {
        return nil;
    }

    _lifecycleConfig = lifecycleConfig;
    _lockScreenConfig = lockScreenConfig ?: [SDLLockScreenConfiguration enabledConfiguration];
    _loggingConfig = logConfig ?: [SDLLogConfiguration defaultConfiguration];

    _streamingMediaConfig = streamingMediaConfig;
    if (_streamingMediaConfig != nil) {
        // If we have a streaming config, the apptype MUST be navigation or projection
        NSAssert(([_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation] || [_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeProjection] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeNavigation] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeProjection]), @"You should only set a streaming media configuration if your app is a NAVIGATION or PROJECTION HMI type");
        _streamingMediaConfig = streamingMediaConfig;
    } else {
        // If we don't have a streaming config, we MUST NOT be navigation or projection
        NSAssert(!([_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeNavigation] || [_lifecycleConfig.appType isEqualToEnum:SDLAppHMITypeProjection] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeNavigation] || [_lifecycleConfig.additionalAppTypes containsObject:SDLAppHMITypeProjection]), @"If your app is a NAVIGATION or PROJECTION HMI type, you must set a streaming media configuration on SDLConfiguration");
    }

    _fileManagerConfig = fileManagerConfig ?: [SDLFileManagerConfiguration defaultConfiguration];
    _encryptionConfig = encryptionConfig ?: [SDLEncryptionConfiguration defaultConfiguration];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    if (_encryptionConfig.securityManagers == nil && _streamingMediaConfig.securityManagers != nil) {
        _encryptionConfig.securityManagers = _streamingMediaConfig.securityManagers;
    }
#pragma clang diagnostic pop

    return self;
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig {
    return [self configurationWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:streamingMediaConfig fileManager:nil];
}

+ (instancetype)configurationWithLifecycle:(SDLLifecycleConfiguration *)lifecycleConfig lockScreen:(nullable SDLLockScreenConfiguration *)lockScreenConfig logging:(nullable SDLLogConfiguration *)logConfig streamingMedia:(nullable SDLStreamingMediaConfiguration *)streamingMediaConfig fileManager:(nullable SDLFileManagerConfiguration *)fileManagerConfig {
    return [[self alloc] initWithLifecycle:lifecycleConfig lockScreen:lockScreenConfig logging:logConfig streamingMedia:streamingMediaConfig fileManager:fileManagerConfig encryption:nil];
}

#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLConfiguration *new = [[SDLConfiguration allocWithZone:zone] initWithLifecycle:_lifecycleConfig lockScreen:_lockScreenConfig logging:_loggingConfig streamingMedia:_streamingMediaConfig fileManager:_fileManagerConfig encryption:_encryptionConfig];
    return new;
}

@end

NS_ASSUME_NONNULL_END
