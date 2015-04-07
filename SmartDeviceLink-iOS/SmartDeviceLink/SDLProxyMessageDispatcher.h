//
//  SDLProxyMessageDispatcher.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartDeviceLink/SDLProtocolMessage.h"
#import "SmartDeviceLink/SDLDispatchingStrategyDelegate.h"
#import "SmartDeviceLink/SDLRPCMessageType.h"
#import "SmartDeviceLink/SDLInternalProxyMessage.h"

@interface SDLProxyMessageDispatcher : NSObject

-(instancetype)initWithQueueName:(NSString*)queueName completionHandler:(void (^)(id dispatchedMessage, NSException* exception))completionHandler;

-(void)queueMessage:(SDLProtocolMessage*)message;
-(void)dispose;

@end
