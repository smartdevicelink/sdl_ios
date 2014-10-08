//  SDLApplinkProtocolRecievedMessageRouter.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProtocolListener.h"
@class SDLProtocolMessage;


@interface SDLProtocolRecievedMessageRouter : NSObject

@property (weak) id<SDLProtocolListener> delegate;

- (void)handleRecievedMessage:(SDLProtocolMessage *)message;

@end
