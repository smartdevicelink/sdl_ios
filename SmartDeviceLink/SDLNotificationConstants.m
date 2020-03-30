//
//  SDLNotificationConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Justin Dickow on 9/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"

/// These notifications will be returned on a background serial queue

SDLNotificationUserInfoKey const SDLNotificationUserInfoObject = @"SDLNotificationUserInfoObject";


#pragma mark - General notifications
SDLNotificationName const SDLTransportDidDisconnect = @"com.sdl.transport.disconnect";
SDLNotificationName const SDLTransportDidConnect = @"com.sdl.transport.connect";
SDLNotificationName const SDLTransportConnectError = @"com.sdl.transport.connectError";
SDLNotificationName const SDLDidReceiveError = @"com.sdl.general.error";
SDLNotificationName const SDLDidReceiveLockScreenIcon = @"com.sdl.general.lockscreenIconReceived";
SDLNotificationName const SDLDidBecomeReady = @"com.sdl.notification.managerReady";
SDLNotificationName const SDLDidReceiveVehicleIconNotification = @"com.sdl.notification.vehicleIcon";
SDLNotificationName const SDLDidUpdateProjectionView = @"com.sdl.notification.projectionViewUpdate";

#pragma mark - RPC Responses
SDLNotificationName const SDLDidReceiveAddCommandResponse = @"com.sdl.response.addCommand";
SDLNotificationName const SDLDidReceiveAddSubMenuResponse = @"com.sdl.response.addSubMenu";
SDLNotificationName const SDLDidReceiveAlertResponse = @"com.sdl.response.alert";
SDLNotificationName const SDLDidReceiveAlertManeuverResponse = @"com.sdl.response.alertManeuver";
SDLNotificationName const SDLDidReceiveButtonPressResponse = @"com.sdl.response.buttonPress";
SDLNotificationName const SDLDidReceiveCancelInteractionResponse = @"com.sdl.response.cancelInteraction";
SDLNotificationName const SDLDidReceiveChangeRegistrationResponse = @"com.sdl.response.changeRegistration";
SDLNotificationName const SDLDidReceiveCloseApplicationResponse = @"com.sdl.response.closeApplication";
SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetResponse = @"com.sdl.response.createInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveCreateWindowResponse = @"com.sdl.response.createWindow";
SDLNotificationName const SDLDidReceiveDeleteCommandResponse = @"com.sdl.response.deleteCommand";
SDLNotificationName const SDLDidReceiveDeleteFileResponse = @"com.sdl.response.deleteFile";
SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetResponse = @"com.sdl.response.deleteInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteSubmenuResponse = @"com.sdl.response.deleteSubmenu";
SDLNotificationName const SDLDidReceiveDeleteWindowResponse = @"com.sdl.response.deleteWindow";
SDLNotificationName const SDLDidReceiveDiagnosticMessageResponse = @"com.sdl.response.diagnosticMessage";
SDLNotificationName const SDLDidReceiveDialNumberResponse = @"com.sdl.response.dialNumber";
SDLNotificationName const SDLDidReceiveEncodedSyncPDataResponse = @"com.sdl.response.encodedSyncPData";
SDLNotificationName const SDLDidReceiveEndAudioPassThruResponse = @"com.sdl.response.endAudioPassThru";
SDLNotificationName const SDLDidReceiveGenericResponse = @"com.sdl.response.generic";
SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesResponse = @"com.sdl.response.getCloudAppProperties";
SDLNotificationName const SDLDidReceiveGetAppServiceDataResponse = @"com.sdl.response.getAppServiceData";
SDLNotificationName const SDLDidReceiveGetDTCsResponse = @"com.sdl.response.getDTCs";
SDLNotificationName const SDLDidReceiveGetFileResponse = @"com.sdl.response.getFile";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataResponse = @"com.sdl.response.getInteriorVehicleData";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentResponse = @"com.sdl.response.getInteriorVehicleDataConsent";
SDLNotificationName const SDLDidReceiveGetSystemCapabilitiesResponse = @"com.sdl.response.getSystemCapabilities";
SDLNotificationName const SDLDidReceiveGetVehicleDataResponse = @"com.sdl.response.getVehicleData";
SDLNotificationName const SDLDidReceiveGetWaypointsResponse = @"com.sdl.response.getWaypoints";
SDLNotificationName const SDLDidReceiveListFilesResponse = @"com.sdl.response.listFiles";
SDLNotificationName const SDLDidReceivePerformAppServiceInteractionResponse = @"com.sdl.response.performAppServiceInteraction";
SDLNotificationName const SDLDidReceivePerformAudioPassThruResponse = @"com.sdl.response.performAudioPassThru";
SDLNotificationName const SDLDidReceivePerformInteractionResponse = @"com.sdl.response.performInteraction";
SDLNotificationName const SDLDidReceivePublishAppServiceResponse = @"com.sdl.response.publishAppService";
SDLNotificationName const SDLDidReceivePutFileResponse = @"com.sdl.response.putFile";
SDLNotificationName const SDLDidReceiveReadDIDResponse = @"com.sdl.response.readDID";
SDLNotificationName const SDLDidReceiveRegisterAppInterfaceResponse = @"com.sdl.response.registerAppInterface";
SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleResponse = @"com.sdl.response.releaseInteriorVehicleDataModule";
SDLNotificationName const SDLDidReceiveResetGlobalPropertiesResponse = @"com.sdl.response.resetGlobalProperties";
SDLNotificationName const SDLDidReceiveScrollableMessageResponse = @"com.sdl.response.scrollableMessage";
SDLNotificationName const SDLDidReceiveSendHapticDataResponse = @"com.sdl.response.sendHapticData";
SDLNotificationName const SDLDidReceiveSendLocationResponse = @"com.sdl.response.sendLocation";
SDLNotificationName const SDLDidReceiveSetAppIconResponse = @"com.sdl.response.setAppIcon";
SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesResponse = @"com.sdl.response.setCloudAppProperties";
SDLNotificationName const SDLDidReceiveSetDisplayLayoutResponse = @"com.sdl.response.setDisplayLayout";
SDLNotificationName const SDLDidReceiveSetGlobalPropertiesResponse = @"com.sdl.response.setGlobalProperties";
SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataResponse = @"com.sdl.response.setInteriorVehicleData";
SDLNotificationName const SDLDidReceiveSetMediaClockTimerResponse = @"com.sdl.response.setMediaClockTimer";
SDLNotificationName const SDLDidReceiveShowConstantTBTResponse = @"com.sdl.response.showConstantTBT";
SDLNotificationName const SDLDidReceiveShowResponse = @"com.sdl.response.show";
SDLNotificationName const SDLDidReceiveShowAppMenuResponse = @"com.sdl.response.showAppMenu";
SDLNotificationName const SDLDidReceiveSliderResponse = @"com.sdl.response.slider";
SDLNotificationName const SDLDidReceiveSpeakResponse = @"com.sdl.response.speak";
SDLNotificationName const SDLDidReceiveSubscribeButtonResponse = @"com.sdl.response.subscribeButton";
SDLNotificationName const SDLDidReceiveSubscribeVehicleDataResponse = @"com.sdl.response.subscribeVehicleData";
SDLNotificationName const SDLDidReceiveSubscribeWaypointsResponse = @"com.sdl.response.subscribeWaypoints";
SDLNotificationName const SDLDidReceiveSyncPDataResponse = @"com.sdl.response.syncPData";
SDLNotificationName const SDLDidReceiveUpdateTurnListResponse = @"com.sdl.response.updateTurnList";
SDLNotificationName const SDLDidReceiveUnpublishAppServiceResponse = @"com.sdl.response.unpublishAppService";
SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceResponse = @"com.sdl.response.unregisterAppInterface";
SDLNotificationName const SDLDidReceiveUnsubscribeButtonResponse = @"com.sdl.response.unsubscribeButton";
SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataResponse = @"com.sdl.response.unsubscribeVehicleData";
SDLNotificationName const SDLDidReceiveUnsubscribeWaypointsResponse = @"com.sdl.response.unsubscribeWaypoints";

