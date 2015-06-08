//  SDLProxyListenerBase.m
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProxyListenerBase.h"
#import "SDLProxyBase.h"

@interface SDLProxyListenerBase ()

@property (weak, nonatomic) SDLProxyBase *proxyBase;

@end

@implementation SDLProxyListenerBase

- (id)initWithProxyBase:(SDLProxyBase *)base {
    self = [super init];
    if (self) {
        _proxyBase = base;
    }
    return self;
}

- (void)onProxyOpened {
    [self.proxyBase runHandlerForEvent:ProxyOpened error:nil];
}

- (void)onProxyClosed {
    [self.proxyBase runHandlerForEvent:ProxyClosed error:nil];
}

- (void)onError:(NSException *)e {
    [self.proxyBase runHandlerForEvent:OnError error:e];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)(SDLRPCResponse *)response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onEncodedSyncPDataRespons:(SDLEncodedSyncPDataResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self.proxyBase runHandlerForResponse:(SDLRPCResponse *)response];
}

- (void)onOnLockScreenNotification:(SDLLockScreenStatus *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self.proxyBase runHandlerForNotification:(SDLRPCNotification *)notification];
}

@end
