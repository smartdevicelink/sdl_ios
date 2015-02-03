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

-(void) sendRPCRequest:(SDLRPCMessage*) msg;
-(void) handleRpcMessage:(NSDictionary*) msg;

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLProtocolMessage*) msgData;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;

-(NSObject<SDLTransport>*)getTransport;
-(NSObject<SDLInterfaceProtocol>*)getProtocol;

- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest __deprecated_msg("use -putFileStream:withRequest: instead");
/**
 * Puts data into a file on the module
 * @abstract Performs a putFile for a given input stream, performed in chunks, for handling very large files.
 * @param inputStream A stream containing the data to put to the module.
 * @param putFileRPCRequest A SDLPutFile object containing the parameters for the put(s)
 * @discussion  The proxy will read from the stream up to 1024 bytes at a time and send them in individual putFile requests.
 * This may result in multiple responses being recieved, one for each request.
 * Note: the length parameter of the putFileRPCRequest will be ignored. The proxy will substitute the number of bytes read from the stream.
 */
- (void)putFileStream:(NSInputStream*)inputStream withRequest:(SDLPutFile*)putFileRPCRequest;

@end
