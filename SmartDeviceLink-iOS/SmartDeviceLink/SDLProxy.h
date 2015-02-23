//  SDLProxy.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//  Version: ##Version##


#import "SDLProtocol.h"
#import "SDLProxyListener.h"
#import "SDLRPCRequestFactory.h"
#import "SDLTransport.h"

@interface SDLProxy : NSObject<SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
	Byte rpcSessionID;
	Byte bulkSessionID;
	BOOL isConnected;
    BOOL alreadyDestructed;

}

@property (strong) NSObject<SDLInterfaceProtocol>* protocol;
@property (strong) NSObject<SDLTransport>* transport;
@property (strong) NSMutableArray* proxyListeners;
@property (strong) NSTimer* handshakeTimer;
@property (strong) NSString *debugConsoleGroupName;

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLInterfaceProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLProtocolMessage*) msgData;

-(NSObject<SDLTransport>*)getTransport;
-(NSObject<SDLInterfaceProtocol>*)getProtocol;

- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest __deprecated_msg("use -putFileStream:withRequest: instead");
- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest;

@end
