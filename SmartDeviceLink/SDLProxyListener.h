//  SDLProxyListener.h
//

#import <UIKit/UIKit.h>

@class SDLAddCommandResponse;
@class SDLAddSubMenuResponse;
@class SDLAlertManeuverResponse;
@class SDLAlertResponse;
@class SDLButtonPressResponse;
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
@class SDLGetInteriorVehicleDataResponse;
@class SDLGetSystemCapabilityResponse;
@class SDLGetVehicleDataResponse;
@class SDLGetWaypointsResponse;
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
@class SDLOnInteriorVehicleData;
@class SDLOnKeyboardInput;
@class SDLOnLanguageChange;
@class SDLOnLockScreenStatus;
@class SDLOnPermissionsChange;
@class SDLOnRCStatus;
@class SDLOnSyncPData;
@class SDLOnSystemRequest;
@class SDLOnVehicleData;
@class SDLOnTBTClientState;
@class SDLOnTouchEvent;
@class SDLOnVehicleData;
@class SDLOnWayPointChange;
@class SDLPerformAudioPassThruResponse;
@class SDLPerformInteractionResponse;
@class SDLPutFileResponse;
@class SDLReadDIDResponse;
@class SDLRegisterAppInterfaceResponse;
@class SDLResetGlobalPropertiesResponse;
@class SDLScrollableMessageResponse;
@class SDLSendHapticDataResponse;
@class SDLSendLocationResponse;
@class SDLSetAppIconResponse;
@class SDLSetDisplayLayoutResponse;
@class SDLSetGlobalPropertiesResponse;
@class SDLSetInteriorVehicleDataResponse;
@class SDLSetMediaClockTimerResponse;
@class SDLShowConstantTBTResponse;
@class SDLShowResponse;
@class SDLSliderResponse;
@class SDLSpeakResponse;
@class SDLSubscribeButtonResponse;
@class SDLSubscribeVehicleDataResponse;
@class SDLSubscribeWayPointsResponse;
@class SDLSyncPDataResponse;
@class SDLUpdateTurnListResponse;
@class SDLUnregisterAppInterfaceResponse;
@class SDLUnsubscribeButtonResponse;
@class SDLUnsubscribeVehicleDataResponse;
@class SDLUnsubscribeWayPointsResponse;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProxyListener <NSObject>

/**
 *  Called when a Driver Distraction notification is received from Core
 *
 *  @param notification A SDLOnDriverDistraction object
 */
- (void)onOnDriverDistraction:(SDLOnDriverDistraction *)notification;

/**
 *  Called when the HMI Status of the SDL app has changed
 *
 *  @param notification A SDLOnHMIStatus object
 */
- (void)onOnHMIStatus:(SDLOnHMIStatus *)notification;

/**
 *  Called when a connection with Core has closed
 */
- (void)onProxyClosed;

/**
 *  Called when a connection with Core has been established
 */
- (void)onProxyOpened;

@optional

/**
 *  Called when an Add Command Response is received from Core
 *
 *  @param response A SDLAddCommandResponse object
 */
- (void)onAddCommandResponse:(SDLAddCommandResponse *)response;

/**
 *  Called when an Add SubMenu Response is received from Core
 *
 *  @param response A SDLAddSubMenuResponse object
 */
- (void)onAddSubMenuResponse:(SDLAddSubMenuResponse *)response;

/**
 *  Called when a Alert Maneuver Response is received from Core
 *
 *  @param response A SDLAlertManeuverResponse object
 */
- (void)onAlertManeuverResponse:(SDLAlertManeuverResponse *)response;

/**
 *  Called when a Alert Response is received from Core
 *
 *  @param response A SDLAlertResponse object
 */
- (void)onAlertResponse:(SDLAlertResponse *)response;

/**
 *  Called when a Button Press Response is received from Core
 *
 *  @param response A SDLButtonPressResponse object
 */
- (void)onButtonPressResponse:(SDLButtonPressResponse *)response;

/**
 *  Called when a Change Registration Response is received from Core
 *
 *  @param response A SDLChangeRegistrationResponse object
 */
- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response;

/**
 *  Called when a Create Interaction Choice Set Response is received from Core
 *
 *  @param response A SDLCreateInteractionChoiceSetResponse object
 */
- (void)onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse *)response;

