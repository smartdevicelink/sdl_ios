//
//  AlertManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AlertManager

/**
 * Creates an alert with a single line of text
 *
 *  @param textField1   The first line of a message to display in the alert
 *  @param textField2   The second line of a message to display in the alert
 *  @return             An SDLAlert object
 */
+ (SDLAlert *)alertWithMessage:(NSString *)textField1 textField2:(nullable NSString *)textField2 {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 duration:5000];
}

/**
 *  Creates an alert with up to two lines of text and a close button that will dismiss the alert when tapped
 *
 *  @param textField1  The first line of a message to display in the alert
 *  @param textField2  The second line of a message to display in the alert
 *  @return            An SDLAlert object
 */
+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertText3:nil duration:5000 softButtons:@[[self sdlex_okSoftButton]]];
}

+ (SDLSoftButton *)sdlex_okSoftButton {
    SDLSoftButton *okSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"OK" image:nil highlighted:YES buttonId:1 systemAction:nil handler:nil];
    return okSoftButton;
}

@end

NS_ASSUME_NONNULL_END
