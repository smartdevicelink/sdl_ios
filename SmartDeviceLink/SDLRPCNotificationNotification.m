//
//  SDLRPCNotificationNotification.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLRPCNotificationNotification.h"

#import "SDLNotificationConstants.h"
#import "SDLRPCNotification.h"


@implementation SDLRPCNotificationNotification

- (instancetype)initWithName:(NSString *)name object:(id)object rpcNotification:(SDLRPCNotification *)notification {
    self = [self initWithName:name object:object userInfo:@{SDLNotificationUserInfoObject : notification}];
    if (!self) { return nil; }
    
    _notification = notification;
    
    return self;
}

@end
