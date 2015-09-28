//  SDLDelegates.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

@class SDLRPCResponse, SDLRPCNotification, SDLOnHMIStatus, SDLOnDriverDistraction, SDLRegisterAppInterfaceResponse, SDLOnAppInterfaceUnregistered, SDLOnAudioPassThru, SDLOnButtonEvent, SDLOnButtonPress, SDLOnCommand, SDLOnEncodedSyncPData, SDLOnHashChange, SDLOnLanguageChange, SDLOnLockScreenStatus, SDLOnPermissionsChange, SDLOnSyncPData, SDLOnSystemRequest, SDLOnTBTClientState, SDLOnTouchEvent, SDLOnVehicleData;

typedef void (^SDLRPCResponseHandler) (__kindof SDLRPCResponse *);
typedef void (^SDLRPCNotificationHandler) (__kindof SDLRPCNotification *);

@protocol SDLManagerDelegate <NSObject>

@optional
- (void)onSDLFirstHMIFull:(SDLOnHMIStatus *)notification;
- (void)onSDLFirstHMINotNone:(SDLOnHMIStatus *)notification;
- (void)onSDLDriverDistraction:(SDLOnDriverDistraction *)notification;
- (void)onSDLHMIStatus:(SDLOnHMIStatus *)notification;
- (void)onSDLProxyClosed;
- (void)onSDLProxyOpened;
- (void)onSDLRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response;
- (void)onSDLError:(NSException*)e;
- (void)onSDLAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;
- (void)onSDLAudioPassThru:(SDLOnAudioPassThru *)notification;
- (void)onSDLButtonEvent:(SDLOnButtonEvent *)notification;
- (void)onSDLButtonPress:(SDLOnButtonPress *)notification;
- (void)onSDLCommand:(SDLOnCommand *)notification;
- (void)onSDLEncodedSyncPData:(SDLOnEncodedSyncPData *)notification;
- (void)onSDLHashChange:(SDLOnHashChange *)notification;
- (void)onSDLLanguageChange:(SDLOnLanguageChange *)notification;
- (void)onSDLLockScreenNotification:(SDLOnLockScreenStatus *)notification;
- (void)onSDLPermissionsChange:(SDLOnPermissionsChange *)notification;
- (void)onSDLSyncPData:(SDLOnSyncPData *)notification;
- (void)onSDLSystemRequest:(SDLOnSystemRequest *)notification;
- (void)onSDLTBTClientState:(SDLOnTBTClientState *)notification;
- (void)onSDLTouchEvent:(SDLOnTouchEvent *)notification;
- (void)onSDLVehicleData:(SDLOnVehicleData *)notification;

@end