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

@interface SDLResponseDispatcher : NSObject

// Dictionaries to link handlers with requests/commands/etc
@property (strong, nonatomic) NSMapTable<SDLRPCCorrelationId *, SDLRequestCompletionHandler> *rpcResponseHandlerMap;
@property (strong, nonatomic) NSMutableDictionary<SDLRPCCorrelationId *, SDLRPCRequest *> *rpcRequestDictionary;
@property (strong, nonatomic) NSMapTable<SDLAddCommandCommandId *, SDLRPCNotificationHandler> *commandHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSubscribeButtonName *, SDLRPCNotificationHandler> *buttonHandlerMap;
@property (strong, nonatomic) NSMapTable<SDLSoftButtonId *, SDLRPCNotificationHandler> *customButtonHandlerMap;

- (instancetype)initWithDispatcher:(id)dispatcher;

- (void)storeRequest:(SDLRPCRequest *)request handler:(nullable SDLRequestCompletionHandler)handler;

@end

NS_ASSUME_NONNULL_END
