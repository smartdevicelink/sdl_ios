//  SDLISyncProxy.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLProtocol.h>
#import <AppLink/SDLProxyListener.h>
#import <AppLink/SDLRPCMessage.h>
#import <AppLink/SDLTransport.h>

@protocol ISDLProxy

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

@end
