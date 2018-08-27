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
#import "SDLRPCNotification.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCResponseNotification.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNotificationDispatcher

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    return self;
}

- (void)postNotificationName:(NSString *)name infoObject:(nullable id)infoObject {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (infoObject != nil) {
        userInfo = @{SDLNotificationUserInfoObject: infoObject};
    }

    // Runs on `com.sdl.rpcProcessingQueue`
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (void)postRPCResponseNotification:(NSString *)name response:(__kindof SDLRPCResponse *)response {
    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:name object:self rpcResponse:response];

    // Runs on `com.sdl.rpcProcessingQueue`
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postRPCNotificationNotification:(NSString *)name notification:(__kindof SDLRPCNotification *)rpcNotification {
    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:name object:self rpcNotification:rpcNotification];

    // Runs on `com.sdl.rpcProcessingQueue`
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

#pragma mark - SDLProxyListener Delegate Methods

- (void)onProxyOpened {
    [self postNotificationName:SDLTransportDidConnect infoObject:nil];
}

- (void)onProxyClosed {
    [self postNotificationName:SDLTransportDidDisconnect infoObject:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification {
    [self postRPCNotificationNotification:SDLDidChangeHMIStatusNotification notification:notification];
}

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification {
    [self postRPCNotificationNotification:SDLDidChangeDriverDistractionStateNotification notification:notification];
}

#pragma mark Optional Methods

- (void)onError:(NSException *)e {
    NSError *error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:e.name andReason:e.reason];
    [self postNotificationName:SDLDidReceiveError infoObject:error];
}

- (void)onReceivedLockScreenIcon:(UIImage *)icon {
    [self postNotificationName:SDLDidReceiveLockScreenIcon infoObject:icon];
}

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveAddCommandResponse response:response];
}

- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveAddSubMenuResponse response:response];
}

- (void)onAlertManeuverResponse:(SDLAlertManeuverResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveAlertManeuverResponse response:response];
}

- (void)onAlertResponse:(SDLAlertResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveAlertResponse response:response];
}

- (void)onButtonPressResponse:(SDLButtonPressResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveButtonPressResponse response:response];
}

- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveChangeRegistrationResponse response:response];
}

- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveCreateInteractionChoiceSetResponse response:response];
}

- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDeleteCommandResponse response:response];
}

- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDeleteFileResponse response:response];
}

- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDeleteInteractionChoiceSetResponse response:response];
}

- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDeleteSubmenuResponse response:response];
}

- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDiagnosticMessageResponse response:response];
}

- (void)onDialNumberResponse:(SDLDialNumberResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveDialNumberResponse response:response];
}

- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveEncodedSyncPDataResponse response:response];
}

- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveEndAudioPassThruResponse response:response];
}

- (void)onGenericResponse:(SDLGenericResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGenericResponse response:response];
}

- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGetDTCsResponse response:response];
}

- (void)onGetInteriorVehicleDataResponse:(SDLGetInteriorVehicleDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGetInteriorVehicleDataResponse response:response];
}

- (void)onGetSystemCapabilityResponse:(SDLGetSystemCapabilityResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGetSystemCapabilitiesResponse response:response];
}

- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGetVehicleDataResponse response:response];
}

- (void)onGetWayPointsResponse:(SDLGetWaypointsResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveGetWaypointsResponse response:response];
}

- (void)onListFilesResponse:(SDLListFilesResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveListFilesResponse response:response];
}

- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response {
    [self postRPCResponseNotification:SDLDidReceivePerformAudioPassThruResponse response:response];
}

- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response {
    [self postRPCResponseNotification:SDLDidReceivePerformInteractionResponse response:response];
}

- (void)onPutFileResponse:(SDLPutFileResponse *)response {
    [self postRPCResponseNotification:SDLDidReceivePutFileResponse response:response];
}

- (void)onReadDIDResponse:(SDLReadDIDResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveReadDIDResponse response:response];
}

- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveRegisterAppInterfaceResponse response:response];
}

- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveResetGlobalPropertiesResponse response:response];
}

- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveScrollableMessageResponse response:response];
}

- (void)onSendHapticDataResponse:(SDLSendHapticDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSendHapticDataResponse response:response];
}

- (void)onSendLocationResponse:(SDLSendLocationResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSendLocationResponse response:response];
}

- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSetAppIconResponse response:response];
}

- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSetDisplayLayoutResponse response:response];
}

- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSetGlobalPropertiesResponse response:response];
}

- (void)onSetInteriorVehicleDataResponse:(SDLSetInteriorVehicleDataResponse *)response{
    [self postRPCResponseNotification:SDLDidReceiveSetInteriorVehicleDataResponse response:response];
}

- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSetMediaClockTimerResponse response:response];
}

- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveShowConstantTBTResponse response:response];
}

- (void)onShowResponse:(SDLShowResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveShowResponse response:response];
}

- (void)onSliderResponse:(SDLSliderResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSliderResponse response:response];
}

- (void)onSpeakResponse:(SDLSpeakResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSpeakResponse response:response];
}

- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSubscribeButtonResponse response:response];
}

- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSubscribeVehicleDataResponse response:response];
}

- (void)onSubscribeWayPointsResponse:(SDLSubscribeWayPointsResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSubscribeWaypointsResponse response:response];
}

- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveSyncPDataResponse response:response];
}

- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveUpdateTurnListResponse response:response];
}

- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveUnregisterAppInterfaceResponse response:response];
}

- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveUnsubscribeButtonResponse response:response];
}

- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveUnsubscribeVehicleDataResponse response:response];
}

- (void)onUnsubscribeWayPointsResponse:(SDLUnsubscribeWayPointsResponse *)response {
    [self postRPCResponseNotification:SDLDidReceiveUnsubscribeWaypointsResponse response:response];
}

- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveAppUnregisteredNotification notification:notification];
}

- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveAudioPassThruNotification notification:notification];
}

- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveButtonEventNotification notification:notification];
}

- (void)onOnButtonPress:(SDLOnButtonPress *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveButtonPressNotification notification:notification];
}

- (void)onOnCommand:(SDLOnCommand *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveCommandNotification notification:notification];
}

- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveEncodedDataNotification notification:notification];
}

- (void)onOnHashChange:(SDLOnHashChange *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveNewHashNotification notification:notification];
}

- (void)onOnInteriorVehicleData:(SDLOnInteriorVehicleData *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveInteriorVehicleDataNotification notification:notification];
}

- (void)onOnKeyboardInput:(SDLOnKeyboardInput *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveKeyboardInputNotification notification:notification];
}

- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification {
    [self postRPCNotificationNotification:SDLDidChangeLanguageNotification notification:notification];
}

- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification {
    [self postRPCNotificationNotification:SDLDidChangeLockScreenStatusNotification notification:notification];
}

- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification {
    [self postRPCNotificationNotification:SDLDidChangePermissionsNotification notification:notification];
}

- (void)onOnSyncPData:(SDLOnSyncPData *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveSystemRequestNotification notification:notification];
}

- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveSystemRequestNotification notification:notification];
}

- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification {
    [self postRPCNotificationNotification:SDLDidChangeTurnByTurnStateNotification notification:notification];
}

- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveTouchEventNotification notification:notification];
}

- (void)onOnVehicleData:(SDLOnVehicleData *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveVehicleDataNotification notification:notification];
}

- (void)onOnWayPointChange:(SDLOnWayPointChange *)notification {
    [self postRPCNotificationNotification:SDLDidReceiveWaypointNotification notification:notification];
}

#pragma clang diagnostic pop

@end

NS_ASSUME_NONNULL_END
