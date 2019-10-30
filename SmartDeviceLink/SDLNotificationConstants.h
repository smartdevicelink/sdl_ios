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

typedef NOTIFICATION_TYPEDEF SDLNotificationName;

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

/**
 *  The key used in all SDL NSNotifications to extract the response or notification from the userinfo dictionary.
 */
#pragma mark - Notification info dictionary keys
extern SDLNotificationUserInfoKey const SDLNotificationUserInfoObject;

/**
 *  Some general NSNotification names not associated with any specific RPC response or request.
 */
#pragma mark - General notifications
extern SDLNotificationName const SDLTransportDidDisconnect;
extern SDLNotificationName const SDLTransportDidConnect;
extern SDLNotificationName const SDLTransportConnectError;
extern SDLNotificationName const SDLDidReceiveError;
extern SDLNotificationName const SDLDidReceiveLockScreenIcon;
extern SDLNotificationName const SDLDidBecomeReady;
extern SDLNotificationName const SDLDidUpdateProjectionView;

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

/// Name for an CancelInteraction response RPC
extern SDLNotificationName const SDLDidReceiveCancelInteractionResponse;

/// Name for an ChangeRegistration response RPC
extern SDLNotificationName const SDLDidReceiveChangeRegistrationResponse;

/// Name for an CloseApplication response RPC
extern SDLNotificationName const SDLDidReceiveCloseApplicationResponse;

/// Name for an CreateInteractionChoiceSet response RPC
extern SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetResponse;

/// Name for an CreateWindow response RPC
extern SDLNotificationName const SDLDidReceiveCreateWindowResponse;

/// Name for an DeleteCommand response RPC
extern SDLNotificationName const SDLDidReceiveDeleteCommandResponse;

/// Name for an DeleteFile response RPC
extern SDLNotificationName const SDLDidReceiveDeleteFileResponse;

/// Name for an DeleteInteractionChoiceSet response RPC
extern SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetResponse;

/// Name for an DeleteSubmenu response RPC
extern SDLNotificationName const SDLDidReceiveDeleteSubmenuResponse;

/// Name for an DeleteWindow response RPC
extern SDLNotificationName const SDLDidReceiveDeleteWindowResponse;

/// Name for an DiagnosticMessage response RPC
extern SDLNotificationName const SDLDidReceiveDiagnosticMessageResponse;

/// Name for an DialNumber response RPC
extern SDLNotificationName const SDLDidReceiveDialNumberResponse;

/// Name for an EncodedSyncPData response RPC
extern SDLNotificationName const SDLDidReceiveEncodedSyncPDataResponse;

/// Name for an EndAudioPassThru response RPC
extern SDLNotificationName const SDLDidReceiveEndAudioPassThruResponse;

/// Name for an Generic response RPC
extern SDLNotificationName const SDLDidReceiveGenericResponse;

/// Name for an GetCloudAppProperties response RPC
extern SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesResponse;

/// Name for an GetAppServiceData response RPC
extern SDLNotificationName const SDLDidReceiveGetAppServiceDataResponse;

/// Name for an GetDTCs response RPC
extern SDLNotificationName const SDLDidReceiveGetDTCsResponse;

/// Name for an GetFile response RPC
extern SDLNotificationName const SDLDidReceiveGetFileResponse;

/// Name for an GetInteriorVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataResponse;

/// Name for an GetInteriorVehicleDataConsent response RPC
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentResponse;

/// Name for an GetSystemCapabilities response RPC
extern SDLNotificationName const SDLDidReceiveGetSystemCapabilitiesResponse;

/// Name for an GetVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveGetVehicleDataResponse;

/// Name for an GetWaypoints response RPC
extern SDLNotificationName const SDLDidReceiveGetWaypointsResponse;

/// Name for an ListFiles response RPC
extern SDLNotificationName const SDLDidReceiveListFilesResponse;

/// Name for an PerformAppServiceInteraction response RPC
extern SDLNotificationName const SDLDidReceivePerformAppServiceInteractionResponse;

/// Name for an PerformAudioPassThru response RPC
extern SDLNotificationName const SDLDidReceivePerformAudioPassThruResponse;

/// Name for an PerformInteraction response RPC
extern SDLNotificationName const SDLDidReceivePerformInteractionResponse;

/// Name for an PublishAppService response RPC
extern SDLNotificationName const SDLDidReceivePublishAppServiceResponse;

/// Name for an ReceivePutFile response RPC
extern SDLNotificationName const SDLDidReceivePutFileResponse;

/// Name for an ReceiveReadDID response RPC
extern SDLNotificationName const SDLDidReceiveReadDIDResponse;

