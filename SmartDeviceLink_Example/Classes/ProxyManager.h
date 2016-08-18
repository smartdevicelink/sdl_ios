//
//  ProxyManager.h
//  SmartDeviceLink-iOS

#import <Foundation/Foundation.h>

@class SDLManager;
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
@property (strong, nonatomic) SDLManager *sdlManager;

+ (instancetype)sharedManager;
- (void)startIAP;
- (void)startTCP;
- (void)reset;

@end
