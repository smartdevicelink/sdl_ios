//
//  SDLResponseDispatcher.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 7/8/16.
//  Copyright © 2016 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NSMapTable+Subscripting.h"
#import "SDLNotificationConstants.h"


typedef NSNumber SDLRPCCorrelationId;
typedef NSNumber SDLAddCommandCommandId;
typedef NSString SDLSubscribeButtonName;
typedef NSNumber SDLSoftButtonId;


NS_ASSUME_NONNULL_BEGIN

/**
 *  The SDLResponseDispatcher tracks RPC requests and watches for corresponding responses. When one is seen, it fires a completion handler if one was set. It also stores extra completion handlers for specific types of RPCs such as buttons, and fires those handlers if event notifications for those buttons were sent.
 */
@interface SDLResponseDispatcher : NSObject

/**
 *  Holds a map of RPC request correlation ids and corresponding blocks.
 */
@property (strong, nonatomic, readonly) NSMapTable<SDLRPCCorrelationId *, SDLResponseHandler> *rpcResponseHandlerMap;

/**
 *  Holds a dictionary of RPC request correlation ids and their corresponding RPC request.
 */
@property (strong, nonatomic, readonly) NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *rpcRequestDictionary;

/**
 *  Holds a map of command ids and their corresponding blocks.
 */
@property (strong, nonatomic, readonly) NSMapTable<SDLAddCommandCommandId *, SDLRPCCommandNotificationHandler> *commandHandlerMap;

/**
 *  Holds a map of button names and their corresponding blocks.
 */
@property (strong, nonatomic, readonly) NSMapTable<SDLSubscribeButtonName *, SDLRPCButtonNotificationHandler> *buttonHandlerMap;

/**
 *  Holds a map of soft button ids and their corresponding blocks.
 */
@property (strong, nonatomic, readonly) NSMapTable<SDLSoftButtonId *, SDLRPCButtonNotificationHandler> *customButtonHandlerMap;

/**
 *  Holds an audio pass thru block.
 */
@property (strong, nonatomic, readonly, nullable) SDLAudioPassThruHandler audioPassThruHandler;
    
/**
 *  Create a new response dispatcher.
 *
 *  @param dispatcher A notification dispatcher to watch only its notifications.
 *
 *  @return An instance of `SDLResponseDispatcher`.
 */
- (instancetype)initWithNotificationDispatcher:(nullable id)dispatcher NS_DESIGNATED_INITIALIZER;

/**
 *  Store an RPC request to later call that handler. This will also store the command or button handlers on the RPC request if they exist.
 *
 *  @param request The RPC request to track.
 *  @param handler The handler to invoke when a corresponding response returns.
 */
- (void)storeRequest:(SDLRPCRequest *)request handler:(nullable SDLResponseHandler)handler;

/**
 *  Clear all maps and dictionaries of objects.
 */
- (void)clear;

@end

NS_ASSUME_NONNULL_END
