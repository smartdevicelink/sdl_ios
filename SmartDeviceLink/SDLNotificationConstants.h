//
//  SDLNotificationConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Justin Dickow on 9/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLOnButtonEvent;
@class SDLOnButtonPress;
@class SDLOnCommand;
@class SDLRPCNotification;
@class SDLRPCResponse;
@class SDLRPCRequest;


NS_ASSUME_NONNULL_BEGIN

// Resolves issue of using Swift 3 and pre-iOS 10 versions due to NSNotificationName unavailability.
#if __IPHONE_OS_VERSION_MAX_ALLOWED <= __IPHONE_9_3
#define NOTIFICATION_TYPEDEF NSString *
#else
#define NOTIFICATION_TYPEDEF NSNotificationName
#endif

/// NSNotification names specific to incoming SDL RPC
typedef NOTIFICATION_TYPEDEF SDLNotificationName;

/// The key used in all SDL NSNotifications to extract the response or notification from the userInfo dictionary.
typedef NSString *SDLNotificationUserInfoKey;

#pragma mark - Blocks

/**
 *  A handler used on SDLPerformAudioPassThru.
 *
 *  @param audioData The audio data contained in the notification.
 */
typedef void (^SDLAudioPassThruHandler)(NSData *__nullable audioData);

/**
 *  A handler used on all RPC requests which fires when the response is received.
 *
 *  @param request  The request which was sent.
 *  @param response The response which was received.
 *  @param error    If sending the request encountered an error, this parameter will not be nil.
 */
typedef void (^SDLResponseHandler)(__kindof SDLRPCRequest *__nullable request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error);

/**
 A completion handler called after a sequential or simultaneous set of requests have completed sending.

 @param success True if every request succeeded, false if any failed. See the progress handler for more details on failures.
 */
typedef void (^SDLMultipleRequestCompletionHandler)(BOOL success);

/**
 A handler called after each response to a request comes in in a multiple request send.

 @param request The request that received a response
 @param response The response received
 @param error The error that occurred during the request if any occurred.
 @param percentComplete The percentage of requests that have received a response
 @return continueSendingRequests NO to cancel any requests that have not yet been sent. This is really only useful for a sequential send (sendSequentialRequests:progressHandler:completionHandler:). Return YES to continue sending requests.
 */
typedef BOOL (^SDLMultipleSequentialRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);

/**
 A handler called after each response to a request comes in in a multiple request send.

 @param request The request that received a response
 @param response The response received
 @param error The error that occurred during the request if any occurred.
 @param percentComplete The percentage of requests that have received a response
 */
typedef void (^SDLMultipleAsyncRequestProgressHandler)(__kindof SDLRPCRequest *request, __kindof SDLRPCResponse *__nullable response, NSError *__nullable error, float percentComplete);

/**
 A handler that may optionally be run when an SDLSubscribeButton or SDLSoftButton has a corresponding notification occur.
 
 @warning This only works if you send the RPC using SDLManager.
 @warning Only one of the two parameters will be set for each block call.
 
 @param buttonPress An SDLOnButtonPress object that corresponds to this particular button.
 @param buttonEvent An SDLOnButtonEvent object that corresponds to this particular button.
 */
typedef void (^SDLRPCButtonNotificationHandler)(SDLOnButtonPress *_Nullable buttonPress,  SDLOnButtonEvent *_Nullable buttonEvent);
/**
 A handler that may optionally be run when an SDLAddCommand has a corresponding notification occur.
 
 @warning This only works if you send the RPC using SDLManager.
 
 @param command An SDLOnCommand object that corresponds to this particular SDLAddCommand.
 */
typedef void (^SDLRPCCommandNotificationHandler)(SDLOnCommand *command);


#pragma mark - Notification info dictionary keys

/**
*  The key used in all SDL NSNotifications to extract the response or notification from the userinfo dictionary.
*/
extern SDLNotificationUserInfoKey const SDLNotificationUserInfoObject;