/// Name for an RegisterAppInterface response RPC
extern SDLNotificationName const SDLDidReceiveRegisterAppInterfaceResponse;

/// Name for an ReleaseInteriorVehicleDataModule response RPC
extern SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleResponse;

/// Name for an ResetGlobalProperties response RPC
extern SDLNotificationName const SDLDidReceiveResetGlobalPropertiesResponse;

/// Name for an ScrollableMessage response RPC
extern SDLNotificationName const SDLDidReceiveScrollableMessageResponse;

/// Name for an SendHapticData response RPC
extern SDLNotificationName const SDLDidReceiveSendHapticDataResponse;

/// Name for an SendLocation response RPC
extern SDLNotificationName const SDLDidReceiveSendLocationResponse;

/// Name for an SetAppIcon response RPC
extern SDLNotificationName const SDLDidReceiveSetAppIconResponse;

/// Name for an SetCloudAppProperties response RPC
extern SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesResponse;

/// Name for an SetDisplayLayout response RPC
extern SDLNotificationName const SDLDidReceiveSetDisplayLayoutResponse;

/// Name for an SetGlobalProperties response RPC
extern SDLNotificationName const SDLDidReceiveSetGlobalPropertiesResponse;

/// Name for an SetInteriorVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataResponse;

/// Name for an SetMediaClockTimer response RPC
extern SDLNotificationName const SDLDidReceiveSetMediaClockTimerResponse;

/// Name for an ShowConstantTBT response RPC
extern SDLNotificationName const SDLDidReceiveShowConstantTBTResponse;

/// Name for an Show response RPC
extern SDLNotificationName const SDLDidReceiveShowResponse;

/// Name for an ShowAppMenu response RPC
extern SDLNotificationName const SDLDidReceiveShowAppMenuResponse;

/// Name for an Slider response RPC
extern SDLNotificationName const SDLDidReceiveSliderResponse;

/// Name for an Speak response RPC
extern SDLNotificationName const SDLDidReceiveSpeakResponse;

/// Name for an Subscribe response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeButtonResponse;

/// Name for an SubscribeVehicleData response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeVehicleDataResponse;

/// Name for an SubscribeWaypoints response RPC
extern SDLNotificationName const SDLDidReceiveSubscribeWaypointsResponse;