#pragma mark - RPC Requests
SDLNotificationName const SDLDidReceiveAddCommandRequest = @"com.sdl.request.addCommand";
SDLNotificationName const SDLDidReceiveAddSubMenuRequest = @"com.sdl.request.addSubMenu";
SDLNotificationName const SDLDidReceiveAlertRequest = @"com.sdl.request.alert";
SDLNotificationName const SDLDidReceiveAlertManeuverRequest = @"com.sdl.request.alertManeuver";
SDLNotificationName const SDLDidReceiveButtonPressRequest = @"com.sdl.request.buttonPress";
SDLNotificationName const SDLDidReceiveCancelInteractionRequest = @"com.sdl.request.cancelInteraction";
SDLNotificationName const SDLDidReceiveChangeRegistrationRequest = @"com.sdl.request.changeRegistration";
SDLNotificationName const SDLDidReceiveCloseApplicationRequest = @"com.sdl.request.closeApplication";
SDLNotificationName const SDLDidReceiveCreateWindowRequest = @"com.sdl.request.createWindow";
SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetRequest = @"com.sdl.request.createInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteCommandRequest = @"com.sdl.request.deleteCommand";
SDLNotificationName const SDLDidReceiveDeleteFileRequest = @"com.sdl.request.deleteFile";
SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetRequest = @"com.sdl.request.deleteInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteSubMenuRequest = @"com.sdl.request.deleteSubMenu";
SDLNotificationName const SDLDidReceiveDeleteWindowRequest = @"com.sdl.request.deleteWindow";
SDLNotificationName const SDLDidReceiveDiagnosticMessageRequest = @"com.sdl.request.diagnosticMessage";
SDLNotificationName const SDLDidReceiveDialNumberRequest = @"com.sdl.request.dialNumber";
SDLNotificationName const SDLDidReceiveEncodedSyncPDataRequest = @"com.sdl.request.encodedSyncPData";
SDLNotificationName const SDLDidReceiveEndAudioPassThruRequest = @"com.sdl.request.endAudioPassThru";
SDLNotificationName const SDLDidReceiveGetAppServiceDataRequest = @"com.sdl.request.getAppServiceData";
SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesRequest = @"com.sdl.request.getCloudAppProperties";
SDLNotificationName const SDLDidReceiveGetDTCsRequest = @"com.sdl.request.getDTCs";
SDLNotificationName const SDLDidReceiveGetFileRequest = @"com.sdl.request.getFile";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataRequest = @"com.sdl.request.getInteriorVehicleData";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentRequest = @"com.sdl.request.getInteriorVehicleDataConsent";
SDLNotificationName const SDLDidReceiveGetSystemCapabilityRequest = @"com.sdl.request.getSystemCapability";
SDLNotificationName const SDLDidReceiveGetVehicleDataRequest = @"com.sdl.request.getVehicleData";
SDLNotificationName const SDLDidReceiveGetWayPointsRequest = @"com.sdl.request.getWayPoints";
SDLNotificationName const SDLDidReceiveListFilesRequest = @"com.sdl.request.listFiles";
SDLNotificationName const SDLDidReceivePerformAppServiceInteractionRequest = @"com.sdl.request.performAppServiceInteraction";
SDLNotificationName const SDLDidReceivePerformAudioPassThruRequest = @"com.sdl.request.performAudioPassThru";
SDLNotificationName const SDLDidReceivePerformInteractionRequest = @"com.sdl.request.performInteraction";
SDLNotificationName const SDLDidReceivePublishAppServiceRequest = @"com.sdl.request.publishAppService";
SDLNotificationName const SDLDidReceivePutFileRequest = @"com.sdl.request.putFile";
SDLNotificationName const SDLDidReceiveReadDIDRequest = @"com.sdl.request.readDID";
SDLNotificationName const SDLDidReceiveRegisterAppInterfaceRequest = @"com.sdl.request.registerAppInterface";
SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleRequest = @"com.sdl.request.releaseInteriorVehicleDataModule";
SDLNotificationName const SDLDidReceiveResetGlobalPropertiesRequest = @"com.sdl.request.resetGlobalProperties";
SDLNotificationName const SDLDidReceiveScrollableMessageRequest = @"com.sdl.request.scrollableMessage";
SDLNotificationName const SDLDidReceiveSendHapticDataRequest = @"com.sdl.request.sendHapticData";
SDLNotificationName const SDLDidReceiveSendLocationRequest = @"com.sdl.request.sendLocation";
SDLNotificationName const SDLDidReceiveSetAppIconRequest = @"com.sdl.request.setAppIcon";
SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesRequest = @"com.sdl.request.setCloudAppProperties";
SDLNotificationName const SDLDidReceiveSetDisplayLayoutRequest = @"com.sdl.request.setDisplayLayout";
SDLNotificationName const SDLDidReceiveSetGlobalPropertiesRequest = @"com.sdl.request.setGlobalProperties";
SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataRequest = @"com.sdl.request.setInteriorVehicleData";
SDLNotificationName const SDLDidReceiveSetMediaClockTimerRequest = @"com.sdl.request.setMediaClockTimer";
SDLNotificationName const SDLDidReceiveShowRequest = @"com.sdl.request.show";
SDLNotificationName const SDLDidReceiveShowAppMenuRequest = @"com.sdl.request.showAppMenu";
SDLNotificationName const SDLDidReceiveShowConstantTBTRequest = @"com.sdl.request.showConstantTBT";
SDLNotificationName const SDLDidReceiveSliderRequest = @"com.sdl.request.slider";
SDLNotificationName const SDLDidReceiveSpeakRequest = @"com.sdl.request.speak";
SDLNotificationName const SDLDidReceiveSubscribeButtonRequest = @"com.sdl.request.subscribeButton";
SDLNotificationName const SDLDidReceiveSubscribeVehicleDataRequest = @"com.sdl.request.subscribeVehicleData";
SDLNotificationName const SDLDidReceiveSubscribeWayPointsRequest = @"com.sdl.request.subscribeWayPoints";
SDLNotificationName const SDLDidReceiveSyncPDataRequest = @"com.sdl.request.syncPData";
SDLNotificationName const SDLDidReceiveSystemRequestRequest = @"com.sdl.request.systemRequest";
SDLNotificationName const SDLDidReceiveUnpublishAppServiceRequest = @"com.sdl.request.unpublishAppService";
SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceRequest = @"com.sdl.request.unregisterAppInterface";
SDLNotificationName const SDLDidReceiveUnsubscribeButtonRequest = @"com.sdl.request.unsubscribeButton";
SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataRequest = @"com.sdl.request.unsubscribeVehicleData";
SDLNotificationName const SDLDidReceiveUnsubscribeWayPointsRequest = @"com.sdl.request.unsubscribeWayPoints";
SDLNotificationName const SDLDidReceiveUpdateTurnListRequest = @"com.sdl.request.updateTurnList";

