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
SDLNotificationName const SDLRPCServiceDidDisconnect = @"com.sdl.rpcService.disconnect";
SDLNotificationName const SDLRPCServiceDidConnect = @"com.sdl.rpcService.connect";
SDLNotificationName const SDLRPCServiceConnectionDidError = @"com.sdl.rpcService.connectError";
SDLNotificationName const SDLDidReceiveError = @"com.sdl.general.error";
SDLNotificationName const SDLDidReceiveLockScreenIcon = @"com.sdl.general.lockscreenIconReceived";
SDLNotificationName const SDLDidBecomeReady = @"com.sdl.notification.managerReady";
SDLNotificationName const SDLDidReceiveVehicleIconNotification = @"com.sdl.notification.vehicleIcon";
SDLNotificationName const SDLDidUpdateProjectionView = @"com.sdl.notification.projectionViewUpdate";
SDLNotificationName const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.lockScreenStatus";

#pragma mark - RPC Responses
SDLNotificationName const SDLDidReceiveAddCommandResponse = @"com.sdl.response.AddCommand";
SDLNotificationName const SDLDidReceiveAddSubMenuResponse = @"com.sdl.response.AddSubMenu";
SDLNotificationName const SDLDidReceiveAlertResponse = @"com.sdl.response.Alert";
SDLNotificationName const SDLDidReceiveAlertManeuverResponse = @"com.sdl.response.AlertManeuver";
SDLNotificationName const SDLDidReceiveButtonPressResponse = @"com.sdl.response.ButtonPress";
SDLNotificationName const SDLDidReceiveCancelInteractionResponse = @"com.sdl.response.CancelInteraction";
SDLNotificationName const SDLDidReceiveChangeRegistrationResponse = @"com.sdl.response.ChangeRegistration";
SDLNotificationName const SDLDidReceiveCloseApplicationResponse = @"com.sdl.response.CloseApplication";
SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetResponse = @"com.sdl.response.CreateInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveCreateWindowResponse = @"com.sdl.response.CreateWindow";
SDLNotificationName const SDLDidReceiveDeleteCommandResponse = @"com.sdl.response.DeleteCommand";
SDLNotificationName const SDLDidReceiveDeleteFileResponse = @"com.sdl.response.DeleteFile";
SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetResponse = @"com.sdl.response.DeleteInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteSubmenuResponse = @"com.sdl.response.DeleteSubMenu";
SDLNotificationName const SDLDidReceiveDeleteWindowResponse = @"com.sdl.response.DeleteWindow";
SDLNotificationName const SDLDidReceiveDiagnosticMessageResponse = @"com.sdl.response.DiagnosticMessage";
SDLNotificationName const SDLDidReceiveDialNumberResponse = @"com.sdl.response.DialNumber";
SDLNotificationName const SDLDidReceiveEncodedSyncPDataResponse = @"com.sdl.response.EncodedSyncPData";
SDLNotificationName const SDLDidReceiveEndAudioPassThruResponse = @"com.sdl.response.EndAudioPassThru";
SDLNotificationName const SDLDidReceiveGenericResponse = @"com.sdl.response.GenericResponse";
SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesResponse = @"com.sdl.response.GetCloudAppProperties";
SDLNotificationName const SDLDidReceiveGetAppServiceDataResponse = @"com.sdl.response.GetAppServiceData";
SDLNotificationName const SDLDidReceiveGetDTCsResponse = @"com.sdl.response.GetDTCs";
SDLNotificationName const SDLDidReceiveGetFileResponse = @"com.sdl.response.GetFile";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataResponse = @"com.sdl.response.GetInteriorVehicleData";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentResponse = @"com.sdl.response.GetInteriorVehicleDataConsent";
SDLNotificationName const SDLDidReceiveGetSystemCapabilitiesResponse = @"com.sdl.response.GetSystemCapability";
SDLNotificationName const SDLDidReceiveGetVehicleDataResponse = @"com.sdl.response.GetVehicleData";
SDLNotificationName const SDLDidReceiveGetWaypointsResponse = @"com.sdl.response.GetWayPoints";
SDLNotificationName const SDLDidReceiveListFilesResponse = @"com.sdl.response.ListFiles";
SDLNotificationName const SDLDidReceivePerformAppServiceInteractionResponse = @"com.sdl.response.PerformAppServiceInteraction";
SDLNotificationName const SDLDidReceivePerformAudioPassThruResponse = @"com.sdl.response.PerformAudioPassThru";
SDLNotificationName const SDLDidReceivePerformInteractionResponse = @"com.sdl.response.PerformInteraction";
SDLNotificationName const SDLDidReceivePublishAppServiceResponse = @"com.sdl.response.PublishAppService";
SDLNotificationName const SDLDidReceivePutFileResponse = @"com.sdl.response.PutFile";
SDLNotificationName const SDLDidReceiveReadDIDResponse = @"com.sdl.response.ReadDID";
SDLNotificationName const SDLDidReceiveRegisterAppInterfaceResponse = @"com.sdl.response.RegisterAppInterface";
SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleResponse = @"com.sdl.response.ReleaseInteriorVehicleDataModule";
SDLNotificationName const SDLDidReceiveResetGlobalPropertiesResponse = @"com.sdl.response.ResetGlobalProperties";
SDLNotificationName const SDLDidReceiveScrollableMessageResponse = @"com.sdl.response.ScrollableMessage";
SDLNotificationName const SDLDidReceiveSendHapticDataResponse = @"com.sdl.response.SendHapticData";
SDLNotificationName const SDLDidReceiveSendLocationResponse = @"com.sdl.response.SendLocation";
SDLNotificationName const SDLDidReceiveSetAppIconResponse = @"com.sdl.response.SetAppIcon";
SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesResponse = @"com.sdl.response.SetCloudAppProperties";
SDLNotificationName const SDLDidReceiveSetDisplayLayoutResponse = @"com.sdl.response.SetDisplayLayout";
SDLNotificationName const SDLDidReceiveSetGlobalPropertiesResponse = @"com.sdl.response.SetGlobalProperties";
SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataResponse = @"com.sdl.response.SetInteriorVehicleData";
SDLNotificationName const SDLDidReceiveSetMediaClockTimerResponse = @"com.sdl.response.SetMediaClockTimer";
SDLNotificationName const SDLDidReceiveShowConstantTBTResponse = @"com.sdl.response.ShowConstantTBT";
SDLNotificationName const SDLDidReceiveShowResponse = @"com.sdl.response.Show";
SDLNotificationName const SDLDidReceiveShowAppMenuResponse = @"com.sdl.response.ShowAppMenu";
SDLNotificationName const SDLDidReceiveSliderResponse = @"com.sdl.response.Slider";
SDLNotificationName const SDLDidReceiveSpeakResponse = @"com.sdl.response.Speak";
SDLNotificationName const SDLDidReceiveSubscribeButtonResponse = @"com.sdl.response.SubscribeButton";
SDLNotificationName const SDLDidReceiveSubscribeVehicleDataResponse = @"com.sdl.response.SubscribeVehicleData";
SDLNotificationName const SDLDidReceiveSubscribeWaypointsResponse = @"com.sdl.response.SubscribeWayPoints";
SDLNotificationName const SDLDidReceiveSyncPDataResponse = @"com.sdl.response.SyncPData";
SDLNotificationName const SDLDidReceiveSystemRequestResponse = @"com.sdl.response.SystemRequest";
SDLNotificationName const SDLDidReceiveUpdateTurnListResponse = @"com.sdl.response.UpdateTurnList";
SDLNotificationName const SDLDidReceiveUnpublishAppServiceResponse = @"com.sdl.response.UnpublishAppService";
SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceResponse = @"com.sdl.response.UnregisterAppInterface";
SDLNotificationName const SDLDidReceiveUnsubscribeButtonResponse = @"com.sdl.response.UnsubscribeButton";
SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataResponse = @"com.sdl.response.UnsubscribeVehicleData";
SDLNotificationName const SDLDidReceiveUnsubscribeWaypointsResponse = @"com.sdl.response.UnsubscribeWayPoints";

