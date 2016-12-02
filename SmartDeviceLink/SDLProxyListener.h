//  SDLProxyListener.h
//

@import UIKit;

@class SDLAddCommandResponse;
@class SDLAddSubMenuResponse;
@class SDLAlertManeuverResponse;
@class SDLAlertResponse;
@class SDLChangeRegistrationResponse;
@class SDLCreateInteractionChoiceSetResponse;
@class SDLDeleteCommandResponse;
@class SDLDeleteFileResponse;
@class SDLDeleteInteractionChoiceSetResponse;
@class SDLDeleteSubMenuResponse;
@class SDLDiagnosticMessageResponse;
@class SDLDialNumberResponse;
@class SDLEncodedSyncPDataResponse;
@class SDLEndAudioPassThruResponse;
@class SDLGenericResponse;
@class SDLGetDTCsResponse;
@class SDLGetVehicleDataResponse;
@class SDLListFilesResponse;
@class SDLOnAppInterfaceUnregistered;
@class SDLOnAudioPassThru;
@class SDLOnButtonEvent;
@class SDLOnButtonPress;
@class SDLOnCommand;
@class SDLOnDriverDistraction;
@class SDLOnEncodedSyncPData;
@class SDLOnHashChange;
@class SDLOnHMIStatus;
@class SDLOnKeyboardInput;
@class SDLOnLanguageChange;
@class SDLOnLockScreenStatus;
@class SDLOnPermissionsChange;
@class SDLOnSyncPData;
@class SDLOnSystemRequest;
@class SDLOnVehicleData;
@class SDLOnTBTClientState;
@class SDLOnTouchEvent;
@class SDLOnVehicleData;
@class SDLPerformAudioPassThruResponse;
@class SDLPerformInteractionResponse;
@class SDLPutFileResponse;
@class SDLReadDIDResponse;
@class SDLRegisterAppInterfaceResponse;
@class SDLResetGlobalPropertiesResponse;
@class SDLScrollableMessageResponse;
@class SDLSendLocationResponse;
@class SDLSetAppIconResponse;
@class SDLSetDisplayLayoutResponse;
@class SDLSetGlobalPropertiesResponse;
@class SDLSetMediaClockTimerResponse;
@class SDLShowConstantTBTResponse;
@class SDLShowResponse;
@class SDLSliderResponse;
@class SDLSpeakResponse;
@class SDLSubscribeButtonResponse;
@class SDLSubscribeVehicleDataResponse;
@class SDLSyncPDataResponse;
@class SDLUpdateTurnListResponse;
@class SDLUnregisterAppInterfaceResponse;
@class SDLUnsubscribeButtonResponse;
@class SDLUnsubscribeVehicleDataResponse;


@protocol SDLProxyListener <NSObject>

- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification;
- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification;
- (void)onProxyClosed;
- (void)onProxyOpened;

@optional

- (void)onAddCommandResponse:(SDLAddCommandResponse *)response;
- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response;
- (void)onAlertManeuverResponse:(SDLAlertManeuverResponse *)response;
- (void)onAlertResponse:(SDLAlertResponse *)response;
- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response;
- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response;
- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response;
- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response;
- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response;
- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response;
- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response;
- (void)onDialNumberResponse:(SDLDialNumberResponse *)response;
- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response;
- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response;
- (void)onError:(NSException *)e;
- (void)onGenericResponse:(SDLGenericResponse *)response;
- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response;
- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response;
- (void)onListFilesResponse:(SDLListFilesResponse *)response;
- (void)onReceivedLockScreenIcon:(UIImage *)icon;
- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;
- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification;
- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification;
- (void)onOnButtonPress:(SDLOnButtonPress *)notification;
- (void)onOnCommand:(SDLOnCommand *)notification;
- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification;
- (void)onOnHashChange:(SDLOnHashChange *)notification;
- (void)onOnKeyboardInput:(SDLOnKeyboardInput *)notification;
- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification;
- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification;
- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification;
- (void)onOnSyncPData:(SDLOnSyncPData *)notification;
- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification;
- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification;
- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification;
- (void)onOnVehicleData:(SDLOnVehicleData *)notification;
- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response;
- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response;
- (void)onPutFileResponse:(SDLPutFileResponse *)response;
- (void)onReadDIDResponse:(SDLReadDIDResponse *)response;
- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response;
- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response;
- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response;
- (void)onSendLocationResponse:(SDLSendLocationResponse *)response;
- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response;
- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response;
- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response;
- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response;
- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response;
- (void)onShowResponse:(SDLShowResponse *)response;
- (void)onSliderResponse:(SDLSliderResponse *)response;
- (void)onSpeakResponse:(SDLSpeakResponse *)response;
- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response;
- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response;
- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response;
- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response;
- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response;
- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response;
- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response;

@end
