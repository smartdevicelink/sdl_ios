//
//  SDLRPCResponseNotification.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLRPCResponseNotification.h"

#import "SDLNotificationConstants.h"
#import "SDLRPCResponse.h"


@implementation SDLRPCResponseNotification

@synthesize name = _name;
@synthesize object = _object;
@synthesize userInfo = _userInfo;

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcResponse:(SDLRPCResponse *)response {
    _name = name;
    _object = object;
    _userInfo = @{SDLNotificationUserInfoObject: response};

    return self;
}

- (__kindof SDLRPCResponse *)response {
    return _userInfo[SDLNotificationUserInfoObject];
}

@end