/**
 *  Some general NSNotification names not associated with any specific RPC response or request.
 */
#pragma mark - General notifications

/// Name for a disconnection notification
extern SDLNotificationName const SDLTransportDidDisconnect;

/// Name for a connection notification
extern SDLNotificationName const SDLTransportDidConnect;

/// Name for a error during connection notification
extern SDLNotificationName const SDLTransportConnectError;

/// Name for a disconnection notification
extern SDLNotificationName const SDLRPCServiceDidDisconnect;

/// Name for a connection notification
extern SDLNotificationName const SDLRPCServiceDidConnect;

/// Name for a error during connection notification
extern SDLNotificationName const SDLRPCServiceConnectionDidError;

/// Name for a general error notification
extern SDLNotificationName const SDLDidReceiveError;

/// Name for an incoming lock screen icon notification
extern SDLNotificationName const SDLDidReceiveLockScreenIcon;

/// Name for an SDL became ready notification
extern SDLNotificationName const SDLDidBecomeReady;

/// Name for a notification sent by the user when their CarWindow view has been updated
extern SDLNotificationName const SDLDidUpdateProjectionView;

/// Name for a LockScreenStatus notification RPC
extern SDLNotificationName const SDLDidChangeLockScreenStatusNotification __deprecated_msg("This will be replaced in a future version where a fake RPC is not sent");

/**
 *  NSNotification names associated with specific RPC responses.
 */
#pragma mark - RPC responses

/// Name for an AddCommand response RPC
extern SDLNotificationName const SDLDidReceiveAddCommandResponse;

/// Name for an AddSubMenu response RPC
extern SDLNotificationName const SDLDidReceiveAddSubMenuResponse;

/// Name for an Alert response RPC
extern SDLNotificationName const SDLDidReceiveAlertResponse;

/// Name for an AlertManeuver response RPC
extern SDLNotificationName const SDLDidReceiveAlertManeuverResponse;

/// Name for an ButtonPress response RPC
extern SDLNotificationName const SDLDidReceiveButtonPressResponse;

/// Name for aa CancelInteraction response RPC
extern SDLNotificationName const SDLDidReceiveCancelInteractionResponse;

/// Name for a ChangeRegistration response RPC
extern SDLNotificationName const SDLDidReceiveChangeRegistrationResponse;

/// Name for a CloseApplication response RPC
extern SDLNotificationName const SDLDidReceiveCloseApplicationResponse;

/// Name for a CreateInteractionChoiceSet response RPC
extern SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetResponse;

/// Name for a CreateWindow response RPC
extern SDLNotificationName const SDLDidReceiveCreateWindowResponse;

/// Name for a DeleteCommand response RPC
extern SDLNotificationName const SDLDidReceiveDeleteCommandResponse;

/// Name for a DeleteFile response RPC
extern SDLNotificationName const SDLDidReceiveDeleteFileResponse;

/// Name for a DeleteInteractionChoiceSet response RPC
extern SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetResponse;

/// Name for a DeleteSubmenu response RPC
extern SDLNotificationName const SDLDidReceiveDeleteSubmenuResponse;

/// Name for a DeleteWindow response RPC
extern SDLNotificationName const SDLDidReceiveDeleteWindowResponse;

/// Name for a DiagnosticMessage response RPC
extern SDLNotificationName const SDLDidReceiveDiagnosticMessageResponse;

/// Name for a DialNumber response RPC
extern SDLNotificationName const SDLDidReceiveDialNumberResponse;

/// Name for an EncodedSyncPData response RPC
extern SDLNotificationName const SDLDidReceiveEncodedSyncPDataResponse __deprecated;

/// Name for an EndAudioPassThru response RPC
extern SDLNotificationName const SDLDidReceiveEndAudioPassThruResponse;

/// Name for a Generic response RPC
extern SDLNotificationName const SDLDidReceiveGenericResponse;

