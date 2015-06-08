//  SDLHandlers.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

@class SDLRPCResponse, SDLRPCNotification;

typedef void (^eventHandler) ();
typedef void (^errorHandler) (NSException *);
typedef void (^rpcResponseHandler) (SDLRPCResponse *);
typedef void (^rpcNotificationHandler) (SDLRPCNotification *);
