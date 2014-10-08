//  SDLApplinkProtocolRecievedMessageRouter.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import "SDLProtocolListener.h"
@class SDLAppLinkProtocolMessage;


@interface SDLApplinkProtocolRecievedMessageRouter : NSObject

@property (weak) id<SDLProtocolListener> delegate;

- (void)handleRecievedMessage:(SDLAppLinkProtocolMessage *)message;

@end
