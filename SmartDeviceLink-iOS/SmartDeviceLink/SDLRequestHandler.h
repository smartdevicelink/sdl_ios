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

@property (copy, nonatomic, readonly) SDLRPCNotificationHandler handler;

- (instancetype)initWithHandler:(SDLRPCNotificationHandler)handler;

@end

NS_ASSUME_NONNULL_END
