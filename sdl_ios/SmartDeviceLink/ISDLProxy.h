//  ISDLProxy.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLProtocol.h"
#import "SDLProxyListener"
#import "SDLRPCMessage"
#import "SDLTransport"

@protocol ISDLProxy

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

@end
