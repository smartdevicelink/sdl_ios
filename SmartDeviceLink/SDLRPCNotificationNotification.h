//
//  SDLRPCNotificationNotification.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCNotification;


NS_ASSUME_NONNULL_BEGIN

@interface SDLRPCNotificationNotification : NSNotification

@property (copy, nonatomic, readonly) __kindof SDLRPCNotification *notification;

- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcNotification:(__kindof SDLRPCNotification *)notification;

@end

NS_ASSUME_NONNULL_END
