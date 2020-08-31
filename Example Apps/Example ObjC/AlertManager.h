//
//  AlertManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAlert;
@class SDLManager;
@class SDLSubtleAlert;

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

/// Sends an alert with up to two lines of text, an image, and a close button that will dismiss the alert when tapped.
/// @param imageName The name of the image to upload
/// @param textField1 The first line of text in the alert
/// @param textField2 The second line of text in the alert
/// @param sdlManager The SDLManager
+ (void)sendAlertWithManager:(SDLManager *)sdlManager image:(nullable NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2;

/// Sends a subtle alert with up to two lines of text, and an image.
/// @param imageName The name of the image to upload
/// @param textField1 The first line of text in the alert
/// @param textField2 The second line of text in the alert
/// @param sdlManager The SDLManager
+ (void)sendSubtleAlertWithManager:(SDLManager *)sdlManager image:(nullable NSString *)imageName textField1:(NSString *)textField1 textField2:(nullable NSString *)textField2;

@end

NS_ASSUME_NONNULL_END
