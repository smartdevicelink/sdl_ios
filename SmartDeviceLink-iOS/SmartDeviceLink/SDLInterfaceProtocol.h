//  SDLProtocol.h
//

#import "SDLProtocolListener.h"
#import "SDLTransport.h"
#import "SDLTransportDelegate.h"

@class SDLProtocolMessage;
@class SDLRPCMessage;
@class SDLRPCRequest;


@protocol SDLInterfaceProtocol <SDLTransportDelegate>

@property (weak) id<SDLProtocolListener> protocolDelegate;
@property (strong) id<SDLTransport> transport;

- (void)handleBytesFromTransport:(NSData *)receivedData;
- (void)sendStartSessionWithType:(SDLServiceType)sessionType;
- (void)sendEndSessionWithType:(SDLServiceType)sessionType sessionID:(Byte)sessionID;
- (void)sendRPCRequest:(SDLRPCRequest *)rpcRequest __deprecated_msg("use -sendRPC: instead");
- (void)sendRPC:(SDLRPCMessage *)message;

@end