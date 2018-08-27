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

/**
 An NSNotification object that makes retrieving internal SDLRPCNotification data easier
 */
@interface SDLRPCNotificationNotification : NSNotification

/**
 The notification within the userinfo dictionary
 */
@property (copy, nonatomic, readonly) __kindof SDLRPCNotification *notification;

/**
 Create an NSNotification object caontaining an SDLRPCNotification

 @param name The NSNotification name
 @param object The NSNotification object
 @param notification The SDLRPCNotification payload
 @return The NSNotification
 */
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
