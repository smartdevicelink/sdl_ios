//
//  ProxyManager.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

@class SDLStreamingMediaManager;


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

@property (strong, nonatomic, readonly) SDLStreamingMediaManager *mediaManager;

@end
