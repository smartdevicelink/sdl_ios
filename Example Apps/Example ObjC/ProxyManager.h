//
//  ProxyManager.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>
#import "SDLTCPConfig.h"

@class SDLManager;

typedef NS_ENUM(NSUInteger, ProxyTransportType) {
    ProxyTransportTypeTCP,
    ProxyTransportTypeIAP
};

typedef NS_ENUM(NSUInteger, ProxyState) {
    ProxyStateStopped,
    ProxyStateSearchingForConnection,
    ProxyStateConnected
};

NS_ASSUME_NONNULL_BEGIN

@interface ProxyManager : NSObject

@property (assign, nonatomic, readonly) ProxyState state;
@property (strong, nonatomic, nullable) SDLManager *sdlManager;

+ (instancetype)sharedManager;
- (void)startWithProxyTransportType:(ProxyTransportType)proxyTransportType;
- (void)startProxyTCP:(SDLTCPConfig*)tcpConfig;
- (void)stopConnection;

@end

NS_ASSUME_NONNULL_END
