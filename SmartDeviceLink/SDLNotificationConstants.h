//
//  SDLNotificationConstants.h
//  SmartDeviceLink-iOS
//
//  Created by Justin Dickow on 9/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SDLRPCNotification;
@class SDLRPCResponse;
@class SDLRPCRequest;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - Blocks
typedef void (^SDLRPCNotificationHandler) (__kindof SDLRPCNotification *notification);
typedef void (^SDLRequestCompletionHandler) (__kindof SDLRPCRequest * __nullable request,  __kindof SDLRPCResponse * __nullable response, NSError * __nullable error);

#pragma mark - Notification info dictionary keys
extern NSString *const SDLNotificationUserInfoObject; // TODO: Rename to be more specific? Multiple types (e.g. response, notification?)

#pragma mark - General notifications
extern NSString *const SDLTransportDidDisconnect;
extern NSString *const SDLTransportDidConnect;
extern NSString *const SDLDidReceiveError;
extern NSString *const SDLDidReceiveLockScreenIcon;
extern NSString *const SDLDidBecomeReady;

#pragma mark - RPC responses
extern NSString *const SDLDidReceiveAddCommandResponse;
extern NSString *const SDLDidReceiveAddSubMenuResponse;
extern NSString *const SDLDidReceiveAlertResponse;
extern NSString *const SDLDidReceiveAlertManeuverResponse;
extern NSString *const SDLDidReceiveChangeRegistrationResponse;
extern NSString *const SDLDidReceiveCreateInteractionChoiceSetResponse;
extern NSString *const SDLDidReceiveDeleteCommandResponse;
extern NSString *const SDLDidReceiveDeleteFileResponse;
extern NSString *const SDLDidReceiveDeleteInteractionChoiceSetResponse;
extern NSString *const SDLDidReceiveDeleteSubmenuResponse;
extern NSString *const SDLDidReceiveDiagnosticMessageResponse;
extern NSString *const SDLDidReceiveDialNumberResponse;
extern NSString *const SDLDidReceiveEncodedSyncPDataResponse;
extern NSString *const SDLDidReceiveEndAudioPassThruResponse;
extern NSString *const SDLDidReceiveGenericResponse;
extern NSString *const SDLDidReceiveGetDTCsResponse;
extern NSString *const SDLDidReceiveGetVehicleDataResponse;
extern NSString *const SDLDidReceiveListFilesResponse;
extern NSString *const SDLDidReceivePerformAudioPassThruResponse;
extern NSString *const SDLDidReceivePerformInteractionResponse;
extern NSString *const SDLDidReceivePutFileResponse;
extern NSString *const SDLDidReceiveReadDIDResponse;
extern NSString *const SDLDidReceiveRegisterAppInterfaceResponse;
extern NSString *const SDLDidReceiveResetGlobalPropertiesResponse;
extern NSString *const SDLDidReceiveScrollableMessageResponse;
extern NSString *const SDLDidReceiveSendLocationResponse;
extern NSString *const SDLDidReceiveSetAppIconResponse;
extern NSString *const SDLDidReceiveSetDisplayLayoutResponse;
extern NSString *const SDLDidReceiveSetGlobalPropertiesResponse;
extern NSString *const SDLDidReceiveSetMediaClockTimerResponse;
extern NSString *const SDLDidReceiveShowConstantTBTResponse;
extern NSString *const SDLDidReceiveShowResponse;
extern NSString *const SDLDidReceiveSliderResponse;
extern NSString *const SDLDidReceiveSpeakResponse;
extern NSString *const SDLDidReceiveSubscribeButtonResponse;
extern NSString *const SDLDidReceiveSubscribeVehicleDataResponse;
extern NSString *const SDLDidReceiveSyncPDataResponse;
extern NSString *const SDLDidReceiveUpdateTurnListResponse;
extern NSString *const SDLDidReceiveUnregisterAppInterfaceResponse;
extern NSString *const SDLDidReceiveUnsubscribeButtonResponse;
extern NSString *const SDLDidReceiveUnsubscribeVehicleDataResponse;

#pragma mark - RPC Notifications
extern NSString *const SDLDidChangeDriverDistractionStateNotification;
extern NSString *const SDLDidChangeHMIStatusNotification;
extern NSString *const SDLDidReceiveAudioPassThruNotification;
extern NSString *const SDLDidReceiveAppUnregisteredNotification;
extern NSString *const SDLDidReceiveButtonEventNotification;
extern NSString *const SDLDidReceiveButtonPressNotification;
extern NSString *const SDLDidReceiveCommandNotification;
extern NSString *const SDLDidReceiveEncodedDataNotification;
extern NSString *const SDLDidReceiveNewHashNotification;
extern NSString *const SDLDidChangeLanguageNotification;
extern NSString *const SDLDidChangeLockScreenStatusNotification;
extern NSString *const SDLDidReceiveVehicleIconNotification;
extern NSString *const SDLDidChangePermissionsNotification;
extern NSString *const SDLDidReceiveSystemRequestNotification;
extern NSString *const SDLDidChangeTurnByTurnStateNotification;
extern NSString *const SDLDidReceiveTouchEventNotification;
extern NSString *const SDLDidReceiveVehicleDataNotification;

NS_ASSUME_NONNULL_END
