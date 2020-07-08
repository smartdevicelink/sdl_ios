//
//  SDLnotificationDispatcher.m
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/7/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import "SDLNotificationDispatcher.h"

#import "SDLNotificationConstants.h"
#import "SDLRPCNotification.h"
#import "SDLRPCNotificationNotification.h"
#import "SDLRPCRequest.h"
#import "SDLRPCRequestNotification.h"
#import "SDLRPCResponse.h"
#import "SDLRPCResponseNotification.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLNotificationDispatcher

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }

    return self;
}

- (void)postNotificationName:(NSString *)name infoObject:(nullable id)infoObject {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (infoObject != nil) {
        userInfo = @{SDLNotificationUserInfoObject: infoObject};
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

- (void)postRPCRequestNotification:(NSString *)name request:(__kindof SDLRPCRequest *)request {
    SDLRPCRequestNotification *notification = [[SDLRPCRequestNotification alloc] initWithName:name object:self rpcRequest:request];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postRPCResponseNotification:(NSString *)name response:(__kindof SDLRPCResponse *)response {
    SDLRPCResponseNotification *notification = [[SDLRPCResponseNotification alloc] initWithName:name object:self rpcResponse:response];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postRPCNotificationNotification:(NSString *)name notification:(__kindof SDLRPCNotification *)rpcNotification {
    SDLRPCNotificationNotification *notification = [[SDLRPCNotificationNotification alloc] initWithName:name object:self rpcNotification:rpcNotification];

    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

@end

NS_ASSUME_NONNULL_END
