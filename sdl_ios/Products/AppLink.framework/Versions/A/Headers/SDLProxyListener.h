//  SDLProxyListener.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLAddCommandResponse.h>
#import <AppLink/SDLAddSubMenuResponse.h>
#import <AppLink/SDLAlertResponse.h>
#import <AppLink/SDLChangeRegistrationResponse.h>
#import <AppLink/SDLCreateInteractionChoiceSetResponse.h>
#import <AppLink/SDLDeleteCommandResponse.h>
#import <AppLink/SDLDeleteFileResponse.h>
#import <AppLink/SDLDeleteInteractionChoiceSetResponse.h>
#import <AppLink/SDLDeleteSubMenuResponse.h>
#import <AppLink/SDLDiagnosticMessageResponse.h>
#import <AppLink/SDLEncodedSyncPDataResponse.h>
#import <AppLink/SDLEndAudioPassThruResponse.h>
#import <AppLink/SDLGenericResponse.h>
#import <AppLink/SDLGetDTCsResponse.h>
#import <AppLink/SDLGetVehicleDataResponse.h>
#import <AppLink/SDLListFilesResponse.h>
#import <AppLink/SDLLockScreenStatus.h>
#import <AppLink/SDLOnAppInterfaceUnregistered.h>
#import <AppLink/SDLOnAudioPassThru.h>
#import <AppLink/SDLOnButtonEvent.h>
#import <AppLink/SDLOnButtonPress.h>
#import <AppLink/SDLOnCommand.h>
#import <AppLink/SDLOnDriverDistraction.h>
#import <AppLink/SDLOnEncodedSyncPData.h>
#import <AppLink/SDLOnHashChange.h>
#import <AppLink/SDLOnHMIStatus.h>
#import <AppLink/SDLOnLanguageChange.h>
#import <AppLink/SDLOnPermissionsChange.h>
#import <AppLink/SDLOnSyncPData.h>
#import <AppLink/SDLOnSystemRequest.h>
#import <AppLink/SDLOnVehicleData.h>
#import <AppLink/SDLOnTBTClientState.h>
#import <AppLink/SDLOnTouchEvent.h>
#import <AppLink/SDLOnVehicleData.h>
#import <AppLink/SDLPerformAudioPassThruResponse.h>
#import <AppLink/SDLPerformInteractionResponse.h>
#import <AppLink/SDLPutFileResponse.h>
#import <AppLink/SDLReadDIDResponse.h>
#import <AppLink/SDLRegisterAppInterfaceResponse.h>
#import <AppLink/SDLResetGlobalPropertiesResponse.h>
#import <AppLink/SDLScrollableMessageResponse.h>
#import <AppLink/SDLSetAppIconResponse.h>
#import <AppLink/SDLSetDisplayLayoutResponse.h>
#import <AppLink/SDLSetGlobalPropertiesResponse.h>
#import <AppLink/SDLSetMediaClockTimerResponse.h>
#import <AppLink/SDLShowConstantTBTResponse.h>
#import <AppLink/SDLShowResponse.h>
#import <AppLink/SDLSliderResponse.h>
#import <AppLink/SDLSpeakResponse.h>
#import <AppLink/SDLSubscribeButtonResponse.h>
#import <AppLink/SDLSubscribeVehicleDataResponse.h>
#import <AppLink/SDLSyncPDataResponse.h>
#import <AppLink/SDLUpdateTurnListResponse.h>
#import <AppLink/SDLUnregisterAppInterfaceResponse.h>
#import <AppLink/SDLUnsubscribeButtonResponse.h>
#import <AppLink/SDLUnsubscribeVehicleDataResponse.h>

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
