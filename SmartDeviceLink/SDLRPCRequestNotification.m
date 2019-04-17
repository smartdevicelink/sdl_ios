//
//  SDLRPCRequestNotification.m
//  SmartDeviceLink
//
//  Created by Nicole on 2/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import "SDLRPCRequestNotification.h"

#import "SDLNotificationConstants.h"
#import "SDLRPCRequest.h"

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCRequestNotification

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-atomic-properties"
@synthesize name = _name;
@synthesize object = _object;
@synthesize userInfo = _userInfo;
#pragma clang diagnostic pop

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcRequest:(__kindof SDLRPCRequest *)request {
    _name = name;
    _object = object;
    _userInfo = @{SDLNotificationUserInfoObject: request};

    return self;
}

- (__kindof SDLRPCRequest *)request {
    return _userInfo[SDLNotificationUserInfoObject];
}

- (BOOL)isRequestMemberOfClass:(Class)aClass {
    NSAssert([self.request isMemberOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.request isMemberOfClass:aClass];
}

- (BOOL)isRequestKindOfClass:(Class)aClass {
    NSAssert([self.request isKindOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.request isKindOfClass:aClass];
}

@end

NS_ASSUME_NONNULL_END
