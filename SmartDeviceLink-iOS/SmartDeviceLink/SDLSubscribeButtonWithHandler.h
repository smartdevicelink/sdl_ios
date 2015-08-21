//  SDLSubscribeButtonWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLSubscribeButton.h"
#import "SDLHandlers.h"

@interface SDLSubscribeButtonWithHandler : SDLSubscribeButton

@property (copy) RPCNotificationHandler onButtonHandler;

@end
