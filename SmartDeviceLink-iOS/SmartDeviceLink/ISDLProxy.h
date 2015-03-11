//  ISDLProxy.h
//



#import "SDLProtocol.h"
#import "SDLProxyListener"
#import "SDLRPCMessage"
#import "SDLTransport"

@protocol ISDLProxy

-(instancetype) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

@end
