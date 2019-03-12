//
//  SDLRPCRequestNotification.h
//  SmartDeviceLink
//
//  Created by Nicole on 2/14/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCRequest;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A NSNotification object that makes retrieving internal SDLRPCRequest data easier
 */
@interface SDLRPCRequestNotification : NSNotification

/**
 *  The request to be included in the userinfo dictionary
 */
@property (copy, nonatomic, readonly) __kindof SDLRPCRequest *request;

/**
 *  Create an NSNotification object containing an SDLRPCRequest
 *
 *  @param name The NSNotification name
 *  @param object The NSNotification object
 *  @param request The SDLRPCRequest payload
 *  @return The NSNotification
 */
- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcRequest:(__kindof SDLRPCRequest *)request;

/**
 *  Returns whether or not the containing request is equal to a class, not including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isRequestMemberOfClass:(Class)aClass;

/**
 *  Returns whether or not the containing request is a kind of class, including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isRequestKindOfClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