/**
 *  Called when a Delete Command Response is received from Core
 *
 *  @param response A SDLDeleteCommandResponse object
 */
- (void)onDeleteCommandResponse:(SDLDeleteCommandResponse *)response;

/**
 *  Called when a Delete File Response is received from Core
 *
 *  @param response A SDLDeleteFileResponse object
 */
- (void)onDeleteFileResponse:(SDLDeleteFileResponse *)response;

/**
 *  Called when a Delete Interaction Choice Set Response is received from Core
 *
 *  @param response A SDLDeleteInteractionChoiceSetResponse object
 */
- (void)onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse *)response;

/**
 *  Called when a Delete SubMenu Response is received from Core
 *
 *  @param response A SDLDeleteSubMenuResponse object
 */
- (void)onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse *)response;

/**
 *  Called when a Diagnostic Message Response is received from Core
 *
 *  @param response A SDLDiagnosticMessageResponse object
 */
- (void)onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse *)response;

/**
 *  Called when a Dial Number Response is received from Core
 *
 *  @param response A SDLDialNumberResponse object
 */
- (void)onDialNumberResponse:(SDLDialNumberResponse *)response;

/**
 *  Called when an Encoded Sync P Data Response is received from Core
 *
 *  @param response A SDLEncodedSyncPDataResponse object
 */
- (void)onEncodedSyncPDataResponse:(SDLEncodedSyncPDataResponse *)response;

/**
 *  Called when an End Audio Pass Thru Response is received from Core
 *
 *  @param response A SDLEndAudioPassThruResponse object
 */
- (void)onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse *)response;

/**
 *  Called when an Error message is received from Core
 *
 *  @param e An exception message
 */
- (void)onError:(NSException *)e;

/**
 *  Called when a Generic Response is received from Core
 *
 *  @param response A SDLGenericResponse object
 */
- (void)onGenericResponse:(SDLGenericResponse *)response;

/**
 *  Called when a Get DTCs Response is received from Core
 *
 *  @param response A SDLGetDTCsResponse object
 */
- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response;

/**
 *  Called when a Get Interior Vehicle Data Response is received from Core
 *
 *  @param response A SDLGetInteriorVehicleDataResponse object
 */
- (void)onGetInteriorVehicleDataResponse:(SDLGetInteriorVehicleDataResponse *)response;

/**
 *  Called when a Get System Capability Response is received from Core
 *
 *  @param response A SDLGetSystemCapabilityResponse object
 */
- (void)onGetSystemCapabilityResponse:(SDLGetSystemCapabilityResponse *)response;

/**
 *  Called when a Get Vehicle Data Response is received from Core
 *
 *  @param response A SDLGetVehicleDataResponse object
 */
- (void)onGetVehicleDataResponse:(SDLGetVehicleDataResponse *)response;

/**
 *  Called when a Get Way Points Response is received from Core
 *
 *  @param response A SDLGetWaypointsResponse object
 */
- (void)onGetWayPointsResponse:(SDLGetWaypointsResponse *)response;

/**
 *  Called when a List Files Response is received from Core
 *
 *  @param response A SDLListFilesResponse object
 */
- (void)onListFilesResponse:(SDLListFilesResponse *)response;

/**
 *  Called when a Received Lock Screen Icon notification is received from Core
 *
 *  @param icon An image
 */
- (void)onReceivedLockScreenIcon:(UIImage *)icon;

/**
 *  Called when an On App Interface Unregistered notification is received from Core
 *
 *  @param notification A SDLOnAppInterfaceUnregistered object
 */
- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;

/**
 *  Called when an On Audio Pass Thru notification is received from Core
 *
 *  @param notification A SDLOnAudioPassThru object
 */
- (void)onOnAudioPassThru:(SDLOnAudioPassThru *)notification;

/**
 *  Called when an On Button Event notification is received from Core
 *
 *  @param notification A SDLOnButtonEvent object
 */
- (void)onOnButtonEvent:(SDLOnButtonEvent *)notification;

/**
 *  Called when an On Button Press notification is received from Core
 *
 *  @param notification A SDLOnButtonPress object
 */
- (void)onOnButtonPress:(SDLOnButtonPress *)notification;

/**
 *  Called when an On Command notification is received from Core
 *
 *  @param notification A SDLOnCommand object
 */
