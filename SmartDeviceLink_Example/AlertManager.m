//
//  AlertManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"
#import "SmartDeviceLink.h"

@interface AlertManager ()


@end

@implementation AlertManager

+ (SDLAlert *)alertWithMessage:(NSString *)textField1 textField2:(NSString *)textField2 {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 duration:5000];
}

+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(NSString *)textField2 {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertText3:nil duration:5000 softButtons:@[[self sdlex_okSoftButton]]];
}

+ (SDLSoftButton *)sdlex_okSoftButton {
    SDLSoftButton *okSoftButton = [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:@"OK" image:nil highlighted:YES buttonId:1 systemAction:nil handler:nil];
    return okSoftButton;
}



@end
