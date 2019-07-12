//  SDLProxyListener.h
//

#import <UIKit/UIKit.h>

@class SDLAddCommand;
@class SDLAddCommandResponse;
@class SDLAddSubMenu;
@class SDLAddSubMenuResponse;
@class SDLAlert;
@class SDLAlertManeuver;
@class SDLAlertManeuverResponse;
@class SDLAlertResponse;
@class SDLButtonPress;
@class SDLButtonPressResponse;
@class SDLCancelInteraction;
@class SDLCancelInteractionResponse;
@class SDLChangeRegistration;
@class SDLChangeRegistrationResponse;
@class SDLCloseApplication;
@class SDLCloseApplicationResponse;
@class SDLCreateInteractionChoiceSet;
@class SDLCreateInteractionChoiceSetResponse;
@class SDLDeleteCommand;
@class SDLDeleteCommandResponse;
@class SDLDeleteFile;
@class SDLDeleteFileResponse;
@class SDLDeleteInteractionChoiceSet;
@class SDLDeleteInteractionChoiceSetResponse;
@class SDLDeleteSubMenu;
@class SDLDeleteSubMenuResponse;
@class SDLDiagnosticMessage;
@class SDLDiagnosticMessageResponse;
@class SDLDialNumber;
@class SDLDialNumberResponse;
@class SDLEncodedSyncPData;
@class SDLEncodedSyncPDataResponse;
@class SDLEndAudioPassThru;
@class SDLEndAudioPassThruResponse;
@class SDLGenericResponse;
@class SDLGetCloudAppProperties;
@class SDLGetCloudAppPropertiesResponse;
@class SDLGetAppServiceData;
@class SDLGetAppServiceDataResponse;
@class SDLGetDTCs;
@class SDLGetDTCsResponse;
@class SDLGetFile;
@class SDLGetFileResponse;
@class SDLGetInteriorVehicleData;
@class SDLGetInteriorVehicleDataResponse;
@class SDLGetSystemCapability;
@class SDLGetSystemCapabilityResponse;
@class SDLGetVehicleData;
@class SDLGetVehicleDataResponse;
@class SDLGetWayPoints;
@class SDLGetWayPointsResponse;
@class SDLListFiles;
@class SDLListFilesResponse;
@class SDLOnAppInterfaceUnregistered;
@class SDLOnAppServiceData;
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
@class SDLOnSystemCapabilityUpdated;
@class SDLOnSystemRequest;
@class SDLOnTBTClientState;
@class SDLOnTouchEvent;
@class SDLOnVehicleData;
@class SDLOnWayPointChange;
@class SDLPerformAppServiceInteraction;
@class SDLPerformAppServiceInteractionResponse;
@class SDLPerformAudioPassThru;
@class SDLPerformAudioPassThruResponse;
@class SDLPerformInteraction;
@class SDLPerformInteractionResponse;
@class SDLPublishAppService;
@class SDLPublishAppServiceResponse;
@class SDLPutFile;
@class SDLPutFileResponse;
@class SDLReadDID;
@class SDLReadDIDResponse;
@class SDLRegisterAppInterface;
@class SDLRegisterAppInterfaceResponse;
@class SDLResetGlobalProperties;
@class SDLResetGlobalPropertiesResponse;
@class SDLScrollableMessage;
@class SDLScrollableMessageResponse;
@class SDLSendHapticData;
@class SDLSendHapticDataResponse;
@class SDLSendLocation;
@class SDLSendLocationResponse;
@class SDLSetAppIcon;
@class SDLSetAppIconResponse;
@class SDLSetCloudAppProperties;
@class SDLSetCloudAppPropertiesResponse;
@class SDLSetDisplayLayout;
@class SDLSetDisplayLayoutResponse;
@class SDLSetGlobalProperties;
@class SDLSetGlobalPropertiesResponse;
@class SDLSetInteriorVehicleData;
@class SDLSetInteriorVehicleDataResponse;
@class SDLSetMediaClockTimer;
@class SDLSetMediaClockTimerResponse;
@class SDLShow;
@class SDLShowConstantTBT;
@class SDLShowConstantTBTResponse;
@class SDLShowResponse;
@class SDLSlider;
@class SDLSliderResponse;
@class SDLSpeak;
@class SDLSpeakResponse;
@class SDLSubscribeButton;
@class SDLSubscribeButtonResponse;
@class SDLSubscribeVehicleData;
@class SDLSubscribeVehicleDataResponse;
@class SDLSubscribeWayPoints;
@class SDLSubscribeWayPointsResponse;
@class SDLSyncPData;
@class SDLSyncPDataResponse;
@class SDLSystemRequest;
@class SDLUnregisterAppInterface;
@class SDLUnregisterAppInterfaceResponse;
@class SDLUnsubscribeButton;
@class SDLUnsubscribeButtonResponse;
@class SDLUnsubscribeVehicleData;
@class SDLUnsubscribeVehicleDataResponse;
@class SDLUnsubscribeWayPoints;
@class SDLUnsubscribeWayPointsResponse;
@class SDLUpdateTurnList;
@class SDLUpdateTurnListResponse;

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

