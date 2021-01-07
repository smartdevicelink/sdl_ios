//
//  SDLAlertManager.h
//  SmartDeviceLink
//
//  Created by Nicole on 11/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAlertView;
@class SDLFileManager;
@class SDLPermissionManager;
@class SDLSystemCapabilityManager;

@protocol SDLConnectionManagerType;

NS_ASSUME_NONNULL_BEGIN

/// Handler called when the alert either dismisses from the screen or it has failed to present
typedef void(^SDLAlertCompletionHandler)(NSError *__nullable error);

/// An alert manager that handles uploading images and audio needed by an alert, sending an alert and cancelling an alert.
@interface SDLAlertManager : NSObject

/// Initialize the manager with required dependencies
/// @param connectionManager The connection manager object for sending RPCs
/// @param fileManager The file manager object for uploading files
/// @param systemCapabilityManager The system capability manager object for reading window capabilities
/// @return The alert manager
- (instancetype)initWithConnectionManager:(id<SDLConnectionManagerType>)connectionManager fileManager:(SDLFileManager *)fileManager systemCapabilityManager:(SDLSystemCapabilityManager *)systemCapabilityManager permissionManager:(nullable SDLPermissionManager *)permissionManager;

/// Starts the manager. This method is used internally.
- (void)start;

/// Stops the manager. This method is used internally.
- (void)stop;

/// Present the alert on the screen.
///
/// If the alert contains an audio indication with a file that needs to be uploaded, it will be uploaded before presenting the alert. If the alert contains soft buttons with images, they will be uploaded before presenting the alert. If the alert contains an icon, that will be uploaded before presenting the alert.
///
/// The handler will be called when the alert either dismisses from the screen or it has failed to present. If the error value in the handler is present, then the alert failed to appear or was aborted, if not, then the alert dismissed without error. The error will contain `userInfo` with information on how long to wait before retrying.
///
/// @param alert Alert to be presented
/// @param handler The handler to be called when the alert either dismisses from the screen or it has failed to present
- (void)presentAlert:(SDLAlertView *)alert withCompletionHandler:(nullable SDLAlertCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
