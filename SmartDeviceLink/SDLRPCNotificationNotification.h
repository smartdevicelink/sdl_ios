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

/**
 *  Returns whether or not the containing notification is equal to a class, not including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isNotificationMemberOfClass:(Class)aClass;

/**
 *  Returns whether or not the containing notification is a kind of class, including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isNotificationKindOfClass:(Class)aClass;


@end

NS_ASSUME_NONNULL_END
