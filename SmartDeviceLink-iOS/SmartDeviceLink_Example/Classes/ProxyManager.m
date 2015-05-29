//
//  ProxyManager.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/16/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import "ProxyManager.h"

@import SmartDeviceLink;

#import "Preferences.h"


NSString *const SDLAppName = @"SDL Test";
NSString *const SDLAppId = @"9999";


@interface ProxyManager () <SDLProxyListener>

@property (strong, nonatomic) SDLProxy *proxy;
@property (assign, nonatomic, readwrite) ProxyState state;
@property (assign, nonatomic) BOOL isFirstHMIFull;

@end


@implementation ProxyManager

#pragma mark - Initialization

+ (instancetype)sharedManager {
    static ProxyManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[ProxyManager alloc] init];
    });
    
    return sharedManager;
}

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    _state = ProxyStateStopped;
    
    return self;
}


#pragma mark - Public Proxy Setup

- (void)resetProxyWithTransportType:(ProxyTransportType)transportType {
    [self stopProxy];
    [self startProxyWithTransportType:transportType];
}


#pragma mark - Private Proxy Setup

- (void)startProxyWithTransportType:(ProxyTransportType)transportType {
    if (self.proxy != nil) {
        return;
    }
    
    self.isFirstHMIFull = YES;
    self.state = ProxyStateSearchingForConnection;
    
    switch (transportType) {
        case ProxyTransportTypeTCP: {
            self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self tcpIPAddress:[Preferences sharedPreferences].ipAddress tcpPort:[Preferences sharedPreferences].port];
        } break;
        case ProxyTransportTypeIAP: {
            self.proxy = [SDLProxyFactory buildSDLProxyWithListener:self];
        } break;
        default: NSAssert(NO, @"Unknown transport setup: %@", @(transportType));
    }
}

- (void)stopProxy {
    self.state = ProxyStateStopped;
    
    if (self.proxy != nil) {
        [self.proxy dispose];
        self.proxy = nil;
    }
}

- (void)showInitialData {
    SDLShow *showRPC = [SDLRPCRequestFactory buildShowWithMainField1:@"SDL" mainField2:@"Test" alignment:[SDLTextAlignment CENTERED] correlationID:[self nextCorrelationID]];
    [self.proxy sendRPC:showRPC];
}


#pragma mark - Private Proxy Helpers

- (NSNumber *)nextCorrelationID {
    static NSInteger _correlationID = 1;
    return @(_correlationID++);
}

- (UInt32)nextMessageNumber {
    static UInt32 _messageNumber = 1;
    return _messageNumber++;
}


#pragma mark - SDLProxyListner delegate methods

- (void)onProxyOpened {
    self.state = ProxyStateConnected;
    
    SDLRegisterAppInterface *registerRequest = [SDLRPCRequestFactory buildRegisterAppInterfaceWithAppName:SDLAppName languageDesired:[SDLLanguage EN_US] appID:SDLAppId];
    [self.proxy sendRPC:registerRequest];
}

- (void)onProxyClosed {
    [self stopProxy];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    if ((notification.hmiLevel == [SDLHMILevel FULL]) && self.isFirstHMIFull) {
        [self showInitialData];
        self.isFirstHMIFull = NO;
    }
}

@end