/// Name for a GetCloudAppProperties response RPC
extern SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesResponse;

/// Name for a GetAppServiceData response RPC
extern SDLNotificationName const SDLDidReceiveGetAppServiceDataResponse;

/// Name for a GetDTCs response RPC
extern SDLNotificationName const SDLDidReceiveGetDTCsResponse;

/// Name for a GetFile response RPC
extern SDLNotificationName const SDLDidReceiveGetFileResponse;

/// Name for a GetInteriorVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataResponse;

/// Name for a GetInteriorVehicleDataConsent response RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentResponse;

/// Name for a GetSystemCapabilities response RPC
extern SDLNotificationName const SDLDidReceiveGetSystemCapabilitiesResponse;

/// Name for a GetVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveGetVehicleDataResponse;

/// Name for a GetWaypoints response RPC
extern SDLNotificationName const SDLDidReceiveGetWaypointsResponse;

/// Name for a ListFiles response RPC
extern SDLNotificationName const SDLDidReceiveListFilesResponse;

/// Name for a PerformAppServiceInteraction response RPC
extern SDLNotificationName const SDLDidReceivePerformAppServiceInteractionResponse;

/// Name for a PerformAudioPassThru response RPC
extern SDLNotificationName const SDLDidReceivePerformAudioPassThruResponse;

/// Name for a PerformInteraction response RPC
extern SDLNotificationName const SDLDidReceivePerformInteractionResponse;

/// Name for a PublishAppService response RPC
extern SDLNotificationName const SDLDidReceivePublishAppServiceResponse;

/// Name for a ReceivePutFile response RPC
extern SDLNotificationName const SDLDidReceivePutFileResponse;

/// Name for a ReceiveReadDID response RPC
extern SDLNotificationName const SDLDidReceiveReadDIDResponse;

/// Name for a RegisterAppInterface response RPC
extern SDLNotificationName const SDLDidReceiveRegisterAppInterfaceResponse;

/// Name for a ReleaseInteriorVehicleDataModule response RPC
extern SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleResponse;

/// Name for a ResetGlobalProperties response RPC
extern SDLNotificationName const SDLDidReceiveResetGlobalPropertiesResponse;

/// Name for a ScrollableMessage response RPC
extern SDLNotificationName const SDLDidReceiveScrollableMessageResponse;

/// Name for a SendHapticData response RPC
extern SDLNotificationName const SDLDidReceiveSendHapticDataResponse;

/// Name for a SendLocation response RPC
extern SDLNotificationName const SDLDidReceiveSendLocationResponse;

/// Name for a SetAppIcon response RPC
extern SDLNotificationName const SDLDidReceiveSetAppIconResponse;

/// Name for a SetCloudAppProperties response RPC
extern SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesResponse;

/// Name for a SetDisplayLayout response RPC
extern SDLNotificationName const SDLDidReceiveSetDisplayLayoutResponse;

/// Name for a SetGlobalProperties response RPC
extern SDLNotificationName const SDLDidReceiveSetGlobalPropertiesResponse;

/// Name for a SetInteriorVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataResponse;

/// Name for a SetMediaClockTimer response RPC
extern SDLNotificationName const SDLDidReceiveSetMediaClockTimerResponse;

/// Name for a ShowConstantTBT response RPC
extern SDLNotificationName const SDLDidReceiveShowConstantTBTResponse;

/// Name for a Show response RPC
extern SDLNotificationName const SDLDidReceiveShowResponse;

/// Name for a ShowAppMenu response RPC
extern SDLNotificationName const SDLDidReceiveShowAppMenuResponse;

/// Name for a Slider response RPC
extern SDLNotificationName const SDLDidReceiveSliderResponse;

/// Name for a Speak response RPC
extern SDLNotificationName const SDLDidReceiveSpeakResponse;

/// Name for a SubscribeButton response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeButtonResponse;

/// Name for a SubscribeVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeVehicleDataResponse;

