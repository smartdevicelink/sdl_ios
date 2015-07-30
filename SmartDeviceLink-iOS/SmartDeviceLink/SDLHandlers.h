//  SDLHandlers.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

@class SDLRPCResponse, SDLRPCNotification, SDLOnHMIStatus, SDLOnDriverDistraction, SDLRegisterAppInterfaceResponse, SDLOnAppInterfaceUnregistered, SDLOnAudioPassThru, SDLOnButtonEvent, SDLOnButtonPress, SDLOnCommand, SDLOnEncodedSyncPData, SDLOnHashChange, SDLOnLanguageChange, SDLOnLockScreenStatus, SDLOnPermissionsChange, SDLOnSyncPData, SDLOnSystemRequest, SDLOnTBTClientState, SDLOnTouchEvent, SDLOnVehicleData;

typedef void (^rpcResponseHandler) (SDLRPCResponse *);
typedef void (^rpcNotificationHandler) (SDLRPCNotification *);

@protocol SDLFirstHMIFullDelegate <NSObject>

- (void)onFirstHMIFull:(SDLOnHMIStatus *)notification;

@end


@protocol SDLFirstHMINotNoneDelegate <NSObject>

- (void)onFirstHMINotNone:(SDLOnHMIStatus *)notification;

@end


@protocol SDLOnDriverDistractionDelegate <NSObject>

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification;

@end


@protocol SDLOnHMIStatusDelegate <NSObject>

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification;

@end


@protocol SDLProxyClosedDelegate <NSObject>

- (void)onProxyClosed;

@end


@protocol SDLProxyOpenedDelegate <NSObject>

- (void)onProxyOpened;

@end


@protocol SDLAppRegisteredDelegate <NSObject>

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response;

@end


@protocol SDLProxyErrorDelegate <NSObject>

-(void) onError:(NSException*) e;

@end


@protocol SDLAppUnregisteredDelegate <NSObject>

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;

@end


@protocol SDLOnAudioPassThruDelegate <NSObject>

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification;

@end


@protocol SDLOnButtonEventDelegate <NSObject>

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification;

@end


@protocol SDLOnButtonPressDelegate <NSObject>

- (void)onOnButtonPress:(SDLOnButtonPress *)notification;

@end


@protocol SDLOnCommandDelegate <NSObject>

- (void)onOnCommand:(SDLOnCommand *)notification;

@end


@protocol SDLOnEncodedSyncPDataDelegate <NSObject>

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification;

@end


@protocol SDLOnHashChangeDelegate <NSObject>

- (void)onOnHashChange:(SDLOnHashChange *)notification;

@end


@protocol SDLOnLanguageChangeDelegate <NSObject>

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification;

@end


@protocol SDLOnLockScreenNotificationDelegate <NSObject>

- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification;

@end


@protocol SDLOnPermissionsChangeDelegate <NSObject>

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification;

@end


@protocol SDLOnSyncPDataDelegate <NSObject>

- (void)onOnSyncPData:(SDLOnSyncPData *)notification;

@end


@protocol SDLOnSystemRequestDelegate <NSObject>

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification;

@end


@protocol SDLOnTBTClientStateDelegate <NSObject>

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification;

@end


@protocol SDLOnTouchEventDelegate <NSObject>

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification;

@end


@protocol SDLOnVehicleDataDelegate <NSObject>

- (void)onOnVehicleData:(SDLOnVehicleData *)notification;

@end
