//
//  SDLNotificationConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Justin Dickow on 9/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"

NSString *const SDLNotificationUserInfoObject = @"SDLNotificationUserInfoObject";

// TODO: Further namespace since other notification types will be firing, e.g. state machine notifications
#pragma mark - General notifications
NSString *const SDLTransportDidDisconnect = @"com.sdl.transport.disconnect";
NSString *const SDLTransportDidConnect = @"com.sdl.transport.connect";
NSString *const SDLDidReceiveError = @"com.sdl.general.error";
NSString *const SDLDidReceiveLockScreenIcon = @"com.sdl.general.lockscreenIconReceived";
NSString *const SDLDidBecomeReady = @"com.sdl.notification.managerReady";


#pragma mark - RPC Responses
NSString *const SDLDidReceiveAddCommandResponse = @"com.sdl.response.addCommand";
NSString *const SDLDidReceiveAddSubMenuResponse = @"com.sdl.response.addSubMenu";
NSString *const SDLDidReceiveAlertResponse = @"com.sdl.response.alert";
NSString *const SDLDidReceiveAlertManeuverResponse = @"com.sdl.response.alertManeuver";
NSString *const SDLDidReceiveChangeRegistrationResponse = @"com.sdl.response.changeRegistration";
NSString *const SDLDidReceiveCreateInteractionChoiceSetResponse = @"com.sdl.response.createInteractionChoiceSet";
NSString *const SDLDidReceiveDeleteCommandResponse = @"com.sdl.response.deleteCommand";
NSString *const SDLDidReceiveDeleteFileResponse = @"com.sdl.response.deleteFile";
NSString *const SDLDidReceiveDeleteInteractionChoiceSetResponse = @"com.sdl.response.deleteInteractionChoiceSet";
NSString *const SDLDidReceiveDeleteSubmenuResponse = @"com.sdl.response.deleteSubmenu";
NSString *const SDLDidReceiveDiagnosticMessageResponse = @"com.sdl.response.diagnosticMessage";
NSString *const SDLDidReceiveDialNumberResponse = @"com.sdl.response.dialNumber";
NSString *const SDLDidReceiveEncodedSyncPDataResponse = @"com.sdl.response.encodedSyncPData";
NSString *const SDLDidReceiveEndAudioPassThruResponse = @"com.sdl.response.endAudioPassThru";
NSString *const SDLDidReceiveGenericResponse = @"com.sdl.response.generic";
NSString *const SDLDidReceiveGetDTCsResponse = @"com.sdl.response.getDTCs";
NSString *const SDLDidReceiveGetVehicleDataResponse = @"com.sdl.response.getVehicleData";
NSString *const SDLDidReceiveListFilesResponse = @"com.sdl.response.listFiles";
NSString *const SDLDidReceivePerformAudioPassThruResponse = @"com.sdl.response.performAudioPassThru";
NSString *const SDLDidReceivePerformInteractionResponse = @"com.sdl.response.performInteraction";
NSString *const SDLDidReceivePutFileResponse = @"com.sdl.response.putFile";
NSString *const SDLDidReceiveReadDIDResponse = @"com.sdl.response.readDID";
NSString *const SDLDidReceiveRegisterAppInterfaceResponse = @"com.sdl.response.registerAppInterface";
NSString *const SDLDidReceiveResetGlobalPropertiesResponse = @"com.sdl.response.resetGlobalProperties";
NSString *const SDLDidReceiveScrollableMessageResponse = @"com.sdl.response.scrollableMessage";
NSString *const SDLDidReceiveSendLocationResponse = @"com.sdl.response.sendLocation";
NSString *const SDLDidReceiveSetAppIconResponse = @"com.sdl.response.setAppIcon";
NSString *const SDLDidReceiveSetDisplayLayoutResponse = @"com.sdl.response.setDisplayLayout";
NSString *const SDLDidReceiveSetGlobalPropertiesResponse = @"com.sdl.response.setGlobalProperties";
NSString *const SDLDidReceiveSetMediaClockTimerResponse = @"com.sdl.response.setMediaClockTimer";
NSString *const SDLDidReceiveShowConstantTBTResponse = @"com.sdl.response.showConstantTBT";
NSString *const SDLDidReceiveShowResponse = @"com.sdl.response.show";
NSString *const SDLDidReceiveSliderResponse = @"com.sdl.response.slider";
NSString *const SDLDidReceiveSpeakResponse = @"com.sdl.response.speak";
NSString *const SDLDidReceiveSubscribeButtonResponse = @"com.sdl.response.subscribeButton";
NSString *const SDLDidReceiveSubscribeVehicleDataResponse = @"com.sdl.response.subscribeVehicleData";
NSString *const SDLDidReceiveSyncPDataResponse = @"com.sdl.response.syncPData";
NSString *const SDLDidReceiveUpdateTurnListResponse = @"com.sdl.response.updateTurnList";
NSString *const SDLDidReceiveUnregisterAppInterfaceResponse = @"com.sdl.response.unregisterAppInterface";
NSString *const SDLDidReceiveUnsubscribeButtonResponse = @"com.sdl.response.unsubscribeButton";
NSString *const SDLDidReceiveUnsubscribeVehicleDataResponse = @"com.sdl.response.unsubscribeVehicleData";

#pragma mark - RPC Notifications
NSString *const SDLDidChangeDriverDistractionStateNotification = @"com.sdl.notification.changeDriverDistractionStateNotification";
NSString *const SDLDidChangeHMIStatusNotification = @"com.sdl.notification.changeHMIStatus";
NSString *const SDLDidReceiveAudioPassThruNotification = @"com.sdl.notification.audioPassThru";
NSString *const SDLDidReceiveAppUnregisteredNotification = @"com.sdl.notification.appUnregistered";
NSString *const SDLDidReceiveButtonEventNotification = @"com.sdl.notification.buttonEvent";
NSString *const SDLDidReceiveButtonPressNotification = @"com.sdl.notification.buttonPress";
NSString *const SDLDidReceiveCommandNotification = @"com.sdl.notification.command";
NSString *const SDLDidReceiveEncodedDataNotification = @"com.sdl.notification.encodedData";
NSString *const SDLDidReceiveNewHashNotification = @"com.sdl.notification.newHash";
NSString *const SDLDidChangeLanguageNotification = @"com.sdl.notification.changeLanguage";
NSString *const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.lockScreenStatus";
NSString *const SDLDidChangePermissionsNotification = @"com.sdl.notification.changePermission";
NSString *const SDLDidReceiveSystemRequestNotification = @"com.sdl.notification.receiveSystemRequest";
NSString *const SDLDidChangeTurnByTurnStateNotification = @"com.sdl.notification.changeTurnByTurnState";
NSString *const SDLDidReceiveTouchEventNotification = @"com.sdl.notification.touchEvent";
NSString *const SDLDidReceiveVehicleDataNotification = @"com.sdl.notification.vehicleData";
