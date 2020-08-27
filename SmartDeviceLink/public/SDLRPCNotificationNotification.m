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

NS_ASSUME_NONNULL_BEGIN

@implementation SDLRPCNotificationNotification

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wimplicit-atomic-properties"
@synthesize name = _name;
@synthesize object = _object;
@synthesize userInfo = _userInfo;
#pragma clang diagnostic pop

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcNotification:(SDLRPCNotification *)notification {
    _name = name;
    _object = object;
    _userInfo = @{SDLNotificationUserInfoObject: notification};

    if (!self) { return nil; }

    return self;
}

- (__kindof SDLRPCNotification *)notification {
    return _userInfo[SDLNotificationUserInfoObject];
}

- (BOOL)isNotificationMemberOfClass:(Class)aClass {
    NSAssert([self.notification isMemberOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.notification isMemberOfClass:aClass];
}

- (BOOL)isNotificationKindOfClass:(Class)aClass {
    NSAssert([self.notification isKindOfClass:aClass], @"A notification was sent with an unanticipated object");
    return [self.notification isKindOfClass:aClass];
}

@end

NS_ASSUME_NONNULL_END
