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

+ (SDLAlert *)alertWithMessage:(NSString *)textField1 textField2:(nullable NSString *)textField2;
+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)textField1 textField2:(nullable NSString *)textField2 iconName:(nullable NSString *)iconName;

@end

NS_ASSUME_NONNULL_END
