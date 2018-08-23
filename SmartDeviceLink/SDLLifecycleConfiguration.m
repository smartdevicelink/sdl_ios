//
//  SDLManagerConfiguration.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleConfiguration.h"

#import "SDLFile.h"

static NSString *const DefaultTCPIPAddress = @"192.168.0.1";
static UInt16 const DefaultTCPIPPort = 12345;


NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleConfiguration ()

@property (assign, nonatomic, readwrite) BOOL tcpDebugMode;
@property (copy, nonatomic, readwrite, null_resettable) NSString *tcpDebugIPAddress;
@property (assign, nonatomic, readwrite) UInt16 tcpDebugPort;

@end


@implementation SDLLifecycleConfiguration

#pragma mark Lifecycle

+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId {
    return [[self alloc] initDefaultConfigurationWithAppName:appName fullAppId:@"" appId:appId];
}

+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId {
    return [[self alloc] initDefaultConfigurationWithAppName:appName fullAppId:fullAppId appId:@""];
}

+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(UInt16)port {
    return [self debugConfigurationWithAppName:appName fullAppId:@"" appId:appId ipAddress:ipAddress port:port];
}

+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId ipAddress:(NSString *)ipAddress port:(UInt16)port {
    return [self debugConfigurationWithAppName:appName fullAppId:fullAppId appId:@"" ipAddress:ipAddress port:port];
}

#pragma mark Initalization Helpers

- (instancetype)initDefaultConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId appId:(NSString *)appId  {
    self = [super init];
    if (!self) {
        return nil;
    }

    _tcpDebugMode = NO;
    _tcpDebugIPAddress = DefaultTCPIPAddress;
    _tcpDebugPort = DefaultTCPIPPort;

    _appName = appName;
    _appType = SDLAppHMITypeDefault;
    _language = SDLLanguageEnUs;
    _languagesSupported = @[_language];
    _appIcon = nil;
    _shortAppName = nil;
    _ttsName = nil;
    _voiceRecognitionCommandNames = nil;

    _fullAppId = fullAppId;
    _appId = appId;

    return self;
}

+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppID appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(UInt16)port {
    SDLLifecycleConfiguration *config = [[self alloc] initDefaultConfigurationWithAppName:appName fullAppId:fullAppID appId:appId];
    config.tcpDebugMode = YES;
    config.tcpDebugIPAddress = ipAddress;
    config.tcpDebugPort = port;

    return config;
}

#pragma mark - Computed Properties

- (BOOL)isMedia {
    if ([self.appType isEqualToEnum:SDLAppHMITypeMedia] || [self.additionalAppTypes containsObject:SDLAppHMITypeMedia]) {
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

- (void)setAppType:(nullable SDLAppHMIType)appType {
    if (appType == nil) {
        _appType = SDLAppHMITypeDefault;
        return;
    }

    _appType = appType;
}


#pragma mark - NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLifecycleConfiguration *newConfig = [[self.class allocWithZone:zone] initDefaultConfigurationWithAppName:_appName fullAppId:_fullAppId appId:_appId];
    newConfig->_tcpDebugMode = _tcpDebugMode;
    newConfig->_tcpDebugIPAddress = _tcpDebugIPAddress;
    newConfig->_tcpDebugPort = _tcpDebugPort;
    newConfig->_appType = _appType;
    newConfig->_additionalAppTypes = _additionalAppTypes;
    newConfig->_language = _language;
    newConfig->_languagesSupported = _languagesSupported;
    newConfig->_appIcon = _appIcon;
    newConfig->_shortAppName = _shortAppName;
    newConfig->_ttsName = _ttsName;
    newConfig->_voiceRecognitionCommandNames = _voiceRecognitionCommandNames;
    newConfig->_dayColorScheme = _dayColorScheme;
    newConfig->_nightColorScheme = _nightColorScheme;

    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
