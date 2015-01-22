//  SDLProxyListener.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLAddCommandResponse.h>
#import <SmartDeviceLink/SDLAddSubMenuResponse.h>
#import <SmartDeviceLink/SDLAlertResponse.h>
#import <SmartDeviceLink/SDLChangeRegistrationResponse.h>
#import <SmartDeviceLink/SDLCreateInteractionChoiceSetResponse.h>
#import <SmartDeviceLink/SDLDeleteCommandResponse.h>
#import <SmartDeviceLink/SDLDeleteFileResponse.h>
#import <SmartDeviceLink/SDLDeleteInteractionChoiceSetResponse.h>
#import <SmartDeviceLink/SDLDeleteSubMenuResponse.h>
#import <SmartDeviceLink/SDLDiagnosticMessageResponse.h>
#import <SmartDeviceLink/SDLEncodedSyncPDataResponse.h>
#import <SmartDeviceLink/SDLEndAudioPassThruResponse.h>
#import <SmartDeviceLink/SDLGenericResponse.h>
#import <SmartDeviceLink/SDLGetDTCsResponse.h>
#import <SmartDeviceLink/SDLGetVehicleDataResponse.h>
#import <SmartDeviceLink/SDLListFilesResponse.h>
#import <SmartDeviceLink/SDLLockScreenStatus.h>
#import <SmartDeviceLink/SDLOnAppInterfaceUnregistered.h>
#import <SmartDeviceLink/SDLOnAudioPassThru.h>
#import <SmartDeviceLink/SDLOnButtonEvent.h>
#import <SmartDeviceLink/SDLOnButtonPress.h>
#import <SmartDeviceLink/SDLOnCommand.h>
#import <SmartDeviceLink/SDLOnDriverDistraction.h>
#import <SmartDeviceLink/SDLOnEncodedSyncPData.h>
#import <SmartDeviceLink/SDLOnHashChange.h>
#import <SmartDeviceLink/SDLOnHMIStatus.h>
#import <SmartDeviceLink/SDLOnLanguageChange.h>
#import <SmartDeviceLink/SDLOnPermissionsChange.h>
#import <SmartDeviceLink/SDLOnSyncPData.h>
#import <SmartDeviceLink/SDLOnSystemRequest.h>
#import <SmartDeviceLink/SDLOnVehicleData.h>
#import <SmartDeviceLink/SDLOnTBTClientState.h>
#import <SmartDeviceLink/SDLOnTouchEvent.h>
#import <SmartDeviceLink/SDLOnVehicleData.h>
#import <SmartDeviceLink/SDLPerformAudioPassThruResponse.h>
#import <SmartDeviceLink/SDLPerformInteractionResponse.h>
#import <SmartDeviceLink/SDLPutFileResponse.h>
#import <SmartDeviceLink/SDLReadDIDResponse.h>
#import <SmartDeviceLink/SDLRegisterAppInterfaceResponse.h>
#import <SmartDeviceLink/SDLResetGlobalPropertiesResponse.h>
#import <SmartDeviceLink/SDLScrollableMessageResponse.h>
#import <SmartDeviceLink/SDLSetAppIconResponse.h>
#import <SmartDeviceLink/SDLSetDisplayLayoutResponse.h>
#import <SmartDeviceLink/SDLSetGlobalPropertiesResponse.h>
#import <SmartDeviceLink/SDLSetMediaClockTimerResponse.h>
#import <SmartDeviceLink/SDLShowConstantTBTResponse.h>
#import <SmartDeviceLink/SDLShowResponse.h>
#import <SmartDeviceLink/SDLSliderResponse.h>
#import <SmartDeviceLink/SDLSpeakResponse.h>
#import <SmartDeviceLink/SDLSubscribeButtonResponse.h>
#import <SmartDeviceLink/SDLSubscribeVehicleDataResponse.h>
#import <SmartDeviceLink/SDLSyncPDataResponse.h>
#import <SmartDeviceLink/SDLUpdateTurnListResponse.h>
#import <SmartDeviceLink/SDLUnregisterAppInterfaceResponse.h>
#import <SmartDeviceLink/SDLUnsubscribeButtonResponse.h>
#import <SmartDeviceLink/SDLUnsubscribeVehicleDataResponse.h>

@protocol SDLProxyListener

-(void) onOnDriverDistraction:(SDLOnDriverDistraction*) notification;
-(void) onOnHMIStatus:(SDLOnHMIStatus*) notification;
-(void) onProxyClosed;
-(void) onProxyOpened;

@optional

