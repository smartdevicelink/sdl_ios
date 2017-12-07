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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCResponseNotification

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcResponse:(SDLRPCResponse *)response {
    self = [super initWithName:name object:object userInfo:@{SDLNotificationUserInfoObject: response}];
    if (!self) { return nil; }

    return self;
}

- (__kindof SDLRPCResponse *)response {
    return self.userInfo[SDLNotificationUserInfoObject];
}

- (BOOL)isResponseMemberOfClass:(Class)aClass {
    NSAssert([self.response isMemberOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.response isMemberOfClass:aClass];
}

- (BOOL)isResponseKindOfClass:(Class)aClass {
    NSAssert([self.response isKindOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.response isKindOfClass:aClass];
}

@end

NS_ASSUME_NONNULL_END
