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

typedef NS_ENUM(NSUInteger, SDLHMIFirstState) {
	SDLHMIFirstStateNone,
	SDLHMIFirstStateNonNone,
	SDLHMIFirstStateFull
};

typedef NS_ENUM(NSUInteger, SDLHMIInitialShowState) {
	SDLHMIInitialShowStateNone,
	SDLHMIInitialShowStateDataAvailable,
	SDLHMIInitialShowStateShown
};

@interface ProxyManager : NSObject

@property (assign, nonatomic, readonly) ProxyState state;
@property (strong, nonatomic) SDLManager *sdlManager;
@property (assign, nonatomic) SDLHMIFirstState firstTimeState;
@property (assign, nonatomic) SDLHMIInitialShowState initialShowState;
@property (nonatomic, assign, getter=isVehicleDataSubscribed) BOOL vehicleDataSubscribed;
@property (assign, nonatomic) BOOL ShouldRestartOnDisconnect;

+ (instancetype)sharedManager;
- (void)startIAP;
- (void)startTCP;
- (void)reset;

@end
