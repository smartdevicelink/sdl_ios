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

typedef NS_ENUM(NSUInteger, SDLRPCDirection) {
    SDLRPCDirectionIncoming,
    SDLRPCDirectionOutgoing
};

@interface SDLLifecycleRPCAdapter : NSObject

/// Takes an RPC message (request, response, or notification) and adapts for the negotiated RPC spec version. This may need to happen before being sent or received.
/// @param message The message to be adapted
/// @return The message or messages to be sent or recieved
+ (NSArray<SDLRPCMessage *> *)adaptRPC:(SDLRPCMessage *)message direction:(SDLRPCDirection)direction;

@end

NS_ASSUME_NONNULL_END
