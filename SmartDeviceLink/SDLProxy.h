//  SDLProxy.h
//

@class SDLProtocol;
@class SDLPutFile;
@class SDLRPCMessage;
@class SDLStreamingMediaManager;
@class SDLTimer;

#import "SDLProtocolListener.h"
#import "SDLProxyListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProxy : NSObject <SDLProtocolListener, NSStreamDelegate> {
    Byte _version;
    Byte _bulkSessionID;
    BOOL _isConnected;
}

/**
 *  The protocol that handles sending and receiving messages from Core.
 */
@property (nullable, strong, nonatomic) SDLProtocol *protocol;

/**
 *  The transport type used to connect the app to Core.
 */
@property (nullable, strong, nonatomic) id<SDLTransportType> transport;

/**
 *  A set of all subscribers.
 */
@property (readonly, copy, nonatomic) NSSet<NSObject<SDLProxyListener> *> *proxyListeners;

/**
 *  Closes an open session if no start service ACK message received from Core within a given amount of time.
 */
@property (strong, nonatomic) SDLTimer *startSessionTimer;

/**
 *  The proxy version number.
 */
@property (readonly, copy, nonatomic) NSString *proxyVersion;

/**
 *  Convenience init.
 *
 *  @param transport   The type of network connection
 *  @param delegate    The subscriber
 *  @return            A SDLProxy object
 */
- (id)initWithTransport:(id<SDLTransportType>)transport delegate:(id<SDLProxyListener>)delegate;

/**
 *  Creates a SDLProxy object with an iap (USB / Bluetooth) transport network connection.
 *
 *  @param delegate    The subscriber
 *  @return            A SDLProxy object
 */
+ (SDLProxy *)iapProxyWithListener:(id<SDLProxyListener>)delegate;

/**
 *  Creates a SDLProxy object with a TCP (WiFi) transport network connection.
 *
 *  @param delegate    The subscriber
 *  @param ipaddress   The IP address of Core
 *  @param port        The port address of Core
 *  @return            A SDLProxy object
 */
+ (SDLProxy *)tcpProxyWithListener:(id<SDLProxyListener>)delegate tcpIPAddress:(NSString *)ipaddress tcpPort:(NSString *)port;

/**
 *  Adds a delegate.
 *
 *  @param delegate The delegate to add
 */
- (void)addDelegate:(NSObject<SDLProxyListener> *)delegate;

/**
 *  Removes a delegate.
 *
 *  @param delegate The delegate to remove
 */
- (void)removeDelegate:(NSObject<SDLProxyListener> *)delegate;

/**
 *  Sends a RPC to Core.
 *
 *  @param message A SDLRPCMessage object
 */
- (void)sendRPC:(SDLRPCMessage *)message;

/**
 * Parses a dictionary object and notifies the subscribed delegates of the messages sent by Core. Some messages are also intercepted and handled by the library.
 *
 *  @param dictionary The message data
 */
- (void)handleRPCDictionary:(NSDictionary<NSString *, id> *)dictionary;

/**
 *  Parses a SDLProtocolMessage object and notifies the subscribed delegates of the messages sent by Core. Some messages are also intercepted and handled by the library.
 *
 *  @param msgData The message data
 */
- (void)handleProtocolMessage:(SDLProtocolMessage *)msgData;

/**
 *  Adds the security manangers needed to send encrypted data.
 *
 *  @param securityManagerClasses  The security manager classes
 *  @param appId                   The app's id
 */
- (void)addSecurityManagers:(NSArray<Class> *)securityManagerClasses forAppId:(NSString *)appId;

/**
 *  Puts data into a file on the module. Performs a putFile for a given input stream, performed in chunks, for handling very large files.
 *
 *  @param inputStream A stream containing the data to put to the module.
 *  @param putFileRPCRequest A SDLPutFile object containing the parameters for the put(s)
 *
 *  @discussion: The proxy will read from the stream based on the max MTU size and send them in individual putFile requests. This may result in multiple responses being received, one for each request.
 *  @note: The length parameter of the putFileRPCRequest will be ignored. The proxy will substitute the number of bytes read from the stream.
 */
- (void)putFileStream:(NSInputStream *)inputStream withRequest:(SDLPutFile *)putFileRPCRequest;

@end

NS_ASSUME_NONNULL_END