#pragma mark - Responses

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
 *  Called when a `CancelInteraction` response is received from Core
 *
 *  @param response A SDLCancelInteractionResponse object
 */
- (void)onCancelInteractionResponse:(SDLCancelInteractionResponse *)response;

/**
 *  Called when a Change Registration Response is received from Core
 *
 *  @param response A SDLChangeRegistrationResponse object
 */
- (void)onChangeRegistrationResponse:(SDLChangeRegistrationResponse *)response;

/**
 *  Called when a `CloseApplication` response is received from Core
 *
 *  @param response A SDLCloseApplicationResponse object
 */
- (void)onCloseApplicationResponse:(SDLCloseApplicationResponse *)response;

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
 *  Called when a Generic Response is received from Core
 *
 *  @param response A SDLGenericResponse object
 */
- (void)onGenericResponse:(SDLGenericResponse *)response;

/**
 *  Called when a Get App Service Data Response is received from Core
 *
 *  @param response A SDLGetAppServiceDataResponse object
 */
- (void)onGetAppServiceDataResponse:(SDLGetAppServiceDataResponse *)response;

/**
 *  Called when a GetCloudAppPropertiesResponse Response is received from Core
 *
 *  @param response A SDLGetCloudAppPropertiesResponse object
 */
- (void)onGetCloudAppPropertiesResponse:(SDLGetCloudAppPropertiesResponse *)response;

/**
 *  Called when a Get DTCs Response is received from Core
 *
 *  @param response A SDLGetDTCsResponse object
 */
- (void)onGetDTCsResponse:(SDLGetDTCsResponse *)response;

/**
 *  Called when a Get File Response is received from Core
 *
 *  @param response A SDLGetFileResponse object
 */
- (void)onGetFileResponse:(SDLGetFileResponse *)response;

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
- (void)onGetWayPointsResponse:(SDLGetWayPointsResponse *)response;

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
 *  Called when a Perform App Service Interaction Response is received from Core
 *
 *  @param response A SDLPerformAppServiceInteractionResponse object
 */
- (void)onPerformAppServiceInteractionResponse:(SDLPerformAppServiceInteractionResponse *)response;

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
 *  Called when a Publish App Service Response is received from Core
 *
 *  @param response A SDLPublishAppService object
 */
- (void)onPublishAppServiceResponse:(SDLPublishAppServiceResponse *)response;

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
 *  Called when a SetCloudAppPropertiesResponse is received from Core
 *
 *  @param response A SDLSetCloudAppPropertiesResponse object
 */
- (void)onSetCloudAppPropertiesResponse:(SDLSetCloudAppPropertiesResponse *)response;

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

#pragma mark - Requests

/**
 *  Called when a `AddCommand` request is received from Core
 *
 *  @param request A SDLAddCommand object
 */
- (void)onAddCommand:(SDLAddCommand *)request;

/**
 *  Called when a `AddSubMenu` request is received from Core
 *
 *  @param request A SDLAddSubMenu object
 */
- (void)onAddSubMenu:(SDLAddSubMenu *)request;