/// Name for an SyncPData response RPC
extern SDLNotificationName const SDLDidReceiveSyncPDataResponse;

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
extern SDLNotificationName const SDLDidReceiveAddCommandRequest;
extern SDLNotificationName const SDLDidReceiveAddSubMenuRequest;
extern SDLNotificationName const SDLDidReceiveAlertRequest;
extern SDLNotificationName const SDLDidReceiveAlertManeuverRequest;
extern SDLNotificationName const SDLDidReceiveButtonPressRequest;
extern SDLNotificationName const SDLDidReceiveCancelInteractionRequest;
extern SDLNotificationName const SDLDidReceiveChangeRegistrationRequest;
extern SDLNotificationName const SDLDidReceiveCloseApplicationRequest;
extern SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetRequest;
extern SDLNotificationName const SDLDidReceiveCreateWindowRequest;
extern SDLNotificationName const SDLDidReceiveDeleteCommandRequest;
extern SDLNotificationName const SDLDidReceiveDeleteFileRequest;
extern SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetRequest;
extern SDLNotificationName const SDLDidReceiveDeleteSubMenuRequest;
extern SDLNotificationName const SDLDidReceiveDeleteWindowRequest;
extern SDLNotificationName const SDLDidReceiveDiagnosticMessageRequest;
extern SDLNotificationName const SDLDidReceiveDialNumberRequest;
extern SDLNotificationName const SDLDidReceiveEncodedSyncPDataRequest;
extern SDLNotificationName const SDLDidReceiveEndAudioPassThruRequest;
extern SDLNotificationName const SDLDidReceiveGetAppServiceDataRequest;
extern SDLNotificationName const SDLDidReceiveGetCloudAppPropertiesRequest;
extern SDLNotificationName const SDLDidReceiveGetDTCsRequest;
extern SDLNotificationName const SDLDidReceiveGetFileRequest;
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataRequest;
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataConsentRequest;
extern SDLNotificationName const SDLDidReceiveGetSystemCapabilityRequest;
extern SDLNotificationName const SDLDidReceiveGetVehicleDataRequest;
extern SDLNotificationName const SDLDidReceiveGetWayPointsRequest;
extern SDLNotificationName const SDLDidReceiveListFilesRequest;
extern SDLNotificationName const SDLDidReceivePerformAppServiceInteractionRequest;
extern SDLNotificationName const SDLDidReceivePerformAudioPassThruRequest;
extern SDLNotificationName const SDLDidReceivePerformInteractionRequest;
extern SDLNotificationName const SDLDidReceivePublishAppServiceRequest;
extern SDLNotificationName const SDLDidReceivePutFileRequest;
extern SDLNotificationName const SDLDidReceiveReadDIDRequest;
extern SDLNotificationName const SDLDidReceiveRegisterAppInterfaceRequest;
extern SDLNotificationName const SDLDidReceiveReleaseInteriorVehicleDataModuleRequest;
extern SDLNotificationName const SDLDidReceiveResetGlobalPropertiesRequest;
extern SDLNotificationName const SDLDidReceiveScrollableMessageRequest;
extern SDLNotificationName const SDLDidReceiveSendHapticDataRequest;
extern SDLNotificationName const SDLDidReceiveSendLocationRequest;
extern SDLNotificationName const SDLDidReceiveSetAppIconRequest;
extern SDLNotificationName const SDLDidReceiveSetCloudAppPropertiesRequest;
extern SDLNotificationName const SDLDidReceiveSetDisplayLayoutRequest;
extern SDLNotificationName const SDLDidReceiveSetGlobalPropertiesRequest;
extern SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataRequest;
extern SDLNotificationName const SDLDidReceiveSetMediaClockTimerRequest;
extern SDLNotificationName const SDLDidReceiveShowRequest;
extern SDLNotificationName const SDLDidReceiveShowAppMenuRequest;
extern SDLNotificationName const SDLDidReceiveShowConstantTBTRequest;
extern SDLNotificationName const SDLDidReceiveSliderRequest;
extern SDLNotificationName const SDLDidReceiveSpeakRequest;
extern SDLNotificationName const SDLDidReceiveSubscribeButtonRequest;
extern SDLNotificationName const SDLDidReceiveSubscribeVehicleDataRequest;
extern SDLNotificationName const SDLDidReceiveSubscribeWayPointsRequest;
extern SDLNotificationName const SDLDidReceiveSyncPDataRequest;
extern SDLNotificationName const SDLDidReceiveSystemRequestRequest;
extern SDLNotificationName const SDLDidReceiveUnpublishAppServiceRequest;
extern SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceRequest;
extern SDLNotificationName const SDLDidReceiveUnsubscribeButtonRequest;
extern SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataRequest;
extern SDLNotificationName const SDLDidReceiveUnsubscribeWayPointsRequest;
extern SDLNotificationName const SDLDidReceiveUpdateTurnListRequest;

/**
 *  NSNotification names associated with specific RPC notifications.
 */
#pragma mark - RPC Notifications
extern SDLNotificationName const SDLDidChangeDriverDistractionStateNotification;
extern SDLNotificationName const SDLDidChangeHMIStatusNotification;
extern SDLNotificationName const SDLDidReceiveAppServiceDataNotification;
extern SDLNotificationName const SDLDidReceiveAppUnregisteredNotification;
extern SDLNotificationName const SDLDidReceiveAudioPassThruNotification;
extern SDLNotificationName const SDLDidReceiveButtonEventNotification;
extern SDLNotificationName const SDLDidReceiveButtonPressNotification;
extern SDLNotificationName const SDLDidReceiveCommandNotification;
extern SDLNotificationName const SDLDidReceiveEncodedDataNotification;
extern SDLNotificationName const SDLDidReceiveInteriorVehicleDataNotification;
extern SDLNotificationName const SDLDidReceiveKeyboardInputNotification;
extern SDLNotificationName const SDLDidChangeLanguageNotification;
extern SDLNotificationName const SDLDidChangeLockScreenStatusNotification;
extern SDLNotificationName const SDLDidReceiveNewHashNotification;
extern SDLNotificationName const SDLDidReceiveVehicleIconNotification;
extern SDLNotificationName const SDLDidChangePermissionsNotification;
extern SDLNotificationName const SDLDidReceiveRemoteControlStatusNotification;
extern SDLNotificationName const SDLDidReceiveSystemCapabilityUpdatedNotification;
extern SDLNotificationName const SDLDidReceiveSystemRequestNotification;
extern SDLNotificationName const SDLDidChangeTurnByTurnStateNotification;
extern SDLNotificationName const SDLDidReceiveTouchEventNotification;
extern SDLNotificationName const SDLDidReceiveVehicleDataNotification;
extern SDLNotificationName const SDLDidReceiveWaypointNotification;

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
