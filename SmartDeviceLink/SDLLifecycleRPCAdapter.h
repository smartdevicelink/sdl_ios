//
//  SDLLifecycleRPCAdapter.h
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/15/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SDLRPCMessage;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleRPCAdapter : NSObject

/// Takes an RPC message (request, response, or notification) and adapts it based on the current version. This may need to happen before being sent or received.
/// @param message The message to be adapted
/// @return The message or messages to be sent or recieved
+ (NSArray<SDLRPCMessage *> *)adaptRPC:(SDLRPCMessage *)message;

@end

NS_ASSUME_NONNULL_END