-(void) onAddCommandResponse:(SDLAddCommandResponse*) response;
-(void) onAddSubMenuResponse:(SDLAddSubMenuResponse*) response;
-(void) onAlertResponse:(SDLAlertResponse*) response;
-(void) onChangeRegistrationResponse:(SDLChangeRegistrationResponse*) response;
-(void) onCreateInteractionChoiceSetResponse:(SDLCreateInteractionChoiceSetResponse*) response;
-(void) onDeleteCommandResponse:(SDLDeleteCommandResponse*) response;
-(void) onDeleteFileResponse:(SDLDeleteFileResponse*) response;
-(void) onDeleteInteractionChoiceSetResponse:(SDLDeleteInteractionChoiceSetResponse*) response;
-(void) onDeleteSubMenuResponse:(SDLDeleteSubMenuResponse*) response;
-(void) onDiagnosticMessageResponse:(SDLDiagnosticMessageResponse*) response;
-(void) onEncodedSyncPDataRespons:(SDLEncodedSyncPDataResponse*) response;
-(void) onEndAudioPassThruResponse:(SDLEndAudioPassThruResponse*) response;
-(void) onError:(NSException*) e;
-(void) onGenericResponse:(SDLGenericResponse*) response;
-(void) onGetDTCsResponse:(SDLGetDTCsResponse*) response;
-(void) onGetVehicleDataResponse:(SDLGetVehicleDataResponse*) response;
-(void) onListFilesResponse:(SDLListFilesResponse*) response;
-(void) onOnAppInterfaceUnregistered:(SDLOnAppInterfaceUnregistered*) notification;
-(void) onOnAudioPassThru:(SDLOnAudioPassThru*) notification;
-(void) onOnButtonEvent:(SDLOnButtonEvent*) notification;
-(void) onOnButtonPress:(SDLOnButtonPress*) notification;
-(void) onOnCommand:(SDLOnCommand*) notification;
-(void) onOnEncodedSyncPData:(SDLOnEncodedSyncPData*) notification;
-(void) onOnHashChange:(SDLOnHashChange*) notification;
-(void) onOnLanguageChange:(SDLOnLanguageChange*) notification;
-(void) onOnLockScreenNotification:(SDLLockScreenStatus*) notification;
-(void) onOnPermissionsChange:(SDLOnPermissionsChange*) notification;
-(void) onOnSyncPData:(SDLOnSyncPData*) notification;
-(void) onOnSystemRequest:(SDLOnSystemRequest*) notification;
-(void) onOnTBTClientState:(SDLOnTBTClientState*) notification;
-(void) onOnTouchEvent:(SDLOnTouchEvent*) notification;
-(void) onOnVehicleData:(SDLOnVehicleData*) notification;
-(void) onPerformAudioPassThruResponse:(SDLPerformAudioPassThruResponse*) response;
-(void) onPerformInteractionResponse:(SDLPerformInteractionResponse*) response;
-(void) onPutFileResponse:(SDLPutFileResponse*) response;
-(void) onReadDIDResponse:(SDLReadDIDResponse*) response;
-(void) onRegisterAppInterfaceResponse:(SDLRegisterAppInterfaceResponse*) response;
-(void) onResetGlobalPropertiesResponse:(SDLResetGlobalPropertiesResponse*) response;
-(void) onScrollableMessageResponse:(SDLScrollableMessageResponse*) response;
-(void) onSetAppIconResponse:(SDLSetAppIconResponse*) response;
-(void) onSetDisplayLayoutResponse:(SDLSetDisplayLayoutResponse*) response;
-(void) onSetGlobalPropertiesResponse:(SDLSetGlobalPropertiesResponse*) response;
-(void) onSetMediaClockTimerResponse:(SDLSetMediaClockTimerResponse*) response;
-(void) onShowConstantTBTResponse:(SDLShowConstantTBTResponse*) response;
-(void) onShowResponse:(SDLShowResponse*) response;
-(void) onSliderResponse:(SDLSliderResponse*) response;
-(void) onSpeakResponse:(SDLSpeakResponse*) response;
-(void) onSubscribeButtonResponse:(SDLSubscribeButtonResponse*) response;
-(void) onSubscribeVehicleDataResponse:(SDLSubscribeVehicleDataResponse*) response;
-(void) onSyncPDataResponse:(SDLSyncPDataResponse*) response;
-(void) onUpdateTurnListResponse:(SDLUpdateTurnListResponse*) response;
-(void) onUnregisterAppInterfaceResponse:(SDLUnregisterAppInterfaceResponse*) response;
-(void) onUnsubscribeButtonResponse:(SDLUnsubscribeButtonResponse*) response;
-(void) onUnsubscribeVehicleDataResponse:(SDLUnsubscribeVehicleDataResponse*) response;



@end
