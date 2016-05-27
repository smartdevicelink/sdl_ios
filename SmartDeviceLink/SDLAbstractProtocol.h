//  SDLAbstractProtocol.h
//

@class SDLAbstractTransport;
@class SDLRPCMessage;
@class SDLRPCRequest;

#import "SDLProtocolListener.h"
#import "SDLSecurityType.h"
#import "SDLTransportDelegate.h"


@interface SDLAbstractProtocol : NSObject <SDLTransportDelegate>

@property (strong) NSString *debugConsoleGroupName;
@property (weak) SDLAbstractTransport *transport;
@property (strong) NSHashTable *protocolDelegateTable; // table of id<SDLProtocolListener>
@property (nonatomic, strong) id<SDLSecurityType> securityManager;
@property (nonatomic, copy) NSString *appId;

// Sending
- (void)sendStartSessionWithType:(SDLServiceType)serviceType __deprecated_msg(("Use startServiceWithType: instead"));
- (void)startServiceWithType:(SDLServiceType)serviceType;
- (void)startSecureServiceWithType:(SDLServiceType)serviceType completionHandler:(void (^)(BOOL success, NSError *error))completionHandler;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType __deprecated_msg(("Use endServiceWithType: instead"));
- (void)endServiceWithType:(SDLServiceType)serviceType;
- (void)sendRPC:(SDLRPCMessage *)message;
- (BOOL)sendRPC:(SDLRPCMessage *)message encrypted:(BOOL)encryption error:(NSError **)error;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest __deprecated_msg(("Use sendRPC: instead"));
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;
- (void)sendEncryptedRawData:(NSData *)data onService:(SDLServiceType)serviceType;

- (void)sendRawDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType __deprecated_msg("This is not implemented and will cause a crash if called");
- (void)sendHeartbeat __deprecated_msg("This is not implemented and will cause a crash if called");

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)dispose;

@end
