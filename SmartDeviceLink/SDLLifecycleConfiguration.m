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

- (instancetype)initDefaultConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppId {
    self = [super init];
    if (!self) {
        return nil;
    }

    _tcpDebugMode = NO;
    _tcpDebugIPAddress = DefaultTCPIPAddress;
    _tcpDebugPort = DefaultTCPIPPort;

    _appName = appName;
    _fullAppId = fullAppId;
    _appId = fullAppId;

    _appType = SDLAppHMITypeDefault;
    _language = SDLLanguageEnUs;
    _languagesSupported = @[_language];
    _appIcon = nil;
    _shortAppName = nil;
    _ttsName = nil;
    _voiceRecognitionCommandNames = nil;

    return self;
}

// j old
+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId {
    return [self defaultConfigurationWithAppName:appName fullAppId:appId];
}

// j new
+ (SDLLifecycleConfiguration *)defaultConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppID {
    return [[self alloc] initDefaultConfigurationWithAppName:appName fullAppId:fullAppID];
}

// k old
+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName appId:(NSString *)appId ipAddress:(NSString *)ipAddress port:(UInt16)port {
    return [self debugConfigurationWithAppName:appName fullAppId:appId ipAddress:ipAddress port:port];
}

// k new
+ (SDLLifecycleConfiguration *)debugConfigurationWithAppName:(NSString *)appName fullAppId:(NSString *)fullAppID ipAddress:(NSString *)ipAddress port:(UInt16)port {
    SDLLifecycleConfiguration *config = [[self alloc] initDefaultConfigurationWithAppName:appName fullAppId:fullAppID];
    config.tcpDebugMode = YES;
    config.tcpDebugIPAddress = ipAddress;
    config.tcpDebugPort = port;

    return config;
}

#pragma mark Computed Properties

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


#pragma mark NSCopying

- (id)copyWithZone:(nullable NSZone *)zone {
    SDLLifecycleConfiguration *newConfig = [[self.class allocWithZone:zone] initDefaultConfigurationWithAppName:_appName fullAppId:_fullAppId];
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
    newConfig->_appId = _appId;

    return newConfig;
}

@end

NS_ASSUME_NONNULL_END
