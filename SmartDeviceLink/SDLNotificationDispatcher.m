//
//  SDLnotificationDispatcher.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLNotificationDispatcher.h"

#import "SDLError.h"
#import "SDLNotificationConstants.h"


NS_ASSUME_NONNULL_BEGIN

@implementation SDLNotificationDispatcher

- (void)postNotification:(NSString *)name info:(nullable id)info {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (info != nil) {
        userInfo = @{ SDLNotificationUserInfoObject: info };
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
    });
}

#pragma mark - SDLProxyListener Delegate Methods

- (void)onProxyOpened {
    [self postNotification:SDLTransportDidConnect info:nil];
}

- (void)onProxyClosed {
    [self postNotification:SDLTransportDidDisconnect info:nil];
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [self postNotification:SDLDidChangeHMIStatusNotification info:notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self postNotification:SDLDidChangeDriverDistractionStateNotification info:notification];
}


#pragma mark Optional Methods

- (void)onError:(NSException *)e {
    NSError *error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:e.name andReason:e.reason];
    [self postNotification:SDLDidReceiveError info:error];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self postNotification:SDLDidReceiveAddCommandResponse info:response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self postNotification:SDLDidReceiveAddSubMenuResponse info:response];
}

- (void)onAlertManeuverResponse:(SDLAlertManeuverResponse *)response {
    [self postNotification:SDLDidReceiveAlertManeuverResponse info:response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self postNotification:SDLDidReceiveAlertResponse info:response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self postNotification:SDLDidReceiveChangeRegistrationResponse info:response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self postNotification:SDLDidReceiveCreateInteractionChoiceSetResponse info:response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self postNotification:SDLDidReceiveDeleteCommandResponse info:response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self postNotification:SDLDidReceiveDeleteFileResponse info:response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self postNotification:SDLDidReceiveDeleteInteractionChoiceSetResponse info:response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self postNotification:SDLDidReceiveDeleteSubmenuResponse info:response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self postNotification:SDLDidReceiveDiagnosticMessageResponse info:response];
}

- (void)onDialNumberResponse:(SDLDialNumberResponse *)response {
    [self postNotification:SDLDidReceiveDialNumberResponse info:response];
}

- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response {
    [self postNotification:SDLDidReceiveEncodedSyncPDataResponse info:response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self postNotification:SDLDidReceiveEndAudioPassThruResponse info:response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self postNotification:SDLDidReceiveGenericResponse info:response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self postNotification:SDLDidReceiveGetDTCsResponse info:response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self postNotification:SDLDidReceiveGetVehicleDataResponse info:response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self postNotification:SDLDidReceiveListFilesResponse info:response];
}

- (void)onReceivedLockScreenIcon:(UIImage *)icon {
    [self postNotification:SDLDidReceiveLockScreenIcon info:icon];
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self postNotification:SDLDidReceivePerformAudioPassThruResponse info:response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self postNotification:SDLDidReceivePerformInteractionResponse info:response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self postNotification:SDLDidReceivePutFileResponse info:response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self postNotification:SDLDidReceiveReadDIDResponse info:response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    [self postNotification:SDLDidReceiveRegisterAppInterfaceResponse info:response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self postNotification:SDLDidReceiveResetGlobalPropertiesResponse info:response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self postNotification:SDLDidReceiveScrollableMessageResponse info:response];
}

- (void)onSendLocationResponse:(SDLSendLocationResponse *)response {
    [self postNotification:SDLDidReceiveSendLocationResponse info:response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self postNotification:SDLDidReceiveSetAppIconResponse info:response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self postNotification:SDLDidReceiveSetDisplayLayoutResponse info:response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self postNotification:SDLDidReceiveSetGlobalPropertiesResponse info:response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self postNotification:SDLDidReceiveSetMediaClockTimerResponse info:response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self postNotification:SDLDidReceiveShowConstantTBTResponse info:response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self postNotification:SDLDidReceiveShowResponse info:response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self postNotification:SDLDidReceiveSliderResponse info:response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self postNotification:SDLDidReceiveSpeakResponse info:response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self postNotification:SDLDidReceiveSubscribeButtonResponse info:response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self postNotification:SDLDidReceiveSubscribeVehicleDataResponse info:response];
}

- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self postNotification:SDLDidReceiveSyncPDataResponse info:response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self postNotification:SDLDidReceiveUpdateTurnListResponse info:response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self postNotification:SDLDidReceiveUnregisterAppInterfaceResponse info:response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self postNotification:SDLDidReceiveUnsubscribeButtonResponse info:response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self postNotification:SDLDidReceiveUnsubscribeVehicleDataResponse info:response];
}

- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification {
    [self postNotification:SDLDidChangeLockScreenStatusNotification info:notification];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self postNotification:SDLDidReceiveUnregisterAppInterfaceResponse info:notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self postNotification:SDLDidReceiveAudioPassThruNotification info:notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self postNotification:SDLDidReceiveButtonEventNotification info:notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self postNotification:SDLDidReceiveButtonPressNotification info:notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self postNotification:SDLDidReceiveCommandNotification info:notification];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self postNotification:SDLDidReceiveEncodedDataNotification info:notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    [self postNotification:SDLDidReceiveNewHashNotification info:notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self postNotification:SDLDidChangeLanguageNotification info:notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self postNotification:SDLDidChangePermissionsNotification info:notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self postNotification:SDLDidReceiveSystemRequestNotification info:notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self postNotification:SDLDidReceiveSystemRequestNotification info:notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self postNotification:SDLDidChangeTurnByTurnStateNotification info:notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self postNotification:SDLDidReceiveTouchEventNotification info:notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self postNotification:SDLDidReceiveVehicleDataNotification info:notification];
}

@end

NS_ASSUME_NONNULL_END