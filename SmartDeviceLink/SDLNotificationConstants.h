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
extern SDLNotificationName const SDLDidReceiveError;
extern SDLNotificationName const SDLDidReceiveLockScreenIcon;
extern SDLNotificationName const SDLDidBecomeReady;
extern SDLNotificationName const SDLDidUpdateProjectionView;

/**
 *  NSNotification names associated with specific RPC responses.
 */
#pragma mark - RPC responses
extern SDLNotificationName const SDLDidReceiveAddCommandResponse;
extern SDLNotificationName const SDLDidReceiveAddSubMenuResponse;
extern SDLNotificationName const SDLDidReceiveAlertResponse;
extern SDLNotificationName const SDLDidReceiveAlertManeuverResponse;
extern SDLNotificationName const SDLDidReceiveButtonPressResponse;
extern SDLNotificationName const SDLDidReceiveChangeRegistrationResponse;
extern SDLNotificationName const SDLDidReceiveCreateInteractionChoiceSetResponse;
extern SDLNotificationName const SDLDidReceiveDeleteCommandResponse;
extern SDLNotificationName const SDLDidReceiveDeleteFileResponse;
extern SDLNotificationName const SDLDidReceiveDeleteInteractionChoiceSetResponse;
extern SDLNotificationName const SDLDidReceiveDeleteSubmenuResponse;
extern SDLNotificationName const SDLDidReceiveDiagnosticMessageResponse;
extern SDLNotificationName const SDLDidReceiveDialNumberResponse;
extern SDLNotificationName const SDLDidReceiveEncodedSyncPDataResponse;
extern SDLNotificationName const SDLDidReceiveEndAudioPassThruResponse;
extern SDLNotificationName const SDLDidReceiveGenericResponse;
extern SDLNotificationName const SDLDidReceiveGetDTCsResponse;
extern SDLNotificationName const SDLDidReceiveGetInteriorVehicleDataResponse;
extern SDLNotificationName const SDLDidReceiveGetSystemCapabilitiesResponse;
extern SDLNotificationName const SDLDidReceiveGetVehicleDataResponse;
extern SDLNotificationName const SDLDidReceiveGetWaypointsResponse;
extern SDLNotificationName const SDLDidReceiveListFilesResponse;
extern SDLNotificationName const SDLDidReceivePerformAudioPassThruResponse;
extern SDLNotificationName const SDLDidReceivePerformInteractionResponse;
extern SDLNotificationName const SDLDidReceivePutFileResponse;
extern SDLNotificationName const SDLDidReceiveReadDIDResponse;
extern SDLNotificationName const SDLDidReceiveRegisterAppInterfaceResponse;
extern SDLNotificationName const SDLDidReceiveResetGlobalPropertiesResponse;
extern SDLNotificationName const SDLDidReceiveScrollableMessageResponse;
extern SDLNotificationName const SDLDidReceiveSendHapticDataResponse;
extern SDLNotificationName const SDLDidReceiveSendLocationResponse;
extern SDLNotificationName const SDLDidReceiveSetAppIconResponse;
extern SDLNotificationName const SDLDidReceiveSetDisplayLayoutResponse;
extern SDLNotificationName const SDLDidReceiveSetGlobalPropertiesResponse;
extern SDLNotificationName const SDLDidReceiveSetInteriorVehicleDataResponse;
extern SDLNotificationName const SDLDidReceiveSetMediaClockTimerResponse;
extern SDLNotificationName const SDLDidReceiveShowConstantTBTResponse;
extern SDLNotificationName const SDLDidReceiveShowResponse;
extern SDLNotificationName const SDLDidReceiveSliderResponse;
extern SDLNotificationName const SDLDidReceiveSpeakResponse;
extern SDLNotificationName const SDLDidReceiveSubscribeButtonResponse;
extern SDLNotificationName const SDLDidReceiveSubscribeVehicleDataResponse;
extern SDLNotificationName const SDLDidReceiveSubscribeWaypointsResponse;
extern SDLNotificationName const SDLDidReceiveSyncPDataResponse;
extern SDLNotificationName const SDLDidReceiveUpdateTurnListResponse;
extern SDLNotificationName const SDLDidReceiveUnregisterAppInterfaceResponse;
extern SDLNotificationName const SDLDidReceiveUnsubscribeButtonResponse;
extern SDLNotificationName const SDLDidReceiveUnsubscribeVehicleDataResponse;
extern SDLNotificationName const SDLDidReceiveUnsubscribeWaypointsResponse;

/**
 *  NSNotification names associated with specific RPC notifications.
 */
#pragma mark - RPC Notifications
extern SDLNotificationName const SDLDidChangeDriverDistractionStateNotification;
extern SDLNotificationName const SDLDidChangeHMIStatusNotification;
extern SDLNotificationName const SDLDidReceiveAudioPassThruNotification;
extern SDLNotificationName const SDLDidReceiveAppUnregisteredNotification;
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
extern SDLNotificationName const SDLDidReceiveSystemRequestNotification;
extern SDLNotificationName const SDLDidChangeTurnByTurnStateNotification;
extern SDLNotificationName const SDLDidReceiveTouchEventNotification;
extern SDLNotificationName const SDLDidReceiveVehicleDataNotification;
extern SDLNotificationName const SDLDidReceiveWaypointNotification;

@interface SDLNotificationConstants : NSObject

/**
 All of the possible SDL RPC Response notification names

 @return The names
 */
+ (NSArray<SDLNotificationName> *)allResponseNames;

/**
 All of the possible SDL Button event notification names

 @return The names
 */
+ (NSArray<SDLNotificationName> *)allButtonEventNotifications;

@end

NS_ASSUME_NONNULL_END
