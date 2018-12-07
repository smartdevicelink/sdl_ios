//  SDLSmartDeviceLinkProtocol.h
//

#import <Foundation/Foundation.h>

#import "SDLTransportType.h"
#import "SDLProtocolConstants.h"
#import "SDLProtocolListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportDelegate.h"

@class SDLProtocolHeader;
@class SDLProtocolRecievedMessageRouter;
@class SDLRPCMessage;

NS_ASSUME_NONNULL_BEGIN

/**
 *  A protocol error type
 *
 *  - SDLProtocolErrorNoSecurityManager: No security manager was provided
 */
typedef NS_ENUM(NSUInteger, SDLProtocolError) {
    SDLProtocolErrorNoSecurityManager,
};

extern NSString *const SDLProtocolSecurityErrorDomain;


@interface SDLProtocol : NSObject <SDLProtocolListener, SDLTransportDelegate>

/**
 *  Deprecated debug logging tool.
 */
@property (strong, nonatomic) NSString *debugConsoleGroupName;

/**
 *  The transport layer for sending data between the app and Core
 */
@property (nullable, weak, nonatomic) id<SDLTransportType> transport;

/**
 *  A table for tracking all subscribers
 *
 *  If you update protocolDelegateTable while the protocol is running, please make sure to guard with @synchronized.
 */
@property (nullable, strong, nonatomic) NSHashTable<id<SDLProtocolListener>> *protocolDelegateTable;

/**
 *  A security manager for sending encrypted data.
 */
@property (nullable, nonatomic, strong) id<SDLSecurityType> securityManager;

/**
 *  The app's id
 */
@property (nonatomic, copy) NSString *appId;

#pragma mark - Sending

/**
 *  Pre-configure protocol header for specified service type
 *
 *  This is used to initialize Session ID before starting a protocol.
 *
 *  @param header The header which is applied to the service type
 *  @param serviceType A SDLServiceType object
 *  @return YES if the header is successfully set, NO otherwise
 */
- (BOOL)storeHeader:(SDLProtocolHeader *)header forServiceType:(SDLServiceType)serviceType;

/**
 *  Sends a start service message to Core
 *
 *  @param serviceType A SDLServiceType object
 *  @param payload The data to send in the message
 */
- (void)startServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload;

/**
 *  Sends a secure start service message to Core
 *
 *  @param serviceType A SDLServiceType object
 *  @param payload The data to send in the message
 *  @param completionHandler The handler is called when the secure service is started. If a secure service can not be started, an error message is also returned
 */
- (void)startSecureServiceWithType:(SDLServiceType)serviceType payload:(nullable NSData *)payload completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;

/**
 *  Sends an end service message to Core
 *
 *  @param serviceType A SDLServiceType object
 */
- (void)endServiceWithType:(SDLServiceType)serviceType;

/**
 *  Sends a Register Secondary Transport control frame to Core
 */
- (void)registerSecondaryTransport;

/**
 *  Sends an unencrypted RPC to Core
 *
 *  @param message A SDLRPCMessage message
 */
- (void)sendRPC:(SDLRPCMessage *)message;

/**
 *  Sends an RPC to Core
 *
 *  @param message     A SDLRPCMessage message
 *  @param encryption  Whether or not the message should be encrypted
 *  @param error       A pointer to a NSError object
 *  @return            YES if the message was created successfully, NO if not
 */
- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError **)error;

/**
 *  Sends an unencrypted message to Core
 *
 *  @param data The data to send
 *  @param serviceType A SDLServiceType object
 */
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;

/**
 *  Sends an encrypted message to Core
 *
 *  @param data         The data to send
 *  @param serviceType  A SDLServiceType object
 */
- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType;

#pragma mark - Recieving

/**
 *  Turns received bytes into message objects.
 *
 *  @param receivedData The data received from Core
 */
- (void)handleBytesFromTransport:(NSData *)receivedData;

@end

NS_ASSUME_NONNULL_END
