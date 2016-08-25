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

- (instancetype)initWithName:(NSString *)name object:(id)object rpcResponse:(SDLRPCResponse *)response {
    self = [self initWithName:name object:object userInfo:@{SDLNotificationUserInfoObject : response}];
    if (!self) { return nil; }
    
    _response = response;
    
    return self;
}

@end
