//  SDLProxy.h
//


#import "SDLProtocol.h"
#import "SDLProxyListener.h"
#import "SDLRPCRequestFactory.h"

@class SDLTimer;

@interface SDLProxy : NSObject <SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
    Byte bulkSessionID;
    BOOL isConnected;
    BOOL _alreadyDestructed;

}

@property (strong) SDLAbstractProtocol *protocol;
@property (strong) SDLAbstractTransport *transport;
@property (strong) NSMutableArray *proxyListeners;
@property (strong) SDLTimer *startSessionTimer;
@property (strong) NSString *debugConsoleGroupName;
@property (readonly) NSString *proxyVersion;

- (id)initWithTransport:(SDLAbstractTransport *)transport
               protocol:(SDLAbstractProtocol *)protocol
               delegate:(NSObject<SDLProxyListener> *)delegate;

- (void)dispose;
- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate;

- (void)sendRPCRequest:(SDLRPCMessage *)msg;
- (void)handleRpcMessage:(NSDictionary *)msg;
- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;

+ (void)enableSiphonDebug;
+ (void)disableSiphonDebug;

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
