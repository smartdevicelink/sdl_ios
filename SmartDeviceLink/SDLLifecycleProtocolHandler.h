//
//  SDLProtocolDelegateHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProtocolDelegate.h"

@class SDLNotificationDispatcher;
@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleProtocolHandler : NSObject <SDLProtocolDelegate>

@property (strong, nonatomic) SDLProtocol *protocol;

- (instancetype)initWithProtocol:(SDLProtocol *)protocol notificationDispatcher:(SDLNotificationDispatcher *)notificationDispatcher configuration:(SDLConfiguration *)configuration;

- (void)start;
- (void)stop;

@end

NS_ASSUME_NONNULL_END