/**
 *  Called when a `Alert` request is received from Core
 *
 *  @param request A SDLAlert object
 */
- (void)onAlert:(SDLAlert *)request;

/**
 *  Called when a `AlertManeuver` request is received from Core
 *
 *  @param request A SDLAlertManeuver object
 */
- (void)onAlertManeuver:(SDLAlertManeuver *)request;

/**
 *  Called when a `ButtonPress` request is received from Core
 *
 *  @param request A SDLButtonPress object
 */
- (void)onButtonPress:(SDLButtonPress *)request;

/**
 *  Called when a `CancelInteraction` request is received from Core
 *
 *  @param request A SDLCancelInteraction object
 */
- (void)onCancelInteraction:(SDLCancelInteraction *)request;

/**
 *  Called when a `ChangeRegistration` request is received from Core
 *
 *  @param request A SDLChangeRegistration object
 */
- (void)onChangeRegistration:(SDLChangeRegistration *)request;

/**
 *  Called when a `CloseApplication` request is received from Core
 *
 *  @param request A SDLCloseApplication object
 */
- (void)onCloseApplication:(SDLCloseApplication *)request;

/**
 *  Called when a `CreateInteractionChoiceSet` request is received from Core
 *
 *  @param request A SDLCreateInteractionChoiceSet object
 */
- (void)onCreateInteractionChoiceSet:(SDLCreateInteractionChoiceSet *)request;

/**
 *  Called when a `DeleteCommand` request is received from Core
 *
 *  @param request A SDLDeleteCommand object
 */
- (void)onDeleteCommand:(SDLDeleteCommand *)request;

/**
 *  Called when a `DeleteFile` request is received from Core
 *
 *  @param request A SDLDeleteFile object
 */
- (void)onDeleteFile:(SDLDeleteFile *)request;

/**
 *  Called when a `DeleteInteractionChoiceSet` request is received from Core
 *
 *  @param request A SDLDeleteInteractionChoiceSet object
 */
- (void)onDeleteInteractionChoiceSet:(SDLDeleteInteractionChoiceSet *)request;

/**
 *  Called when a `DeleteSubMenu` request is received from Core
 *
 *  @param request A SDLDeleteSubMenu object
 */
- (void)onDeleteSubMenu:(SDLDeleteSubMenu *)request;

/**
 *  Called when a `DiagnosticMessage` request is received from Core
 *
 *  @param request A SDLDiagnosticMessage object
 */
- (void)onDiagnosticMessage:(SDLDiagnosticMessage *)request;

/**
 *  Called when a `DialNumber` request is received from Core
 *
 *  @param request A SDLDialNumber object
 */
- (void)onDialNumber:(SDLDialNumber *)request;

/**
 *  Called when a `EncodedSyncPData` request is received from Core
 *
 *  @param request A SDLEncodedSyncPData object
 */
- (void)onEncodedSyncPData:(SDLEncodedSyncPData *)request;

/**
 *  Called when a `EndAudioPassThru` request is received from Core
 *
 *  @param request A SDLEndAudioPassThru object
 */
- (void)onEndAudioPassThru:(SDLEndAudioPassThru *)request;

/**
 *  Called when a `GetAppServiceData` request is received from Core
 *
 *  @param request A SDLGetAppServiceData object
 */
- (void)onGetAppServiceData:(SDLGetAppServiceData *)request;

/**
 *  Called when a `GetCloudAppProperties` request is received from Core
 *
 *  @param request A SDLGetCloudAppProperties object
 */
- (void)onGetCloudAppProperties:(SDLGetCloudAppProperties *)request;

/**
 *  Called when a `GetDTCs` request is received from Core
 *
 *  @param request A SDLGetDTCs object
 */
- (void)onGetDTCs:(SDLGetDTCs *)request;

/**
 *  Called when a `GetFile` request is received from Core
 *
 *  @param request A SDLGetFile object
 */
- (void)onGetFile:(SDLGetFile *)request;

/**
 *  Called when a `GetInteriorVehicleData` request is received from Core
 *
 *  @param request A SDLGetInteriorVehicleData object
 */
- (void)onGetInteriorVehicleData:(SDLGetInteriorVehicleData *)request;

