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

typedef void (^SDLRPCNotificationHandler) (__kindof SDLRPCNotification *notification);
typedef void (^SDLRequestCompletionHandler) (__kindof SDLRPCRequest * __nullable request,  __kindof SDLRPCResponse * __nullable response, NSError * __nullable error);

extern NSString *const SDLDidReceiveFirstFullHMIStatusNotification;
extern NSString *const SDLDidReceiveFirstNonNoneHMIStatusNotification;
extern NSString *const SDLDidChangeDriverDistractionStateNotification;
extern NSString *const SDLDidChangeHMIStatusNotification;
extern NSString *const SDLDidDisconnectNotification;
extern NSString *const SDLDidConnectNotification;
extern NSString *const SDLDidRegisterNotification;
extern NSString *const SDLDidFailToRegisterNotification;
extern NSString *const SDLDidBecomeReadyNotification;
extern NSString *const SDLDidReceiveErrorNotification;
extern NSString *const SDLDidUnregisterNotification;
extern NSString *const SDLDidReceiveAudioPassThruNotification;
extern NSString *const SDLDidReceiveButtonEventNotification;
extern NSString *const SDLDidReceiveButtonPressNotification;
extern NSString *const SDLDidReceiveCommandNotification;
extern NSString *const SDLDidReceiveEncodedDataNotification;
extern NSString *const SDLDidReceiveNewHashNotification;
extern NSString *const SDLDidChangeLanguageNotification;
extern NSString *const SDLDidChangeLockScreenStatusNotification;
extern NSString *const SDLDidReceiveVehicleIconNotification;
extern NSString *const SDLDidChangePermissionsNotification;
extern NSString *const SDLDidReceiveDataNotification;
extern NSString *const SDLDidReceiveSystemRequestNotification;
extern NSString *const SDLDidChangeTurnByTurnStateNotification;
extern NSString *const SDLDidReceiveTouchEventNotification;
extern NSString *const SDLDidReceiveVehicleDataNotification;

extern NSString *const SDLNotificationUserInfoNotificationObject;

NS_ASSUME_NONNULL_END
