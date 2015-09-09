//  SDLProxyListenerBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLProxyListener.h"

@class SDLProxyBase;

@interface SDLProxyListenerBase : NSObject <SDLProxyListener>

- (id)initWithProxyBase:(SDLProxyBase *)base NS_DESIGNATED_INITIALIZER;

@end