/**
 *  Called when a `GetSystemCapability` request is received from Core
 *
 *  @param request A SDLGetSystemCapability object
 */
- (void)onGetSystemCapability:(SDLGetSystemCapability *)request;

/**
 *  Called when a `GetVehicleData` request is received from Core
 *
 *  @param request A SDLGetVehicleData object
 */
- (void)onGetVehicleData:(SDLGetVehicleData *)request;

/**
 *  Called when a `GetWayPoints` request is received from Core
 *
 *  @param request A SDLGetWayPoints object
 */
- (void)onGetWayPoints:(SDLGetWayPoints *)request;

/**
 *  Called when a `ListFiles` request is received from Core
 *
 *  @param request A SDLListFiles object
 */
- (void)onListFiles:(SDLListFiles *)request;

/**
 *  Called when a `PerformAppServiceInteraction` request is received from Core
 *
 *  @param request A SDLPerformAppServiceInteraction object
 */
- (void)onPerformAppServiceInteraction:(SDLPerformAppServiceInteraction *)request;

/**
 *  Called when a `PerformAudioPassThru` request is received from Core
 *
 *  @param request A SDLPerformAudioPassThru object
 */
- (void)onPerformAudioPassThru:(SDLPerformAudioPassThru *)request;

/**
 *  Called when a `PerformInteraction` request is received from Core
 *
 *  @param request A SDLPerformInteraction object
 */
- (void)onPerformInteraction:(SDLPerformInteraction *)request;

/**
 *  Called when a `PublishAppService` request is received from Core
 *
 *  @param request A SDLPublishAppService object
 */
- (void)onPublishAppService:(SDLPublishAppService *)request;

/**
 *  Called when a `PutFile` request is received from Core
 *
 *  @param request A SDLPutFile object
 */
- (void)onPutFile:(SDLPutFile *)request;

/**
 *  Called when a `ReadDID` request is received from Core
 *
 *  @param request A SDLReadDID object
 */
- (void)onReadDID:(SDLReadDID *)request;

/**
 *  Called when a `RegisterAppInterface` request is received from Core
 *
 *  @param request A SDLRegisterAppInterface object
 */
- (void)onRegisterAppInterface:(SDLRegisterAppInterface *)request;

/**
 *  Called when a `ResetGlobalProperties` request is received from Core
 *
 *  @param request A SDLResetGlobalProperties object
 */
- (void)onResetGlobalProperties:(SDLResetGlobalProperties *)request;

/**
 *  Called when a `ScrollableMessage` request is received from Core
 *
 *  @param request A SDLScrollableMessage object
 */
- (void)onScrollableMessage:(SDLScrollableMessage *)request;

/**
 *  Called when a `SendHapticData` request is received from Core
 *
 *  @param request A SDLSendHapticData object
 */
- (void)onSendHapticData:(SDLSendHapticData *)request;

/**
 *  Called when a `SendLocation` request is received from Core
 *
 *  @param request A SDLSendLocation object
 */
- (void)onSendLocation:(SDLSendLocation *)request;

/**
 *  Called when a `SetAppIcon` request is received from Core
 *
 *  @param request A SDLSetAppIcon object
 */
- (void)onSetAppIcon:(SDLSetAppIcon *)request;

/**
 *  Called when a `SetCloudAppProperties` request is received from Core
 *
 *  @param request A SDLSetCloudAppProperties object
 */
- (void)onSetCloudAppProperties:(SDLSetCloudAppProperties *)request;

/**
 *  Called when a `SetDisplayLayout` request is received from Core
 *
 *  @param request A SDLSetDisplayLayout object
 */
- (void)onSetDisplayLayout:(SDLSetDisplayLayout *)request;

/**
 *  Called when a `SetGlobalProperties` request is received from Core
 *
 *  @param request A SDLSetGlobalProperties object
 */
- (void)onSetGlobalProperties:(SDLSetGlobalProperties *)request;

/**
 *  Called when a `SetInteriorVehicleData` request is received from Core
 *
 *  @param request A SDLSetInteriorVehicleData object
 */
