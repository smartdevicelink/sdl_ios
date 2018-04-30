//
//  AlertManager.h
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink.h"

@interface AlertManager : NSObject

+ (SDLAlert *)alertWithMessage:(NSString *)message;
+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)message;

@end
