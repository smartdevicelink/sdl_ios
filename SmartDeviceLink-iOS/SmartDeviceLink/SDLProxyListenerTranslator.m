//  SDLProxyListenerBase.m
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProxyListenerTranslator.h"
#import "SDLManager.h"
#import "SDLProxyBaseInternal.h"

@interface SDLProxyListenerTranslator ()

@property (weak) SDLManager *proxyBase;

@end

@implementation SDLProxyListenerTranslator


#pragma mark Lifecycle

- (instancetype)init {
    NSAssert(NO, @"Use -initWithManager instead");
    return nil;
}

- (instancetype)initWithManager:(SDLManager *)manager {
    self = [super init];
    if (self) {
        _proxyBase = manager;
    }
    return self;
}


#pragma mark SDLProxyListener

- (void)onProxyOpened {
    [self.proxyBase notifyDelegatesOfEvent:SDLEventOpened error:nil];
}

- (void)onProxyClosed {
    [self.proxyBase notifyDelegatesOfEvent:SDLEventClosed error:nil];
}

- (void)onError:(NSException *)e {
    [self.proxyBase notifyDelegatesOfEvent:SDLEventError error:e];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)(SDLRPCResponse *)response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onEncodedSyncPDataRespons:(SDLEncodedSyncPDataResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self.proxyBase runHandlersForResponse:(SDLRPCResponse *)response];
}

- (void)onOnLockScreenNotification:(SDLLockScreenStatus *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self.proxyBase notifyDelegatesOfNotification:(SDLRPCNotification *)notification];
}

@end