- (void)onOnCommand:(SDLOnCommand *)notification;

/**
 *  Called when an On Encoded Sync P Data notification is received from Core
 *
 *  @param notification A SDLOnEncodedSyncPData object
 */
- (void)onOnEncodedSyncPData:(SDLOnEncodedSyncPData *)notification;

/**
 *  Called when an On Hash Change notification is received from Core
 *
 *  @param notification A SDLOnHashChange object
 */
- (void)onOnHashChange:(SDLOnHashChange *)notification;

/**
 *  Called when an On Interior Vehicle Data notification is received from Core
 *
 *  @param notification A SDLOnInteriorVehicleData object
 */
- (void)onOnInteriorVehicleData:(SDLOnInteriorVehicleData *)notification;

/**
 *  Called when an On Keyboard Input notification is received from Core
 *
 *  @param notification A SDLOnKeyboardInput object
 */
- (void)onOnKeyboardInput:(SDLOnKeyboardInput *)notification;

/**
 *  Called when an On Language Change notification is received from Core
 *
 *  @param notification A SDLOnLanguageChange object
 */
- (void)onOnLanguageChange:(SDLOnLanguageChange *)notification;

/**
 *  Called when an On Lock Screen notification is received from Core
 *
 *  @param notification A SDLOnLockScreenStatus object
 */
- (void)onOnLockScreenNotification:(SDLOnLockScreenStatus *)notification;

/**
 *  Called when an On Permissions Change notification is received from Core
 *
 *  @param notification A SDLOnPermissionsChange object
 */
- (void)onOnPermissionsChange:(SDLOnPermissionsChange *)notification;

/**
 *  Called when an On RC Change notification is received from Core
 *
 *  @param notification A SDLOnRCStatus object
 */
- (void)onOnRCStatus:(SDLOnRCStatus *)notification;

/**
 *  Called when an On Sync P notification is received from Core
 *
 *  @param notification A SDLOnSyncPData object
 */
- (void)onOnSyncPData:(SDLOnSyncPData *)notification;

/**
 *  Called when an On System Request notification is received from Core
 *
 *  @param notification A SDLOnSystemRequest object
 */
- (void)onOnSystemRequest:(SDLOnSystemRequest *)notification;

/**
 *  Called when an On TBT Client State notification is received from Core
 *
 *  @param notification A SDLOnTBTClientState object
 */
- (void)onOnTBTClientState:(SDLOnTBTClientState *)notification;

/**
 *  Called when an On Touch Event notification is received from Core
 *
 *  @param notification A SDLOnTouchEvent object
 */
- (void)onOnTouchEvent:(SDLOnTouchEvent *)notification;

/**
 *  Called when an On Vehicle Data notification is received from Core
 *
 *  @param notification A SDLOnVehicleData object
 */
- (void)onOnVehicleData:(SDLOnVehicleData *)notification;

/**
 *  Called when an On Way Point Change notification is received from Core
 *
 *  @param notification A SDLOnWayPointChange object
 */
- (void)onOnWayPointChange:(SDLOnWayPointChange *)notification;

/**
 *  Called when a Perform Audio Pass Thru Response is received from Core
 *
 *  @param response A SDLPerformAudioPassThruResponse object
 */
- (void)onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse *)response;

/**
 *  Called when a Perform Interaction Response is received from Core
 *
 *  @param response A SDLPerformInteractionResponse object
 */
- (void)onPerformInteractionResponse:(SDLPerformInteractionResponse *)response;

/**
 *  Called when a Put File Response is received from Core
 *
 *  @param response A SDLPutFileResponse object
 */
- (void)onPutFileResponse:(SDLPutFileResponse *)response;

/**
 *  Called when a Read DID Response is received from Core
 *
 *  @param response A SDLReadDIDResponse object
 */
- (void)onReadDIDResponse:(SDLReadDIDResponse *)response;

/**
 *  Called when a Register App Interface Response is received from Core
 *
 *  @param response A SDLRegisterAppInterfaceResponse object
 */
- (void)onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse *)response;

/**
 *  Called when a Reset Global Properties Response is received from Core
 *
 *  @param response A SDLResetGlobalPropertiesResponse object
 */
- (void)onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse *)response;

/**
 *  Called when a Scrollable Message Response is received from Core
 *
 *  @param response A SDLScrollableMessageResponse object
 */
