//  SDLProtocol.h
//



#import "SDLProtocolListener.h"
#import "SDLProtocolMessage.h"
#import "SDLRPCRequest.h"
#import "SDLTransport.h"
#import "SDLTransportDelegate.h"

@protocol SDLInterfaceProtocol<SDLTransportDelegate>

@property (weak) id<SDLProtocolListener> protocolDelegate;
@property (strong) id<SDLTransport> transport;

- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)sendStartSessionWithType:(SDLServiceType)sessionType;
- (void)sendEndSessionWithType:(SDLServiceType)sessionType sessionID:(Byte)sessionID;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest;

@end