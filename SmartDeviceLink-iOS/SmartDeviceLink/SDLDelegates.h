//  SDLDelegates.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

@class SDLRPCResponse, SDLRPCNotification, SDLOnHMIStatus, SDLOnDriverDistraction, SDLRegisterAppInterfaceResponse, SDLOnAppInterfaceUnregistered, SDLOnAudioPassThru, SDLOnButtonEvent, SDLOnButtonPress, SDLOnCommand, SDLOnEncodedSyncPData, SDLOnHashChange, SDLOnLanguageChange, SDLOnLockScreenStatus, SDLOnPermissionsChange, SDLOnSyncPData, SDLOnSystemRequest, SDLOnTBTClientState, SDLOnTouchEvent, SDLOnVehicleData;

typedef void (^RPCResponseHandler) (SDLRPCResponse *);
typedef void (^RPCNotificationHandler) (SDLRPCNotification *);

@protocol SDLFirstHMIFullDelegate <NSObject>

- (void)onSDLFirstHMIFull:(SDLOnHMIStatus *)notification;

@end


@protocol SDLFirstHMINotNoneDelegate <NSObject>

- (void)onSDLFirstHMINotNone:(SDLOnHMIStatus *)notification;

@end


@protocol SDLOnDriverDistractionDelegate <NSObject>

- (void)onSDLDriverDistraction:(SDLOnDriverDistraction *)notification;

@end


@protocol SDLOnHMIStatusDelegate <NSObject>

- (void)onSDLHMIStatus:(SDLOnHMIStatus *)notification;

@end


@protocol SDLProxyClosedDelegate <NSObject>

- (void)onSDLProxyClosed;

@end


@protocol SDLProxyOpenedDelegate <NSObject>

- (void)onSDLProxyOpened;

@end


@protocol SDLAppRegisteredDelegate <NSObject>

- (void)onSDLRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response;

@end


@protocol SDLProxyErrorDelegate <NSObject>

-(void) onSDLError:(NSException*) e;

@end


@protocol SDLAppUnregisteredDelegate <NSObject>

- (void)onSDLAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;

@end


@protocol SDLOnAudioPassThruDelegate <NSObject>

- (void)onSDLAudioPassThru:(SDLOnAudioPassThru *)notification;

@end


@protocol SDLOnButtonEventDelegate <NSObject>

- (void)onSDLButtonEvent:(SDLOnButtonEvent *)notification;

@end


@protocol SDLOnButtonPressDelegate <NSObject>

- (void)onSDLButtonPress:(SDLOnButtonPress *)notification;

@end


@protocol SDLOnCommandDelegate <NSObject>

- (void)onSDLCommand:(SDLOnCommand *)notification;

@end


@protocol SDLOnEncodedSyncPDataDelegate <NSObject>

- (void)onSDLEncodedSyncPData:(SDLOnEncodedSyncPData *)notification;

@end


@protocol SDLOnHashChangeDelegate <NSObject>

- (void)onSDLHashChange:(SDLOnHashChange *)notification;

@end


@protocol SDLOnLanguageChangeDelegate <NSObject>

- (void)onSDLLanguageChange:(SDLOnLanguageChange *)notification;

@end


@protocol SDLOnLockScreenNotificationDelegate <NSObject>

- (void)onSDLLockScreenNotification:(SDLOnLockScreenStatus *)notification;

@end


@protocol SDLOnPermissionsChangeDelegate <NSObject>

- (void)onSDLPermissionsChange:(SDLOnPermissionsChange *)notification;

@end


@protocol SDLOnSyncPDataDelegate <NSObject>

- (void)onSDLSyncPData:(SDLOnSyncPData *)notification;

@end


@protocol SDLOnSystemRequestDelegate <NSObject>

- (void)onSDLSystemRequest:(SDLOnSystemRequest *)notification;

@end


@protocol SDLOnTBTClientStateDelegate <NSObject>

- (void)onSDLTBTClientState:(SDLOnTBTClientState *)notification;

@end


@protocol SDLOnTouchEventDelegate <NSObject>

- (void)onSDLTouchEvent:(SDLOnTouchEvent *)notification;

@end


@protocol SDLOnVehicleDataDelegate <NSObject>

- (void)onSDLVehicleData:(SDLOnVehicleData *)notification;

@end