#pragma mark - RPC Requests
SDLNotificationName const SDLDidReceiveAddCommandRequest = @"com.sdl.request.AddCommand";
SDLNotificationName const SDLDidReceiveAddSubMenuRequest = @"com.sdl.request.AddSubMenu";
SDLNotificationName const SDLDidReceiveAlertRequest = @"com.sdl.request.Alert";
SDLNotificationName const SDLDidReceiveAlertManeuverRequest = @"com.sdl.request.AlertManeuver";
SDLNotificationName const SDLDidReceiveButtonPressRequest = @"com.sdl.request.ButtonPress";
SDLNotificationName const SDLDidReceiveCancelInteractionRequest = @"com.sdl.request.CancelInteraction";
SDLNotificationName const SDLDidReceiveChangeRegistrationRequest = @"com.sdl.request.ChangeRegistration";
SDLNotificationName const SDLDidReceiveCloseApplicationRequest = @"com.sdl.request.CloseApplication";
SDLNotificationName const SDLDidReceiveCreateWindowRequest = @"com.sdl.request.CreateWindow";
SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetRequest = @"com.sdl.request.CreateInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteCommandRequest = @"com.sdl.request.DeleteCommand";
SDLNotificationName const SDLDidReceiveDeleteFileRequest = @"com.sdl.request.DeleteFile";
SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetRequest = @"com.sdl.request.DeleteInteractionChoiceSet";
SDLNotificationName const SDLDidReceiveDeleteSubMenuRequest = @"com.sdl.request.DeleteSubMenu";
SDLNotificationName const SDLDidReceiveDeleteWindowRequest = @"com.sdl.request.DeleteWindow";
SDLNotificationName const SDLDidReceiveDiagnosticMessageRequest = @"com.sdl.request.DiagnosticMessage";
SDLNotificationName const SDLDidReceiveDialNumberRequest = @"com.sdl.request.DialNumber";
SDLNotificationName const SDLDidReceiveEncodedSyncPDataRequest = @"com.sdl.request.EncodedSyncPData";
SDLNotificationName const SDLDidReceiveEndAudioPassThruRequest = @"com.sdl.request.EndAudioPassThru";
SDLNotificationName const SDLDidReceiveGetAppServiceDataRequest = @"com.sdl.request.GetAppServiceData";
SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesRequest = @"com.sdl.request.GetCloudAppProperties";
SDLNotificationName const SDLDidReceiveGetDTCsRequest = @"com.sdl.request.GetDTCs";
SDLNotificationName const SDLDidReceiveGetFileRequest = @"com.sdl.request.GetFile";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataRequest = @"com.sdl.request.GetInteriorVehicleData";
SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentRequest = @"com.sdl.request.GetInteriorVehicleDataConsent";
SDLNotificationName const SDLDidReceiveGetSystemCapabilityRequest = @"com.sdl.request.GetSystemCapability";
SDLNotificationName const SDLDidReceiveGetVehicleDataRequest = @"com.sdl.request.GetVehicleData";
SDLNotificationName const SDLDidReceiveGetWayPointsRequest = @"com.sdl.request.GetWayPoints";
SDLNotificationName const SDLDidReceiveListFilesRequest = @"com.sdl.request.ListFiles";
SDLNotificationName const SDLDidReceivePerformAppServiceInteractionRequest = @"com.sdl.request.PerformAppServiceInteraction";
SDLNotificationName const SDLDidReceivePerformAudioPassThruRequest = @"com.sdl.request.PerformAudioPassThru";
SDLNotificationName const SDLDidReceivePerformInteractionRequest = @"com.sdl.request.PerformInteraction";
SDLNotificationName const SDLDidReceivePublishAppServiceRequest = @"com.sdl.request.PublishAppService";
SDLNotificationName const SDLDidReceivePutFileRequest = @"com.sdl.request.PutFile";
SDLNotificationName const SDLDidReceiveReadDIDRequest = @"com.sdl.request.ReadDID";
SDLNotificationName const SDLDidReceiveRegisterAppInterfaceRequest = @"com.sdl.request.RegisterAppInterface";
SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleRequest = @"com.sdl.request.ReleaseInteriorVehicleDataModule";
SDLNotificationName const SDLDidReceiveResetGlobalPropertiesRequest = @"com.sdl.request.ResetGlobalProperties";
SDLNotificationName const SDLDidReceiveScrollableMessageRequest = @"com.sdl.request.ScrollableMessage";
SDLNotificationName const SDLDidReceiveSendHapticDataRequest = @"com.sdl.request.SendHapticData";
SDLNotificationName const SDLDidReceiveSendLocationRequest = @"com.sdl.request.SendLocation";
SDLNotificationName const SDLDidReceiveSetAppIconRequest = @"com.sdl.request.SetAppIcon";
SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesRequest = @"com.sdl.request.SetCloudAppProperties";
SDLNotificationName const SDLDidReceiveSetDisplayLayoutRequest = @"com.sdl.request.SetDisplayLayout";
SDLNotificationName const SDLDidReceiveSetGlobalPropertiesRequest = @"com.sdl.request.SetGlobalProperties";
SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataRequest = @"com.sdl.request.SetInteriorVehicleData";
SDLNotificationName const SDLDidReceiveSetMediaClockTimerRequest = @"com.sdl.request.SetMediaClockTimer";
SDLNotificationName const SDLDidReceiveShowRequest = @"com.sdl.request.Show";
SDLNotificationName const SDLDidReceiveShowAppMenuRequest = @"com.sdl.request.ShowAppMenu";
SDLNotificationName const SDLDidReceiveShowConstantTBTRequest = @"com.sdl.request.ShowConstantTBT";
SDLNotificationName const SDLDidReceiveSliderRequest = @"com.sdl.request.Slider";
SDLNotificationName const SDLDidReceiveSpeakRequest = @"com.sdl.request.Speak";
SDLNotificationName const SDLDidReceiveSubscribeButtonRequest = @"com.sdl.request.SubscribeButton";
SDLNotificationName const SDLDidReceiveSubscribeVehicleDataRequest = @"com.sdl.request.SubscribeVehicleData";
SDLNotificationName const SDLDidReceiveSubscribeWayPointsRequest = @"com.sdl.request.SubscribeWayPoints";
SDLNotificationName const SDLDidReceiveSyncPDataRequest = @"com.sdl.request.SyncPData";
SDLNotificationName const SDLDidReceiveSystemRequestRequest = @"com.sdl.request.SystemRequest";
SDLNotificationName const SDLDidReceiveUnpublishAppServiceRequest = @"com.sdl.request.UnpublishAppService";
SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceRequest = @"com.sdl.request.UnregisterAppInterface";
SDLNotificationName const SDLDidReceiveUnsubscribeButtonRequest = @"com.sdl.request.UnsubscribeButton";
SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataRequest = @"com.sdl.request.UnsubscribeVehicleData";
SDLNotificationName const SDLDidReceiveUnsubscribeWayPointsRequest = @"com.sdl.request.UnsubscribeWayPoints";
SDLNotificationName const SDLDidReceiveUpdateTurnListRequest = @"com.sdl.request.UpdateTurnList";