- (void)onSetInteriorVehicleData:(SDLSetInteriorVehicleData *)request;

/**
 *  Called when a `SetMediaClockTimer` request is received from Core
 *
 *  @param request A SDLSetMediaClockTimer object
 */
- (void)onSetMediaClockTimer:(SDLSetMediaClockTimer *)request;

/**
 *  Called when a `Show` request is received from Core
 *
 *  @param request A SDLShow object
 */
- (void)onShow:(SDLShow *)request;

/**
 *  Called when a `ShowConstantTBT` request is received from Core
 *
 *  @param request A SDLShowConstantTBT object
 */
- (void)onShowConstantTBT:(SDLShowConstantTBT *)request;

/**
 *  Called when a `Slider` request is received from Core
 *
 *  @param request A SDLSlider object
 */
- (void)onSlider:(SDLSlider *)request;

/**
 *  Called when a `Speak` request is received from Core
 *
 *  @param request A SDLSpeak object
 */
- (void)onSpeak:(SDLSpeak *)request;

/**
 *  Called when a `SubscribeButton` request is received from Core
 *
 *  @param request A SDLSubscribeButton object
 */
- (void)onSubscribeButton:(SDLSubscribeButton *)request;

/**
 *  Called when a `SubscribeVehicleData` request is received from Core
 *
 *  @param request A SDLSubscribeVehicleData object
 */
- (void)onSubscribeVehicleData:(SDLSubscribeVehicleData *)request;

/**
 *  Called when a `SubscribeWayPoints` request is received from Core
 *
 *  @param request A SDLSubscribeWayPoints object
 */
- (void)onSubscribeWayPoints:(SDLSubscribeWayPoints *)request;

/**
 *  Called when a `SyncPData` request is received from Core
 *
 *  @param request A SDLSyncPData object
 */
- (void)onSyncPData:(SDLSyncPData *)request;

/**
 *  Called when a `SystemRequest` request is received from Core
 *
 *  @param request A SDLSystemRequest object
 */
- (void)onSystemRequest:(SDLSystemRequest *)request;

/**
 *  Called when a `UnregisterAppInterface` request is received from Core
 *
 *  @param request A SDLUnregisterAppInterface object
 */
- (void)onUnregisterAppInterface:(SDLUnregisterAppInterface *)request;

/**
 *  Called when a `UnsubscribeButton` request is received from Core
 *
 *  @param request A SDLUnsubscribeButton object
 */
- (void)onUnsubscribeButton:(SDLUnsubscribeButton *)request;

/**
 *  Called when a `UnsubscribeVehicleData` request is received from Core
 *
 *  @param request A SDLUnsubscribeVehicleData object
 */
- (void)onUnsubscribeVehicleData:(SDLUnsubscribeVehicleData *)request;

/**
 *  Called when a `UnsubscribeWayPoints` request is received from Core
 *
 *  @param request A SDLUnsubscribeWayPoints object
 */
- (void)onUnsubscribeWayPoints:(SDLUnsubscribeWayPoints *)request;

/**
 *  Called when a `UpdateTurnList` request is received from Core
 *
 *  @param request A SDLUpdateTurnList object
 */
- (void)onUpdateTurnList:(SDLUpdateTurnList *)request;


#pragma mark - Notifications

/**
 *  Called when an On App Interface Unregistered notification is received from Core
 *
 *  @param notification A SDLOnAppInterfaceUnregistered object
 */
- (void)onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered *)notification;

/**
 *  Called when an On App Service Data notification is received from Core
 *
 *  @param notification A SDLOnAppServiceData object
 */
- (void)onOnAppServiceData:(SDLOnAppServiceData *)notification;

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
 *  Called when an `OnSystemCapabilityUpdated` notification is received from Core
 *
 *  @param notification A SDLOnSystemCapabilityUpdated object
 */
- (void)onOnSystemCapabilityUpdated:(SDLOnSystemCapabilityUpdated *)notification;

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

#pragma mark - Other

/**
 *  Called when an Error message is received from Core
 *
 *  @param e An exception message
 */
- (void)onError:(NSException *)e;

@end

NS_ASSUME_NONNULL_END
