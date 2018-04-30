//
//  AlertManager.m
//  SmartDeviceLink-Example-ObjC
//
//  Created by Nicole on 4/30/18.
//  Copyright © 2018 smartdevicelink. All rights reserved.
//

#import "AlertManager.h"

@implementation AlertManager

+ (SDLAlert *)alertWithMessage:(NSString *)message {
    return [[SDLAlert alloc] init];
}

+ (SDLAlert *)alertWithMessageAndCloseButton:(NSString *)message {
    return [[SDLAlert alloc] init];
}


@end
