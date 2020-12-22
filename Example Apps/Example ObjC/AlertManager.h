//
//  AlertManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLAlert;

NS_ASSUME_NONNULL_BEGIN

@interface AlertManager : NSObject

/**
 Creates an alert with up to two lines of text, an image, and a close button that will dismiss the alert when tapped.

 @param textField1 The first line of the message to display in the alert
 @param textField2 The second line of the message to display in the alert
 @param iconName An image to show in the alert.
 @return An SDLAlert object
 */
+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
