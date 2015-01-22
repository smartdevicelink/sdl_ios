//  SDLAbstractProtocol.h
//
//  

#import <Foundation/Foundation.h>
#import "SDLRPCRequest.h"
#import "SDLTransport.h"
#import "SDLProtocolListener.h"


@interface SDLAbstractProtocol : NSObject <SDLTransportDelegate>

@property (strong) NSString *debugConsoleGroupName;
@property (strong) id<SDLTransport> transport;
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

@end
