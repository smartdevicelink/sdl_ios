//
//  SDLDispatchingStrategy.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLRPCMessageType.h>

@protocol SDLDispatchingStrategyDelegate <NSObject>

-(void)messageDidDispatch:(SDLRPCMessageType*)messageType;

-(void)dispatchDidError:(NSError*)error;

-(void)dispatchingQueueDidError:(NSError*)error;

@end