#pragma mark - RPC Notifications
SDLNotificationName const SDLDidChangeDriverDistractionStateNotification = @"com.sdl.notification.changeDriverDistractionStateNotification";
SDLNotificationName const SDLDidChangeHMIStatusNotification = @"com.sdl.notification.changeHMIStatus";
SDLNotificationName const SDLDidReceiveAppServiceDataNotification = @"com.sdl.notification.appServiceData";
SDLNotificationName const SDLDidReceiveAppUnregisteredNotification = @"com.sdl.notification.appUnregistered";
SDLNotificationName const SDLDidReceiveAudioPassThruNotification = @"com.sdl.notification.audioPassThru";
SDLNotificationName const SDLDidReceiveButtonEventNotification = @"com.sdl.notification.buttonEvent";
SDLNotificationName const SDLDidReceiveButtonPressNotification = @"com.sdl.notification.buttonPress";
SDLNotificationName const SDLDidReceiveCommandNotification = @"com.sdl.notification.command";
SDLNotificationName const SDLDidReceiveEncodedDataNotification = @"com.sdl.notification.encodedData";
SDLNotificationName const SDLDidReceiveInteriorVehicleDataNotification = @"com.sdl.notification.interiorVehicleData";
SDLNotificationName const SDLDidReceiveKeyboardInputNotification = @"com.sdl.notification.keyboardInput";
SDLNotificationName const SDLDidChangeLanguageNotification = @"com.sdl.notification.changeLanguage";
SDLNotificationName const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.lockScreenStatus";
SDLNotificationName const SDLDidReceiveNewHashNotification = @"com.sdl.notification.newHash";
SDLNotificationName const SDLDidChangePermissionsNotification = @"com.sdl.notification.changePermission";
SDLNotificationName const SDLDidReceiveRemoteControlStatusNotification = @"com.sdl.notification.rcStatus";
SDLNotificationName const SDLDidReceiveSyncPDataNotification = @"com.sdl.notification.syncpdata";
SDLNotificationName const SDLDidReceiveSystemCapabilityUpdatedNotification = @"com.sdl.notification.systemCapabilityUpdated";
SDLNotificationName const SDLDidReceiveSystemRequestNotification = @"com.sdl.notification.receiveSystemRequest";
SDLNotificationName const SDLDidChangeTurnByTurnStateNotification = @"com.sdl.notification.changeTurnByTurnState";
SDLNotificationName const SDLDidReceiveTouchEventNotification = @"com.sdl.notification.touchEvent";
SDLNotificationName const SDLDidReceiveVehicleDataNotification = @"com.sdl.notification.vehicleData";
SDLNotificationName const SDLDidReceiveWaypointNotification = @"com.sdl.notification.waypoint";


