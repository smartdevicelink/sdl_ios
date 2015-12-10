//
//  ProxyManager.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

@class SDLRPCMessage;
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

extern NSString *const NotificationGetInteriorVehicleDataResponse;
extern NSString *const NotificationGetInteriorVehicleDataCapabilitiesResponse;
extern NSString *const NotificationButtonPressResponse;
extern NSString *const NotificationSetInteriorVehicleDataResponse;
extern NSString *const NotificationOnInteriorVehicleDataResponse;
extern NSString *const ProxyListenerNotificationObject;


@interface ProxyManager : NSObject

@property (assign, nonatomic, readonly) ProxyState state;

+ (instancetype)sharedManager;
- (void)startProxyWithTransportType:(ProxyTransportType)transportType;
- (void)resetProxyWithTransportType:(ProxyTransportType)transportType;
- (void)stopProxy;

- (void)sendMessage:(SDLRPCMessage *)message;

@property (strong, nonatomic, readonly) SDLStreamingMediaManager *mediaManager;

@end
