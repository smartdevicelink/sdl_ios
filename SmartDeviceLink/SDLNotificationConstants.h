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

typedef NSString SDLNotificationName;
typedef NSString SDLNotificationUserInfoKey;

#pragma mark - Blocks
typedef void (^SDLRPCNotificationHandler) (__kindof SDLRPCNotification *notification);
typedef void (^SDLRequestCompletionHandler) (__kindof SDLRPCRequest * __nullable request,  __kindof SDLRPCResponse * __nullable response, NSError * __nullable error);

#pragma mark - Notification info dictionary keys
extern SDLNotificationUserInfoKey *const SDLNotificationUserInfoObject;

#pragma mark - General notifications
extern SDLNotificationName *const SDLTransportDidDisconnect;
extern SDLNotificationName *const SDLTransportDidConnect;
extern SDLNotificationName *const SDLDidReceiveError;
extern SDLNotificationName *const SDLDidReceiveLockScreenIcon;
extern SDLNotificationName *const SDLDidBecomeReady;

#pragma mark - RPC responses
extern SDLNotificationName *const SDLDidReceiveAddCommandResponse;
extern SDLNotificationName *const SDLDidReceiveAddSubMenuResponse;
extern SDLNotificationName *const SDLDidReceiveAlertResponse;
extern SDLNotificationName *const SDLDidReceiveAlertManeuverResponse;
extern SDLNotificationName *const SDLDidReceiveChangeRegistrationResponse;
extern SDLNotificationName *const SDLDidReceiveCreateInteractionChoiceSetResponse;
extern SDLNotificationName *const SDLDidReceiveDeleteCommandResponse;
extern SDLNotificationName *const SDLDidReceiveDeleteFileResponse;
extern SDLNotificationName *const SDLDidReceiveDeleteInteractionChoiceSetResponse;
extern SDLNotificationName *const SDLDidReceiveDeleteSubmenuResponse;
extern SDLNotificationName *const SDLDidReceiveDiagnosticMessageResponse;
extern SDLNotificationName *const SDLDidReceiveDialNumberResponse;
extern SDLNotificationName *const SDLDidReceiveEncodedSyncPDataResponse;
extern SDLNotificationName *const SDLDidReceiveEndAudioPassThruResponse;
extern SDLNotificationName *const SDLDidReceiveGenericResponse;
extern SDLNotificationName *const SDLDidReceiveGetDTCsResponse;
extern SDLNotificationName *const SDLDidReceiveGetVehicleDataResponse;
extern SDLNotificationName *const SDLDidReceiveListFilesResponse;
extern SDLNotificationName *const SDLDidReceivePerformAudioPassThruResponse;
extern SDLNotificationName *const SDLDidReceivePerformInteractionResponse;
extern SDLNotificationName *const SDLDidReceivePutFileResponse;
extern SDLNotificationName *const SDLDidReceiveReadDIDResponse;
extern SDLNotificationName *const SDLDidReceiveRegisterAppInterfaceResponse;
extern SDLNotificationName *const SDLDidReceiveResetGlobalPropertiesResponse;
extern SDLNotificationName *const SDLDidReceiveScrollableMessageResponse;
extern SDLNotificationName *const SDLDidReceiveSendLocationResponse;
extern SDLNotificationName *const SDLDidReceiveSetAppIconResponse;
extern SDLNotificationName *const SDLDidReceiveSetDisplayLayoutResponse;
extern SDLNotificationName *const SDLDidReceiveSetGlobalPropertiesResponse;
extern SDLNotificationName *const SDLDidReceiveSetMediaClockTimerResponse;
extern SDLNotificationName *const SDLDidReceiveShowConstantTBTResponse;
extern SDLNotificationName *const SDLDidReceiveShowResponse;
extern SDLNotificationName *const SDLDidReceiveSliderResponse;
extern SDLNotificationName *const SDLDidReceiveSpeakResponse;
extern SDLNotificationName *const SDLDidReceiveSubscribeButtonResponse;
extern SDLNotificationName *const SDLDidReceiveSubscribeVehicleDataResponse;
extern SDLNotificationName *const SDLDidReceiveSyncPDataResponse;
extern SDLNotificationName *const SDLDidReceiveUpdateTurnListResponse;
extern SDLNotificationName *const SDLDidReceiveUnregisterAppInterfaceResponse;
extern SDLNotificationName *const SDLDidReceiveUnsubscribeButtonResponse;
extern SDLNotificationName *const SDLDidReceiveUnsubscribeVehicleDataResponse;

#pragma mark - RPC Notifications
extern SDLNotificationName *const SDLDidChangeDriverDistractionStateNotification;
extern SDLNotificationName *const SDLDidChangeHMIStatusNotification;
extern SDLNotificationName *const SDLDidReceiveAudioPassThruNotification;
extern SDLNotificationName *const SDLDidReceiveAppUnregisteredNotification;
extern SDLNotificationName *const SDLDidReceiveButtonEventNotification;
extern SDLNotificationName *const SDLDidReceiveButtonPressNotification;
extern SDLNotificationName *const SDLDidReceiveCommandNotification;
extern SDLNotificationName *const SDLDidReceiveEncodedDataNotification;
extern SDLNotificationName *const SDLDidReceiveNewHashNotification;
extern SDLNotificationName *const SDLDidChangeLanguageNotification;
extern SDLNotificationName *const SDLDidChangeLockScreenStatusNotification;
extern SDLNotificationName *const SDLDidReceiveVehicleIconNotification;
extern SDLNotificationName *const SDLDidChangePermissionsNotification;
extern SDLNotificationName *const SDLDidReceiveSystemRequestNotification;
extern SDLNotificationName *const SDLDidChangeTurnByTurnStateNotification;
extern SDLNotificationName *const SDLDidReceiveTouchEventNotification;
extern SDLNotificationName *const SDLDidReceiveVehicleDataNotification;

NS_ASSUME_NONNULL_END