@implementation SDLNotificationConstants

+ (NSArray<SDLNotificationName> *)allResponseNames {
    return @[SDLDidReceiveAddCommandResponse,
             SDLDidReceiveAddSubMenuResponse,
             SDLDidReceiveAlertResponse,
             SDLDidReceiveAlertManeuverResponse,
             SDLDidReceiveButtonPressResponse,
             SDLDidReceiveCancelInteractionResponse,
             SDLDidReceiveChangeRegistrationResponse,
             SDLDidReceiveCloseApplicationResponse,
             SDLDidReceiveCreateInteractionChoiceSetResponse,
             SDLDidReceiveCreateWindowResponse,
             SDLDidReceiveDeleteCommandResponse,
             SDLDidReceiveDeleteFileResponse,
             SDLDidReceiveDeleteInteractionChoiceSetResponse,
             SDLDidReceiveDeleteSubmenuResponse,
             SDLDidReceiveDeleteWindowResponse,
             SDLDidReceiveDiagnosticMessageResponse,
             SDLDidReceiveDialNumberResponse,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             SDLDidReceiveEncodedSyncPDataResponse,
#pragma clang diagnostic pop
             SDLDidReceiveEndAudioPassThruResponse,
             SDLDidReceiveGenericResponse,
             SDLDidReceiveGetCloudAppPropertiesResponse,
             SDLDidReceiveGetAppServiceDataResponse,
             SDLDidReceiveGetDTCsResponse,
             SDLDidReceiveGetFileResponse,
             SDLDidReceiveGetInteriorVehicleDataResponse,
             SDLDidReceiveGetInteriorVehicleDataConsentResponse,
             SDLDidReceiveGetSystemCapabilitiesResponse,
             SDLDidReceiveGetVehicleDataResponse,
             SDLDidReceiveGetWaypointsResponse,
             SDLDidReceiveListFilesResponse,
             SDLDidReceivePerformAppServiceInteractionResponse,
             SDLDidReceivePerformAudioPassThruResponse,
             SDLDidReceivePerformInteractionResponse,
             SDLDidReceivePublishAppServiceResponse,
             SDLDidReceivePutFileResponse,
             SDLDidReceiveReadDIDResponse,
             SDLDidReceiveRegisterAppInterfaceResponse,
             SDLDidReceiveReleaseInteriorVehicleDataModuleResponse,
             SDLDidReceiveResetGlobalPropertiesResponse,
             SDLDidReceiveScrollableMessageResponse,
             SDLDidReceiveSendHapticDataResponse,
             SDLDidReceiveSendLocationResponse,
             SDLDidReceiveSetAppIconResponse,
             SDLDidReceiveSetCloudAppPropertiesResponse,
             SDLDidReceiveSetDisplayLayoutResponse,
             SDLDidReceiveSetGlobalPropertiesResponse,
             SDLDidReceiveSetInteriorVehicleDataResponse,
             SDLDidReceiveSetMediaClockTimerResponse,
             SDLDidReceiveShowConstantTBTResponse,
             SDLDidReceiveShowResponse,
             SDLDidReceiveShowAppMenuResponse,
             SDLDidReceiveSliderResponse,
             SDLDidReceiveSpeakResponse,
             SDLDidReceiveSubscribeButtonResponse,
             SDLDidReceiveSubscribeVehicleDataResponse,
             SDLDidReceiveSubscribeWaypointsResponse,
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
             SDLDidReceiveSyncPDataResponse,
#pragma clang diagnostic pop
             SDLDidReceiveUpdateTurnListResponse,
             SDLDidReceiveUnpublishAppServiceResponse,
             SDLDidReceiveUnregisterAppInterfaceResponse,
             SDLDidReceiveUnsubscribeButtonResponse,
             SDLDidReceiveUnsubscribeVehicleDataResponse,
             SDLDidReceiveUnsubscribeWaypointsResponse];
}

+ (NSArray<SDLNotificationName> *)allButtonEventNotifications {
    return @[SDLDidReceiveButtonEventNotification,
             SDLDidReceiveButtonPressNotification];
}

@end
