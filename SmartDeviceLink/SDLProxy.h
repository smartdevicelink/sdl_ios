//  SDLProxy.h
//

@class SDLEncryptionLifecycleManager;
@class SDLProtocol;
@class SDLPutFile;
@class SDLRPCMessage;
@class SDLSecondaryTransportManager;
@class SDLStreamingMediaManager;
@class SDLTimer;

#import "SDLProtocolDelegate.h"
#import "SDLProxyListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportType.h"

NS_ASSUME_NONNULL_BEGIN

@interface SDLProxy : NSObject <SDLProtocolDelegate, NSStreamDelegate> {
    Byte _version;
    Byte _bulkSessionID;
    BOOL _isConnected;
}

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
 *  Creates a SDLProxy object with an iap (USB / Bluetooth) transport network connection.
 *
 *  @param delegate                    The subscriber
 *  @param secondaryTransportManager   The secondary transport manager
 *  @param encryptionLifecycleManager  The encryption life cycle manager
 *  @return                            A SDLProxy object
 */
+ (SDLProxy *)iapProxyWithListener:(id<SDLProxyListener>)delegate secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager encryptionLifecycleManager:(SDLEncryptionLifecycleManager *)encryptionLifecycleManager;

/**
 *  Creates a SDLProxy object with a TCP (WiFi) transport network connection.
 *
 *  @param delegate                    The subscriber
 *  @param ipaddress                   The IP address of Core
 *  @param port                        The port address of Core
 *  @param secondaryTransportManager   The secondary transport manager
 *  @param encryptionLifecycleManager  The encryption life cycle manager
 *  @return                            A SDLProxy object
 */
+ (SDLProxy *)tcpProxyWithListener:(id<SDLProxyListener>)delegate tcpIPAddress:(NSString *)ipaddress tcpPort:(NSString *)port secondaryTransportManager:(nullable SDLSecondaryTransportManager *)secondaryTransportManager encryptionLifecycleManager:(SDLEncryptionLifecycleManager *)encryptionLifecycleManager;

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

/// Disconnects the current app session, including the security manager and primary transport.
- (void)disconnectSession;

@end

NS_ASSUME_NONNULL_END
