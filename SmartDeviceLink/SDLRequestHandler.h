//
//  SDLRequestHandler.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 10/6/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLNotificationConstants.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SDLRequestHandler <NSObject>

/**
 *  The handler that is added to any RPC implementing this protocol.
 */
@property (copy, nonatomic) SDLRPCNotificationHandler handler;

/**
 *  A special init function on any RPC implementing this protocol.
 *
 *  @param handler The handler to be called at specified times, such as events for buttons.
 *
 *  @return An instance of the class implementing this protocol.
 */
- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler;

@end

NS_ASSUME_NONNULL_END