- (void)onScrollableMessageResponse:(SDLScrollableMessageResponse *)response;

/**
 *  Called when a Send Haptic Data Response is received from Core
 *
 *  @param response A SDLSendHapticDataResponse object
 */
- (void)onSendHapticDataResponse:(SDLSendHapticDataResponse *)response;

/**
 *  Called when a Send Location Response is received from Core
 *
 *  @param response A SDLSendLocationResponse object
 */
- (void)onSendLocationResponse:(SDLSendLocationResponse *)response;

/**
 *  Called when a Set App Icon Response is received from Core
 *
 *  @param response A SDLSetAppIconResponse object
 */
- (void)onSetAppIconResponse:(SDLSetAppIconResponse *)response;

/**
 *  Called when a Set Display Layout Response is received from Core
 *
 *  @param response A SDLSetDisplayLayoutResponse object
 */
- (void)onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse *)response;

/**
 *  Called when a Set Global Properties Response is received from Core
 *
 *  @param response A SDLSetGlobalPropertiesResponse object
 */
- (void)onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse *)response;

/**
 *  Called when a Set Interior Vehicle Data Response is received from Core
 *
 *  @param response A SDLSetInteriorVehicleDataResponse object
 */
- (void)onSetInteriorVehicleDataResponse:(SDLSetInteriorVehicleDataResponse *)response;

/**
 *  Called when a Set Media Clock Timer Response is received from Core
 *
 *  @param response A SDLSetMediaClockTimerResponse object
 */
- (void)onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse *)response;

/**
 *  Called when a Show Constant TBT Response is received from Core
 *
 *  @param response A SDLShowConstantTBTResponse object
 */
- (void)onShowConstantTBTResponse:(SDLShowConstantTBTResponse *)response;

/**
 *  Called when a Show Response is received from Core
 *
 *  @param response A SDLShowResponse object
 */
- (void)onShowResponse:(SDLShowResponse *)response;

/**
 *  Called when a Slider Response is received from Core
 *
 *  @param response A SDLSliderResponse object
 */
- (void)onSliderResponse:(SDLSliderResponse *)response;

/**
 *  Called when a Speak Response is received from Core
 *
 *  @param response A SDLSpeakResponse object
 */
- (void)onSpeakResponse:(SDLSpeakResponse *)response;

/**
 *  Called when a Subscribe Button Response is received from Core
 *
 *  @param response A SDLSubscribeButtonResponse object
 */
- (void)onSubscribeButtonResponse:(SDLSubscribeButtonResponse *)response;

/**
 *  Called when a Subscribe Vehicle Data Response is received from Core
 *
 *  @param response A SDLSubscribeVehicleDataResponse object
 */
- (void)onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse *)response;

/**
 *  Called when a Subscribe Way Points Response is received from Core
 *
 *  @param response A SDLSubscribeWayPointsResponse object
 */
- (void)onSubscribeWayPointsResponse:(SDLSubscribeWayPointsResponse *)response;

/**
 *  Called when a Sync P Data Response is received from Core
 *
 *  @param response A SDLSyncPDataResponse object
 */
- (void)onSyncPDataResponse:(SDLSyncPDataResponse *)response;

/**
 *  Called when an Update Turn List Response is received from Core
 *
 *  @param response A SDLUpdateTurnListResponse object
 */
- (void)onUpdateTurnListResponse:(SDLUpdateTurnListResponse *)response;

/**
 *  Called when an Unregister App Interface Response is received from Core
 *
 *  @param response A SDLUnregisterAppInterfaceResponse object
 */
- (void)onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse *)response;

/**
 *  Called when an Unsubscribe Button Response is received from Core
 *
 *  @param response A SDLUnsubscribeButtonResponse object
 */
- (void)onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse *)response;

/**
 *  Called when an Unsubscribe Vehicle Data Response is received from Core
 *
 *  @param response A SDLUnsubscribeVehicleDataResponse object
 */
- (void)onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse *)response;

/**
 *  Called when an Unsubscribe Way Points Response is received from Core
 *
 *  @param response A SDLUnsubscribeWayPointsResponse object
 */
- (void)onUnsubscribeWayPointsResponse:(SDLUnsubscribeWayPointsResponse *)response;

@end

NS_ASSUME_NONNULL_END
