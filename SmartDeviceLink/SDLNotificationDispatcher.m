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

- (void)postNotificationName:(NSString *)name infoObject:(nullable id)infoObject {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (infoObject != nil) {
        userInfo = @{ SDLNotificationUserInfoObject: infoObject };
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
    });
}

#pragma mark - SDLProxyListener Delegate Methods

- (void)onProxyOpened {
    [self postNotificationName:SDLTransportDidConnect infoObject:nil];
}

- (void)onProxyClosed {
    [self postNotificationName:SDLTransportDidDisconnect infoObject:nil];
}

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [self postNotificationName:SDLDidChangeHMIStatusNotification infoObject:notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self postNotificationName:SDLDidChangeDriverDistractionStateNotification infoObject:notification];
}


#pragma mark Optional Methods

- (void)onError:(NSException *)e {
    NSError *error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:e.name andReason:e.reason];
    [self postNotificationName:SDLDidReceiveError infoObject:error];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self postNotificationName:SDLDidReceiveAddCommandResponse infoObject:response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self postNotificationName:SDLDidReceiveAddSubMenuResponse infoObject:response];
}

- (void)onAlertManeuverResponse:(SDLAlertManeuverResponse *)response {
    [self postNotificationName:SDLDidReceiveAlertManeuverResponse infoObject:response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self postNotificationName:SDLDidReceiveAlertResponse infoObject:response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self postNotificationName:SDLDidReceiveChangeRegistrationResponse infoObject:response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self postNotificationName:SDLDidReceiveCreateInteractionChoiceSetResponse infoObject:response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self postNotificationName:SDLDidReceiveDeleteCommandResponse infoObject:response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self postNotificationName:SDLDidReceiveDeleteFileResponse infoObject:response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self postNotificationName:SDLDidReceiveDeleteInteractionChoiceSetResponse infoObject:response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self postNotificationName:SDLDidReceiveDeleteSubmenuResponse infoObject:response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self postNotificationName:SDLDidReceiveDiagnosticMessageResponse infoObject:response];
}

- (void)onDialNumberResponse:(SDLDialNumberResponse *)response {
    [self postNotificationName:SDLDidReceiveDialNumberResponse infoObject:response];
}

- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response {
    [self postNotificationName:SDLDidReceiveEncodedSyncPDataResponse infoObject:response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self postNotificationName:SDLDidReceiveEndAudioPassThruResponse infoObject:response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self postNotificationName:SDLDidReceiveGenericResponse infoObject:response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self postNotificationName:SDLDidReceiveGetDTCsResponse infoObject:response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self postNotificationName:SDLDidReceiveGetVehicleDataResponse infoObject:response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self postNotificationName:SDLDidReceiveListFilesResponse infoObject:response];
}

- (void)onReceivedLockScreenIcon:(UIImage *)icon {
    [self postNotificationName:SDLDidReceiveLockScreenIcon infoObject:icon];
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self postNotificationName:SDLDidReceivePerformAudioPassThruResponse infoObject:response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self postNotificationName:SDLDidReceivePerformInteractionResponse infoObject:response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self postNotificationName:SDLDidReceivePutFileResponse infoObject:response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self postNotificationName:SDLDidReceiveReadDIDResponse infoObject:response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    [self postNotificationName:SDLDidReceiveRegisterAppInterfaceResponse infoObject:response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self postNotificationName:SDLDidReceiveResetGlobalPropertiesResponse infoObject:response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self postNotificationName:SDLDidReceiveScrollableMessageResponse infoObject:response];
}

- (void)onSendLocationResponse:(SDLSendLocationResponse *)response {
    [self postNotificationName:SDLDidReceiveSendLocationResponse infoObject:response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self postNotificationName:SDLDidReceiveSetAppIconResponse infoObject:response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self postNotificationName:SDLDidReceiveSetDisplayLayoutResponse infoObject:response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self postNotificationName:SDLDidReceiveSetGlobalPropertiesResponse infoObject:response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self postNotificationName:SDLDidReceiveSetMediaClockTimerResponse infoObject:response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self postNotificationName:SDLDidReceiveShowConstantTBTResponse infoObject:response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self postNotificationName:SDLDidReceiveShowResponse infoObject:response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self postNotificationName:SDLDidReceiveSliderResponse infoObject:response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self postNotificationName:SDLDidReceiveSpeakResponse infoObject:response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self postNotificationName:SDLDidReceiveSubscribeButtonResponse infoObject:response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self postNotificationName:SDLDidReceiveSubscribeVehicleDataResponse infoObject:response];
}

- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self postNotificationName:SDLDidReceiveSyncPDataResponse infoObject:response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self postNotificationName:SDLDidReceiveUpdateTurnListResponse infoObject:response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self postNotificationName:SDLDidReceiveUnregisterAppInterfaceResponse infoObject:response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self postNotificationName:SDLDidReceiveUnsubscribeButtonResponse infoObject:response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self postNotificationName:SDLDidReceiveUnsubscribeVehicleDataResponse infoObject:response];
}

- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification {
    [self postNotificationName:SDLDidChangeLockScreenStatusNotification infoObject:notification];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self postNotificationName:SDLDidReceiveUnregisterAppInterfaceResponse infoObject:notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self postNotificationName:SDLDidReceiveAudioPassThruNotification infoObject:notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self postNotificationName:SDLDidReceiveButtonEventNotification infoObject:notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self postNotificationName:SDLDidReceiveButtonPressNotification infoObject:notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self postNotificationName:SDLDidReceiveCommandNotification infoObject:notification];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self postNotificationName:SDLDidReceiveEncodedDataNotification infoObject:notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    [self postNotificationName:SDLDidReceiveNewHashNotification infoObject:notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self postNotificationName:SDLDidChangeLanguageNotification infoObject:notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self postNotificationName:SDLDidChangePermissionsNotification infoObject:notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self postNotificationName:SDLDidReceiveSystemRequestNotification infoObject:notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self postNotificationName:SDLDidReceiveSystemRequestNotification infoObject:notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self postNotificationName:SDLDidChangeTurnByTurnStateNotification infoObject:notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self postNotificationName:SDLDidReceiveTouchEventNotification infoObject:notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self postNotificationName:SDLDidReceiveVehicleDataNotification infoObject:notification];
}

@end

NS_ASSUME_NONNULL_END