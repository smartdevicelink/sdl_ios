//  ISDLProxy.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProtocol.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLRPCMessage.h>
#import <SmartDeviceLink/SDLTransport.h>

@protocol ISDLProxy

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

@end
