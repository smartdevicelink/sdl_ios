//
//  AlertManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AppConstants.h"
#import "AlertManager.h"
#import "SmartDeviceLink.h"

NS_ASSUME_NONNULL_BEGIN

@implementation AlertManager

+ (SDLSoftButton *)sdlex_okSoftButton {
    return [[SDLSoftButton alloc] initWithType:SDLSoftButtonTypeText text:AlertOKButtonText image:nil highlighted:YES buttonId:1 systemAction:nil handler:nil];
}

+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName {
    return [[SDLAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertText3:nil softButtons:@[[self.class sdlex_okSoftButton]] playTone:YES ttsChunks:nil duration:5000 progressIndicator:NO alertIcon:((iconName != nil) ? [[SDLImage alloc] initWithName:iconName isTemplate:YES] : nil) cancelID:0];
}

+ (SDLSubtleAlert *)subtleAlertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName {
    return [[SDLSubtleAlert alloc] initWithAlertText1:textField1 alertText2:textField2 alertIcon:((iconName != nil) ? [[SDLImage alloc] initWithName:iconName isTemplate:YES] : nil) ttsChunks:nil duration:nil softButtons:@[[self.class sdlex_okSoftButton]] cancelID:0];
}

@end

NS_ASSUME_NONNULL_END
