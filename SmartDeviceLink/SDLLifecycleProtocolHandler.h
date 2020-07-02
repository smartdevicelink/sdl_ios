//
//  SDLProtocolDelegateHandler.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDLProtocolDelegate.h"

@class SDLConfiguration;
@class SDLNotificationDispatcher;
@class SDLProtocol;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleProtocolHandler : NSObject <SDLProtocolDelegate>

@property (strong, nonatomic) SDLProtocol *protocol;

/// Initialize the object
/// @param protocol A protocol to receive protocol messages from and to send RPC data to
/// @param notificationDispatcher A notification dispatcher to send notifications through
/// @param configuration The configuration to use pass the app id to the protocol
- (instancetype)initWithProtocol:(SDLProtocol *)protocol notificationDispatcher:(SDLNotificationDispatcher *)notificationDispatcher configuration:(SDLConfiguration *)configuration;

/// Starts the manager and the underlying protocol.
- (void)start;

/// Stops the manager and the underlying protocol, which disconnects the underlying transport
/// @param disconnectCompletionHandler A handler called when the transport finishes its disconnection
- (void)stopWithCompletionHandler:(void (^)(void))disconnectCompletionHandler;

@end

NS_ASSUME_NONNULL_END
