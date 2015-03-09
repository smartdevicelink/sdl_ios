//  SDLProxy.h
//

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

- (void)sendRPC:(SDLRPCMessage *)message;
-(void) sendRPCRequest:(SDLRPCMessage*) msg __deprecated_msg("use -sendRPC: instead");

- (void)handleRPCDictionary:(NSDictionary *)dictionary;
-(void) handleRpcMessage:(NSDictionary*) msg __deprecated_msg("use -handleRPCDictionary: instead");

-(NSString*) getProxyVersion;

-(void) destroyHandshakeTimer;
-(void) handleProtocolMessage:(SDLProtocolMessage*) msgData;

+(void)enableSiphonDebug;
+(void)disableSiphonDebug;

-(NSObject<SDLTransport>*)getTransport;
-(NSObject<SDLInterfaceProtocol>*)getProtocol;

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
- (void)putFileStream:(NSInputStream*)inputStream :(SDLPutFile*)putFileRPCRequest __deprecated_msg("use -putFileStream:withRequest: instead");

@end