#pragma mark - RPC Notifications
SDLNotificationName const SDLDidChangeDriverDistractionStateNotification = @"com.sdl.notification.OnDriverDistraction";
SDLNotificationName const SDLDidChangeHMIStatusNotification = @"com.sdl.notification.OnHMIStatus";
SDLNotificationName const SDLDidReceiveAppServiceDataNotification = @"com.sdl.notification.OnAppServiceData";
SDLNotificationName const SDLDidReceiveAppUnregisteredNotification = @"com.sdl.notification.OnAppInterfaceUnregistered";
SDLNotificationName const SDLDidReceiveAudioPassThruNotification = @"com.sdl.notification.OnAudioPassThru";
SDLNotificationName const SDLDidReceiveButtonEventNotification = @"com.sdl.notification.OnButtonEvent";
SDLNotificationName const SDLDidReceiveButtonPressNotification = @"com.sdl.notification.OnButtonPress";
SDLNotificationName const SDLDidReceiveCommandNotification = @"com.sdl.notification.OnCommand";
SDLNotificationName const SDLDidReceiveEncodedDataNotification = @"com.sdl.notification.OnEncodedSyncPData";
SDLNotificationName const SDLDidReceiveInteriorVehicleDataNotification = @"com.sdl.notification.OnInteriorVehicleData";
SDLNotificationName const SDLDidReceiveKeyboardInputNotification = @"com.sdl.notification.OnKeyboardInput";
SDLNotificationName const SDLDidChangeLanguageNotification = @"com.sdl.notification.OnLanguageChange";
SDLNotificationName const SDLDidReceiveNewHashNotification = @"com.sdl.notification.OnHashChange";
SDLNotificationName const SDLDidChangePermissionsNotification = @"com.sdl.notification.OnPermissionsChange";
SDLNotificationName const SDLDidReceiveRemoteControlStatusNotification = @"com.sdl.notification.OnRCStatus";
SDLNotificationName const SDLDidReceiveSyncPDataNotification = @"com.sdl.notification.OnSyncPData";
SDLNotificationName const SDLDidReceiveSystemCapabilityUpdatedNotification = @"com.sdl.notification.OnSystemCapabilityUpdated";
SDLNotificationName const SDLDidReceiveSystemRequestNotification = @"com.sdl.notification.OnSystemRequest";
SDLNotificationName const SDLDidChangeTurnByTurnStateNotification = @"com.sdl.notification.OnTBTClientState";
SDLNotificationName const SDLDidReceiveTouchEventNotification = @"com.sdl.notification.OnTouchEvent";
SDLNotificationName const SDLDidReceiveVehicleDataNotification = @"com.sdl.notification.OnVehicleData";
SDLNotificationName const SDLDidReceiveWaypointNotification = @"com.sdl.notification.OnWayPointChange";


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
             SDLDidReceiveSystemRequestResponse,
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
