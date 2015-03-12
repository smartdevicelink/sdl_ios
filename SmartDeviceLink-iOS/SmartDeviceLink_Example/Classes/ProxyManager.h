//
//  ProxyManager.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 2/16/15.
//  Copyright (c) 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ProxyTransportType) {
    ProxyTransportTypeTCP,
    ProxyTransportTypeIAP
};

typedef NS_ENUM(NSUInteger, ProxyState) {
    ProxyStateStopped,
    ProxyStateSearchingForConnection,
    ProxyStateConnected
};


@interface ProxyManager : NSObject

@property (assign, nonatomic, readonly) ProxyState state;

+ (instancetype)sharedManager;
- (void)startProxyWithTransportType:(ProxyTransportType)transportType;
- (void)resetProxyWithTransportType:(ProxyTransportType)transportType;
- (void)stopProxy;

@end
