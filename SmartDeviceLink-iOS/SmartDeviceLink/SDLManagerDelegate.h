//  SDLDelegates.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

@class SDLManager, SDLRPCResponse, SDLRPCNotification, SDLOnHMIStatus, SDLOnDriverDistraction, SDLRegisterAppInterfaceResponse, SDLOnAppInterfaceUnregistered, SDLOnAudioPassThru, SDLOnButtonEvent, SDLOnButtonPress, SDLOnCommand, SDLOnEncodedSyncPData, SDLOnHashChange, SDLOnLanguageChange, SDLOnLockScreenStatus, SDLOnPermissionsChange, SDLOnSyncPData, SDLOnSystemRequest, SDLOnTBTClientState, SDLOnTouchEvent, SDLOnVehicleData;

typedef void (^SDLRPCResponseHandler) (__kindof SDLRPCResponse *response);
typedef void (^SDLRPCNotificationHandler) (__kindof SDLRPCNotification *notification);

@protocol SDLManagerDelegate <NSObject>

@optional
- (void)manager:(SDLManager *)manager didReceiveFirstFullHMIStatus:(SDLOnHMIStatus *)hmiStatus;
- (void)manager:(SDLManager *)manager didReceiveFirstNonNoneHMIStatus:(SDLOnHMIStatus *)hmiStatus;
- (void)manager:(SDLManager *)manager didChangeDriverDistractionState:(SDLOnDriverDistraction *)driverDistraction;
- (void)manager:(SDLManager *)manager didChangeHMIStatus:(SDLOnHMIStatus *)hmiStatus;
- (void)managerDidDisconnect:(SDLManager *)manager;
- (void)managerDidConnect:(SDLManager *)manager;
- (void)manager:(SDLManager *)manager didRegister:(SDLRegisterAppInterfaceResponse *)registerResponse;
- (void)manager:(SDLManager *)manager didFailToRegisterWithError:(NSError *)error;
- (void)manager:(SDLManager *)manager didReceiveError:(NSError *)error;
- (void)manager:(SDLManager *)manager didUnregister:(SDLOnAppInterfaceUnregistered *)unregisterNotification;
- (void)manager:(SDLManager *)manager didReceiveAudioPassThru:(SDLOnAudioPassThru *)audioPassThru;
- (void)manager:(SDLManager *)manager didReceiveButtonEvent:(SDLOnButtonEvent *)buttonEvent;
- (void)manager:(SDLManager *)manager didReceiveButtonPress:(SDLOnButtonPress *)buttonPress;
- (void)manager:(SDLManager *)manager didReceiveCommand:(SDLOnCommand *)command;
- (void)manager:(SDLManager *)manager didReceiveEncodedData:(SDLOnEncodedSyncPData *)encodedData;
- (void)manager:(SDLManager *)manager didReceiveNewHash:(SDLOnHashChange *)hash;
- (void)manager:(SDLManager *)manager didChangeLanguage:(SDLOnLanguageChange *)language;
- (void)manager:(SDLManager *)manager didChangeLockScreenStatus:(SDLOnLockScreenStatus *)lockScreenStatus;
- (void)manager:(SDLManager *)manager didChangePermissions:(SDLOnPermissionsChange *)permissions;
- (void)manager:(SDLManager *)manager didReceiveData:(SDLOnSyncPData *)data;
- (void)manager:(SDLManager *)manager didReceiveSystemRequest:(SDLOnSystemRequest *)request;
- (void)manager:(SDLManager *)manager didChangeTurnByTurnState:(SDLOnTBTClientState *)state;
- (void)manager:(SDLManager *)manager didReceiveTouchEvent:(SDLOnTouchEvent *)touchEvent;
- (void)manager:(SDLManager *)manager didReceiveVehicleData:(SDLOnVehicleData *)vehicleData;

@end