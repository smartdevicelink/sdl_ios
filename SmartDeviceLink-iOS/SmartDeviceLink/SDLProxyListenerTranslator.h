//  SDLProxyListenerBase.h
//  Copyright (c) 2015 Ford Motor Company. All rights reserved.

#import "SDLProxyListener.h"

@class SDLManager;

@interface SDLProxyListenerTranslator: NSObject <SDLProxyListener>

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithManager:(SDLManager *)manager NS_DESIGNATED_INITIALIZER;

@end
