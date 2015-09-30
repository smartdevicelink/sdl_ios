//  SDLSubscribeButtonWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLSubscribeButton.h"
#import "SDLNotificationConstants.h"

@interface SDLSubscribeButtonWithHandler : SDLSubscribeButton

@property (nonatomic, copy) SDLRPCNotificationHandler onButtonHandler;

@end
