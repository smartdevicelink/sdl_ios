//
//  SDLNotificationConstants.m
//  SmartDeviceLink-iOS
//
//  Created by Justin Dickow on 9/30/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLNotificationConstants.h"

// TODO: Further namespace since other notification types will be firing, e.g. state machine notifications
NSString *const SDLDidReceiveFirstFullHMIStatusNotification = @"com.sdl.notification.firstFullHMIStatus";
NSString *const SDLDidReceiveFirstNonNoneHMIStatusNotification = @"com.sdl.notification.firstNonNoneHMIStatus";
NSString *const SDLDidChangeDriverDistractionStateNotification = @"com.sdl.notification.changeDriverDistractionState";
NSString *const SDLDidChangeHMIStatusNotification = @"com.sdl.notification.changeHMIStatus";
NSString *const SDLDidDisconnectNotification = @"com.sdl.notification.disconnect";
NSString *const SDLDidConnectNotification = @"com.sdl.notification.connect";
NSString *const SDLDidRegisterNotification = @"com.sdl.notification.register";
NSString *const SDLDidFailToRegisterNotification = @"com.sdl.notification.failToRegister";
NSString *const SDLDidBecomeReadyNotification = @"com.sdl.notification.managerReady";
NSString *const SDLDidReceiveErrorNotification = @"com.sdl.notification.receiveError";
NSString *const SDLDidUnregisterNotification = @"com.sdl.notification.unregister";
NSString *const SDLDidReceiveAudioPassThruNotification = @"com.sdl.notification.receiveAudioPassThru";
NSString *const SDLDidReceiveButtonEventNotification = @"com.sdl.notification.receiveButtonEvent";
NSString *const SDLDidReceiveButtonPressNotification = @"com.sdl.notification.receiveButtonPress";
NSString *const SDLDidReceiveCommandNotification = @"com.sdl.notification.receiveCommand";
NSString *const SDLDidReceiveEncodedDataNotification = @"com.sdl.notification.receiveEncodedData";
NSString *const SDLDidReceiveNewHashNotification = @"com.sdl.notification.receiveNewHash";
NSString *const SDLDidChangeLanguageNotification = @"com.sdl.notification.changeLanguage";
NSString *const SDLDidChangeLockScreenStatusNotification = @"com.sdl.notification.changeLockScreenStatus";
NSString *const SDLDidReceiveVehicleIconNotification = @"com.sdl.notification.vehicleIcon";
NSString *const SDLDidChangePermissionsNotification = @"com.sdl.notification.changePermission";
NSString *const SDLDidReceiveDataNotification = @"com.sdl.notification.receiveData";
NSString *const SDLDidReceiveSystemRequestNotification = @"com.sdl.notification.receiveSystemRequest";
NSString *const SDLDidChangeTurnByTurnStateNotification = @"com.sdl.notification.changeTurnByTurnState";
NSString *const SDLDidReceiveTouchEventNotification = @"com.sdl.notification.receiveTouchEvent";
NSString *const SDLDidReceiveVehicleDataNotification = @"com.sdl.notification.receiveVehicleData";

NSString *const SDLNotificationUserInfoNotificationObject = @"com.sdl.notification.keys.notificationObject";