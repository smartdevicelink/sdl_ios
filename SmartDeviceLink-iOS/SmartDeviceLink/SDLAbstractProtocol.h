//  SDLAbstractProtocol.h
//



#import "SDLInterfaceProtocol.h"
#import "SDLTransport.h"
#import "SDLProtocolListener.h"


@interface SDLAbstractProtocol : NSObject <SDLTransportDelegate>

@property (strong) NSString *debugConsoleGroupName;
@property (weak) SDLAbstractTransport *transport;
@property (weak) id<SDLProtocolListener> protocolDelegate;

// Sending
- (void)sendStartSessionWithType:(SDLServiceType)serviceType;
- (void)sendEndSessionWithType:(SDLServiceType)serviceType;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest;
- (void)sendHeartbeat;
- (void)sendRawDataStream:(NSInputStream *)inputStream withServiceType:(SDLServiceType)serviceType;
- (void)sendRawData:(NSData *)data withServiceType:(SDLServiceType)serviceType;

// Recieving
- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)dispose;

@end