/// Name for a SubscribeWaypoints response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeWaypointsResponse;

/// Name for a SyncPData response RPC
extern SDLNotificationName const SDLDidReceiveSyncPDataResponse __deprecated;

/// Name for a SystemRequest response RPC
extern SDLNotificationName const SDLDidReceiveSystemRequestResponse;

/// Name for an UpdateTurnList response RPC
extern SDLNotificationName const SDLDidReceiveUpdateTurnListResponse;

/// Name for an UnpublishAppService response RPC
extern SDLNotificationName const SDLDidReceiveUnpublishAppServiceResponse;

/// Name for an UnregisterAppInterface response RPC
extern SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceResponse;

/// Name for an UnsubscribeButton response RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeButtonResponse;

/// Name for an UnsubscribeVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataResponse;

/// Name for an UnsubscribeWaypoints response RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeWaypointsResponse;

/**
 *  NSNotification names associated with specific RPC requests.
 */
#pragma mark - RPC requests

/// Name for an AddCommand request RPC
extern SDLNotificationName const SDLDidReceiveAddCommandRequest;

/// Name for an AddSubMenu request RPC
extern SDLNotificationName const SDLDidReceiveAddSubMenuRequest;

/// Name for an Alert request RPC
extern SDLNotificationName const SDLDidReceiveAlertRequest;

/// Name for an AlertManeuver request RPC
extern SDLNotificationName const SDLDidReceiveAlertManeuverRequest;

/// Name for a ButtonPress request RPC
extern SDLNotificationName const SDLDidReceiveButtonPressRequest;

/// Name for a CancelInteraction request RPC
extern SDLNotificationName const SDLDidReceiveCancelInteractionRequest;

/// Name for a ChangeRegistration request RPC
extern SDLNotificationName const SDLDidReceiveChangeRegistrationRequest;

/// Name for a CloseApplication request RPC
extern SDLNotificationName const SDLDidReceiveCloseApplicationRequest;

/// Name for a CreateInteractionChoiceSet request RPC
extern SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetRequest;

/// Name for a CreateWindow request RPC
extern SDLNotificationName const SDLDidReceiveCreateWindowRequest;

/// Name for a DeleteCommand request RPC
extern SDLNotificationName const SDLDidReceiveDeleteCommandRequest;

/// Name for a DeleteFile request RPC
extern SDLNotificationName const SDLDidReceiveDeleteFileRequest;

/// Name for a DeleteInteractionChoiceSet request RPC
extern SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetRequest;

/// Name for a DeleteSubMenu request RPC
extern SDLNotificationName const SDLDidReceiveDeleteSubMenuRequest;

/// Name for a DeleteSubMenu request RPC
extern SDLNotificationName const SDLDidReceiveDeleteWindowRequest;

/// Name for a DiagnosticMessage request RPC
extern SDLNotificationName const SDLDidReceiveDiagnosticMessageRequest;

/// Name for a DialNumberR request RPC
extern SDLNotificationName const SDLDidReceiveDialNumberRequest;

/// Name for an EncodedSyncPData request RPC
extern SDLNotificationName const SDLDidReceiveEncodedSyncPDataRequest __deprecated;

/// Name for a EndAudioPass request RPC
extern SDLNotificationName const SDLDidReceiveEndAudioPassThruRequest;

/// Name for a GetAppServiceData request RPC
extern SDLNotificationName const SDLDidReceiveGetAppServiceDataRequest;

/// Name for a GetCloudAppProperties request RPC
extern SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesRequest;

/// Name for a ReceiveGetDTCs request RPC
extern SDLNotificationName const SDLDidReceiveGetDTCsRequest;

/// Name for a GetFile request RPC
extern SDLNotificationName const SDLDidReceiveGetFileRequest;

/// Name for a GetInteriorVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataRequest;

/// Name for a GetInteriorVehicleDataConsent request RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentRequest;

