//
//  ProxyManager.h
//  SmartDeviceLink-iOS

@import SmartDeviceLink;

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ProxyTransportType) {
    ProxyTransportTypeUnknown,
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

@property (weak, nonatomic) SDLStreamingMediaManager *mediaManager;

@end
