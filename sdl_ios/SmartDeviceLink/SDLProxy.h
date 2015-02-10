//  SDLProxy.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//  Version: ##Version##

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLProtocol.h>
#import <SmartDeviceLink/SDLProxyListener.h>
#import <SmartDeviceLink/SDLRPCRequestFactory.h>
#import <SmartDeviceLink/SDLTransport.h>

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

-(void) sendRPC:(SDLRPCMessage *)message;
-(void) sendRPCRequest:(SDLRPCMessage*) msg __deprecated_msg("use sendRPC: instead");

-(void) handleRPCDictionary:(NSDictionary *)message;
-(void) handleRpcMessage:(NSDictionary*) msg __deprecated_msg("use handleRPCDictionary: instead");

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLProtocolMessage*) msgData;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;

-(NSObject<SDLTransport>*)getTransport;
-(NSObject<SDLInterfaceProtocol>*)getProtocol;

- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest;
- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest __deprecated_msg("use -putFileStream:withRequest: instead");

@end
