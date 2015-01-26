//  SDLProxyListener.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLAddCommandResponse.h"
#import "SDLAddSubMenuResponse.h"
#import "SDLAlertResponse.h"
#import "SDLChangeRegistrationResponse.h"
#import "SDLCreateInteractionChoiceSetResponse.h"
#import "SDLDeleteCommandResponse.h"
#import "SDLDeleteFileResponse.h"
#import "SDLDeleteInteractionChoiceSetResponse.h"
#import "SDLDeleteSubMenuResponse.h"
#import "SDLDiagnosticMessageResponse.h"
#import "SDLEncodedSyncPDataResponse.h"
#import "SDLEndAudioPassThruResponse.h"
#import "SDLGenericResponse.h"
#import "SDLGetDTCsResponse.h"
#import "SDLGetVehicleDataResponse.h"
#import "SDLListFilesResponse.h"
#import "SDLLockScreenStatus.h"
#import "SDLOnAppInterfaceUnregistered.h"
#import "SDLOnAudioPassThru.h"
#import "SDLOnButtonEvent.h"
#import "SDLOnButtonPress.h"
#import "SDLOnCommand.h"
#import "SDLOnDriverDistraction.h"
#import "SDLOnEncodedSyncPData.h"
#import "SDLOnHashChange.h"
#import "SDLOnHMIStatus.h"
#import "SDLOnLanguageChange.h"
#import "SDLOnPermissionsChange.h"
#import "SDLOnSyncPData.h"
#import "SDLOnSystemRequest.h"
#import "SDLOnVehicleData.h"
#import "SDLOnTBTClientState.h"
#import "SDLOnTouchEvent.h"
#import "SDLOnVehicleData.h"
#import "SDLPerformAudioPassThruResponse.h"
#import "SDLPerformInteractionResponse.h"
#import "SDLPutFileResponse.h"
#import "SDLReadDIDResponse.h"
#import "SDLRegisterAppInterfaceResponse.h"
#import "SDLResetGlobalPropertiesResponse.h"
#import "SDLScrollableMessageResponse.h"
#import "SDLSetAppIconResponse.h"
#import "SDLSetDisplayLayoutResponse.h"
#import "SDLSetGlobalPropertiesResponse.h"
#import "SDLSetMediaClockTimerResponse.h"
#import "SDLShowConstantTBTResponse.h"
#import "SDLShowResponse.h"
#import "SDLSliderResponse.h"
#import "SDLSpeakResponse.h"
#import "SDLSubscribeButtonResponse.h"
#import "SDLSubscribeVehicleDataResponse.h"
#import "SDLSyncPDataResponse.h"
#import "SDLUpdateTurnListResponse.h"
#import "SDLUnregisterAppInterfaceResponse.h"
#import "SDLUnsubscribeButtonResponse.h"
#import "SDLUnsubscribeVehicleDataResponse.h"

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