/// Name for a GetSystemCapability request RPC
extern SDLNotificationName const SDLDidReceiveGetSystemCapabilityRequest;

/// Name for a GetVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveGetVehicleDataRequest;

/// Name for a GetWayPoints request RPC
extern SDLNotificationName const SDLDidReceiveGetWayPointsRequest;

/// Name for a ListFiles request RPC
extern SDLNotificationName const SDLDidReceiveListFilesRequest;

/// Name for a PerformAppServiceInteraction request RPC
extern SDLNotificationName const SDLDidReceivePerformAppServiceInteractionRequest;

/// Name for a PerformAudioPassThru request RPC
extern SDLNotificationName const SDLDidReceivePerformAudioPassThruRequest;

/// Name for a PerformInteraction request RPC
extern SDLNotificationName const SDLDidReceivePerformInteractionRequest;

/// Name for a PublishAppService request RPC
extern SDLNotificationName const SDLDidReceivePublishAppServiceRequest;

/// Name for a PutFile request RPC
extern SDLNotificationName const SDLDidReceivePutFileRequest;

/// Name for a ReadDID request RPC
extern SDLNotificationName const SDLDidReceiveReadDIDRequest;

/// Name for a RegisterAppInterfacr request RPC
extern SDLNotificationName const SDLDidReceiveRegisterAppInterfaceRequest;

/// Name for a ReleaseInteriorVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleRequest;

/// Name for a ResetGlobalProperties request RPC
extern SDLNotificationName const SDLDidReceiveResetGlobalPropertiesRequest;

/// Name for a ScrollableMessage request RPC
extern SDLNotificationName const SDLDidReceiveScrollableMessageRequest;

/// Name for a SendHapticData request RPC
extern SDLNotificationName const SDLDidReceiveSendHapticDataRequest;

/// Name for a SendLocation request RPC
extern SDLNotificationName const SDLDidReceiveSendLocationRequest;

/// Name for a SetAppIcon request RPC
extern SDLNotificationName const SDLDidReceiveSetAppIconRequest;

/// Name for a SetCloudProperties request RPC
extern SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesRequest;

/// Name for a SetDisplayLayout request RPC
extern SDLNotificationName const SDLDidReceiveSetDisplayLayoutRequest;

/// Name for a SetGlobalProperties request RPC
extern SDLNotificationName const SDLDidReceiveSetGlobalPropertiesRequest;

/// Name for a SetInteriorVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataRequest;

/// Name for a SetMediaClockTimer request RPC
extern SDLNotificationName const SDLDidReceiveSetMediaClockTimerRequest;

/// Name for a Show request RPC
extern SDLNotificationName const SDLDidReceiveShowRequest;

/// Name for a ShowAppMenu request RPC
extern SDLNotificationName const SDLDidReceiveShowAppMenuRequest;

/// Name for a ShowConstantTBT request RPC
extern SDLNotificationName const SDLDidReceiveShowConstantTBTRequest;

/// Name for a Slider request RPC
extern SDLNotificationName const SDLDidReceiveSliderRequest;

/// Name for a Speak request RPC
extern SDLNotificationName const SDLDidReceiveSpeakRequest;

/// Name for a SubscribeButton request RPC
extern SDLNotificationName const SDLDidReceiveSubscribeButtonRequest;

/// Name for a SubscribeVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveSubscribeVehicleDataRequest;

/// Name for a ubscribeWayPoints request RPC
extern SDLNotificationName const SDLDidReceiveSubscribeWayPointsRequest;

/// Name for a SyncPData request RPC
extern SDLNotificationName const SDLDidReceiveSyncPDataRequest __deprecated;

/// Name for a SystemRequest request RPC
extern SDLNotificationName const SDLDidReceiveSystemRequestRequest;

/// Name for an UnpublishAppService request RPC
extern SDLNotificationName const SDLDidReceiveUnpublishAppServiceRequest;

/// Name for an UnregisterAppInterface request RPC
extern SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceRequest;

