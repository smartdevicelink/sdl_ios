//  SDLAbstractProtocol.h
//

@class SDLAbstractTransport;
@class SDLRPCMessage;
@class SDLRPCRequest;

#import "SDLProtocolListener.h"
#import "SDLTransportDelegate.h"


@interface SDLAbstractProtocol : NSObject <SDLTransportDelegate>

@property (strong) NSString *debugConsoleGroupName;
@property (weak) SDLAbstractTransport *transport;
@property (strong) NSHashTable *protocolDelegateTable; // table of id<SDLProtocolListener>

// Sending
- (void)sendStartSessionWithType:(SDLServiceType)serviceType __deprecated_msg("Use startServiceWithType: instead");
- (void)sendStartServiceWithType:(SDLServiceType)serviceType;
- (BOOL)sendStartServiceWithType:(SDLServiceType)serviceType encryption:(BOOL)encryption;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType;
- (void)sendRPC:(SDLRPCMessage *)message;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest __deprecated_msg("Use sendRPC: instead");
- (void)sendHeartbeat;
- (void)sendRawDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType __deprecated_msg("Use sendRawData: instead");
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)dispose;

@end
