//
//  SDLRPCResponseNotification.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 8/25/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCResponse;


NS_ASSUME_NONNULL_BEGIN

/**
 *  A NSNotification object that makes retrieving internal SDLRPCResponse data easier
 */
@interface SDLRPCResponseNotification : NSNotification

/**
 *  The response to be included within the userinfo dictionary
 */
@property (copy, nonatomic, readonly) __kindof SDLRPCResponse *response;

/**
 *  Create an NSNotification object containing an SDLRPCResponse
 *
 *  @param name The NSNotification name
 *  @param object The NSNotification object
 *  @param response The SDLRPCResponse payload
 *  @return The NSNotification
 */
- (instancetype)initWithName:(NSString *)name object:(nullable id)object rpcResponse:(__kindof SDLRPCResponse *)response;

/**
 *  Returns whether or not the containing response is equal to a class, not including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isResponseMemberOfClass:(Class)aClass;

/**
 *  Returns whether or not the containing response is a kind of class, including subclasses.
 *
 *  @param aClass the class you are questioning
 */
- (BOOL)isResponseKindOfClass:(Class)aClass;

@end

NS_ASSUME_NONNULL_END
