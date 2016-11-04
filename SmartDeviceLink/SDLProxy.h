//  SDLProxy.h
//

@class SDLAbstractProtocol;
@class SDLAbstractTransport;
@class SDLProtocol;
@class SDLPutFile;
@class SDLRPCMessage;
@class SDLRPCRequestFactory;
@class SDLStreamingMediaManager;
@class SDLTimer;

#import "SDLProtocolListener.h"
#import "SDLProxyListener.h"
#import "SDLSecurityType.h"

__deprecated_msg("Use SDLManager instead")
    @interface SDLProxy : NSObject<SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
    Byte _bulkSessionID;
    BOOL _isConnected;
    BOOL _alreadyDestructed;
}

@property (strong) SDLAbstractProtocol *protocol;
@property (strong) SDLAbstractTransport *transport;
@property (readonly, copy) NSSet *proxyListeners;
@property (strong) SDLTimer *startSessionTimer;
@property (copy) NSString *debugConsoleGroupName;
@property (readonly, copy) NSString *proxyVersion;
@property (nonatomic, strong, readonly) SDLStreamingMediaManager *streamingMediaManager;

- (id)initWithTransport:(SDLAbstractTransport *)transport
               protocol:(SDLAbstractProtocol *)protocol
               delegate:(NSObject<SDLProxyListener> *)delegate;
- (void)dispose;

- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate;
- (void)removeDelegate:(NSObject<SDLProxyListener> *)delegate;

- (void)sendRPC:(SDLRPCMessage *)message;
- (void)sendRPCRequest:(SDLRPCMessage *)msg __deprecated_msg("use -sendRPC: instead");

- (void)handleRPCDictionary:(NSDictionary *)dictionary;
- (void)handleRpcMessage:(NSDictionary *)msg __deprecated_msg("use -handleRPCDictionary: instead");

- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;

- (void)addSecurityManagers:(NSArray<Class> *)securityManagerClasses forAppId:(NSString *)appId;

+ (void)enableSiphonDebug;
+ (void)disableSiphonDebug;

/**
 * Puts data into a file on the module
 * @abstract Performs a putFile for a given input stream, performed in chunks, for handling very large files.
 * @param inputStream A stream containing the data to put to the module.
 * @param putFileRPCRequest A SDLPutFile object containing the parameters for the put(s)
 * @discussion  The proxy will read from the stream based on the max MTU size and send them in individual putFile requests.
 * This may result in multiple responses being received, one for each request.
 * Note: the length parameter of the putFileRPCRequest will be ignored. The proxy will substitute the number of bytes read from the stream.
 */
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end
