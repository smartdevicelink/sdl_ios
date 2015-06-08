//  SDLSoftButtonWithHandler.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLSoftButton.h"
#import "SDLHandlers.h"

@interface SDLSoftButtonWithHandler : SDLSoftButton

@property (copy) rpcNotificationHandler onButtonHandler;

@end
