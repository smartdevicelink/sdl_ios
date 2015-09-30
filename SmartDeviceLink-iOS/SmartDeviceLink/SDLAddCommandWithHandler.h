//  SDLAddCommandWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLAddCommand.h"
#import "SDLNotificationConstants.h"

@interface SDLAddCommandWithHandler : SDLAddCommand

@property (copy) SDLRPCNotificationHandler onCommandHandler;

@end