/// Name for an UnsubscribeButton request RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeButtonRequest;

/// Name for an UnsubscribeVehicleData request RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataRequest;

/// Name for an UnsubscribeWayPoints request RPC
extern SDLNotificationName const SDLDidReceiveUnsubscribeWayPointsRequest;

/// Name for an UpdateTurnList request RPC
extern SDLNotificationName const SDLDidReceiveUpdateTurnListRequest;

/**
 *  NSNotification names associated with specific RPC notifications.
 */
#pragma mark - RPC Notifications

/// Name for a DriverDistractionState notification RPC
extern SDLNotificationName const SDLDidChangeDriverDistractionStateNotification;

/// Name for a HMIStatus notification RPC
extern SDLNotificationName const SDLDidChangeHMIStatusNotification;

/// Name for an AppServiceData notification RPC
extern SDLNotificationName const SDLDidReceiveAppServiceDataNotification;

/// Name for an AppUnregistered notification RPC
extern SDLNotificationName const SDLDidReceiveAppUnregisteredNotification;

/// Name for an AudioPassThru notification RPC
extern SDLNotificationName const SDLDidReceiveAudioPassThruNotification;

/// Name for a ButtonEvent notification RPC
extern SDLNotificationName const SDLDidReceiveButtonEventNotification;

/// Name for a ButtonPress notification RPC
extern SDLNotificationName const SDLDidReceiveButtonPressNotification;

/// Name for a Command notification RPC
extern SDLNotificationName const SDLDidReceiveCommandNotification;

/// Name for a EncodedSyncPData notification RPC
extern SDLNotificationName const SDLDidReceiveEncodedDataNotification __deprecated;

/// Name for a InteriorVehicleData notification RPC
extern SDLNotificationName const SDLDidReceiveInteriorVehicleDataNotification;

/// Name for a KeyboardInput notification RPC
extern SDLNotificationName const SDLDidReceiveKeyboardInputNotification;

/// Name for a Language notification RPC
extern SDLNotificationName const SDLDidChangeLanguageNotification;

/// Name for a NewHash notification RPC
extern SDLNotificationName const SDLDidReceiveNewHashNotification;

/// Name for a VehicleIcon notification RPC
extern SDLNotificationName const SDLDidReceiveVehicleIconNotification;

/// Name for a ChangePermissions notification RPC
extern SDLNotificationName const SDLDidChangePermissionsNotification;

/// Name for a RemoteControlStatus notification RPC
extern SDLNotificationName const SDLDidReceiveRemoteControlStatusNotification;

/// Name for an OnSyncPData notification RPC
extern SDLNotificationName const SDLDidReceiveSyncPDataNotification __deprecated;

/// Name for a SystemCapability notification RPC
extern SDLNotificationName const SDLDidReceiveSystemCapabilityUpdatedNotification;

/// Name for a SystemRequest notification RPC
extern SDLNotificationName const SDLDidReceiveSystemRequestNotification;

/// Name for a TurnByTurnStat notification RPC
extern SDLNotificationName const SDLDidChangeTurnByTurnStateNotification;

/// Name for a TouchEvent notification RPC
extern SDLNotificationName const SDLDidReceiveTouchEventNotification;

/// Name for a VehicleData notification RPC
extern SDLNotificationName const SDLDidReceiveVehicleDataNotification;

/// Name for a Waypoint notification RPC
extern SDLNotificationName const SDLDidReceiveWaypointNotification;

/// This class defines methods for getting groups of notifications
@interface SDLNotificationConstants : NSObject

/**
 All of the possible SDL RPC Response notification names

 @return All response notification names
 */
+ (NSArray<SDLNotificationName> *)allResponseNames;

/**
 All of the possible SDL Button event notification names

 @return The names
 */
+ (NSArray<SDLNotificationName> *)allButtonEventNotifications;

@end

NS_ASSUME_NONNULL_END
