//  SDLSubscribeButtonWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLSubscribeButton.h"
#import "SDLManagerDelegate.h"

@interface SDLSubscribeButtonWithHandler : SDLSubscribeButton

@property (copy) SDLRPCNotificationHandler onButtonHandler;

@end
