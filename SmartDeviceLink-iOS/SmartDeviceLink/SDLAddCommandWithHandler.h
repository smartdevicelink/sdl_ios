//  SDLAddCommandWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLAddCommand.h"
#import "SDLHandlers.h"

@interface SDLAddCommandWithHandler : SDLAddCommand

@property (copy) rpcNotificationHandler onCommandHandler;

@end
