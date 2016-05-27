//
//  SDLManagerConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleConfiguration.h"

#import "SDLAppHMIType.h"
#import "SDLFile.h"
#import "SDLLanguage.h"

static NSString *const DefaultTCPIPAddress = @"192.168.0.1";
static NSString *const DefaultTCPIPPort = @"12345";


NS_ASSUME_NONNULL_BEGIN

@implementation SDLLifecycleConfiguration

#pragma mark Lifecycle

- (instancetype)initWithAppName:(NSString *)appName appId:(NSString *)appId {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _tcpDebugMode = NO;
    _tcpDebugIPAddress = DefaultTCPIPAddress;
    _tcpDebugPort = DefaultTCPIPPort;
    
    _appName = appName;
    _appId = appId;
    
    _appType = [SDLAppHMIType DEFAULT];
    _language = [SDLLanguage EN_US];
    _languagesSupported = @[_language];
    _shortAppName = nil;
    _ttsName = nil;
    _voiceRecognitionSynonyms = @[];
    
    return self;
}

+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId {
    return [[self alloc] initWithAppName:appName appId:appId];
}

+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(NSString *)port {
    SDLLifecycleConfiguration *config = [[self alloc] initWithAppName:appName appId:appId];
    config.tcpDebugIPAddress = ipAddress;
    config.tcpDebugPort = port;
    
    return config;
}

#pragma mark Computed Properties

- (BOOL)isMedia {
    if ([self.appType isEqualToEnum:[SDLAppHMIType MEDIA]]) {
        return YES;
    }
    
    return NO;
}

- (void)setTcpDebugIPAddress:(nullable NSString *)tcpDebugIPAddress {
    if (tcpDebugIPAddress == nil) {
        _tcpDebugIPAddress = DefaultTCPIPAddress;
    } else {
        _tcpDebugIPAddress = tcpDebugIPAddress;
    }
}

- (void)setTcpDebugPort:(nullable NSString *)tcpDebugPort {
    if (tcpDebugPort == nil) {
        _tcpDebugPort = DefaultTCPIPPort;
    } else {
        _tcpDebugPort = tcpDebugPort;
    }
}

- (void)setAppType:(nullable SDLAppHMIType *)appType {
    if (appType == nil) {
        _appType = [SDLAppHMIType DEFAULT];
    }
    
    _appType = appType;
}

- (void)setPersistentFiles:(NSArray<SDLFile *> *)persistentFiles {
    for (SDLFile *file in persistentFiles) {
        if (!file.persistent) {
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:NSLocalizedString(@"SDLLifecycleConfiguration persistentFiles must all be persistent; non-persistent file found", nil) userInfo:@{@"Error": file}];
        }
    }
}


#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLifecycleConfiguration *newConfig = [[self.class allocWithZone:zone] initWithAppName:_appName appId:_appId];
    newConfig -> _tcpDebugMode = _tcpDebugMode;
    newConfig -> _tcpDebugIPAddress = _tcpDebugIPAddress;
    newConfig -> _tcpDebugPort = _tcpDebugPort;
    newConfig -> _appType = _appType;
    newConfig -> _language = _language;
    newConfig -> _languagesSupported = _languagesSupported;
    newConfig -> _shortAppName = _shortAppName;
    newConfig -> _ttsName = _ttsName;
    newConfig -> _voiceRecognitionSynonyms = _voiceRecognitionSynonyms;
    
    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
