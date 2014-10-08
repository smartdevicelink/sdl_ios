//  SDLSyncProxy.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//  Version: ##Version##

#import <Foundation/Foundation.h>
#import <AppLink/SDLProtocol.h>
#import <AppLink/SDLProxyListener.h>
#import <AppLink/SDLRPCRequestFactory.h>
#import <AppLink/SDLTransport.h>

@interface SDLProxy : NSObject<SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
	Byte rpcSessionID;
	Byte bulkSessionID;
	BOOL isConnected;
    BOOL alreadyDestructed;

}

@property (strong) NSObject<SDLProtocol>* protocol;
@property (strong) NSObject<SDLTransport>* transport;
@property (strong) NSMutableArray* proxyListeners;
@property (strong) NSTimer* handshakeTimer;
@property (strong) NSString *debugConsoleGroupName;

-(id) initWithTransport:(NSObject<SDLTransport>*) transport protocol:(NSObject<SDLProtocol>*) protocol delegate:(NSObject<SDLProxyListener>*) delegate;

-(void) dispose;
-(void) addDelegate:(NSObject<SDLProxyListener>*) delegate;

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLAppLinkProtocolMessage*) msgData;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;

-(NSObject<SDLTransport>*)getTransport;
-(NSObject<SDLProtocol>*)getProtocol;

- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest;

@end
