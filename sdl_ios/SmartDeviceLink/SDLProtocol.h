//  SDLSmartDeviceLinkProtocol.h
//
//  

#import "SDLAbstractProtocol.h"
@class SDLProtocolHeader;
@class SDLProtocolRecievedMessageRouter;


@interface SDLProtocol : SDLAbstractProtocol <SDLProtocolListener>

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
