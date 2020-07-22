//  SDLProtocolDelegate.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocol;
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProtocolDelegate <NSObject>

@optional


#pragma mark - Protocol Messages

/// Called when a protocol frame is received.
/// @param msg A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveMessage:(SDLProtocolMessage *)msg;

/// Called when the start service frame succeeds.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param startServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceACK:(SDLProtocolMessage *)startServiceACK;

/// Called when the start service frame fails.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param startServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceNAK:(SDLProtocolMessage *)startServiceNAK;

/// Called when the end service frame succeeds.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param endServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceACK:(SDLProtocolMessage *)endServiceACK;

/// Called when the end service frame fails.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param endServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK;

#pragma mark Secondary Transport Messages

/// Called when the secondary transport registration frame succeeds.
/// @discussion This frame is only sent on the secondary transport
/// @param registerSecondaryTransportACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveRegisterSecondaryTransportACK:(SDLProtocolMessage *)registerSecondaryTransportACK;

/// Called when the secondary transport registration frame fails.
/// @discussion This frame is only sent on the secondary transport
/// @param registerSecondaryTransportNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveRegisterSecondaryTransportNAK:(SDLProtocolMessage *)registerSecondaryTransportNAK;

/// Called when the status or configuration of one or more transports has updated.
/// @discussion This frame is only sent on the primary transport
/// @param transportEventUpdate A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol didReceiveTransportEventUpdate:(SDLProtocolMessage *)transportEventUpdate;

#pragma mark - Transport Lifecycle

/// Called when the transport opens.
/// @param protocol The transport's protocol
- (void)protocolDidOpen:(SDLProtocol *)protocol;

/// Called when the transport closes.
/// @param protocol The transport's protocol
- (void)protocolDidClose:(SDLProtocol *)protocol;

/// Called when the transport errors.
/// @discussion Currently only used by TCP transport.
/// @param error The error
/// @param protocol The transport's protocol
- (void)protocol:(SDLProtocol *)protocol transportDidError:(NSError *)error;

#pragma mark - Deprecated Protocol Messages

/// A ping packet that is sent to ensure the connection is still active and the service is still valid.
/// @discussion Deprecated - requires protocol major version 3
/// @param session The session number
- (void)handleHeartbeatForSession:(Byte)session;

/// Called when the heartbeat frame was recieved successfully.
/// @discussion Deprecated - requires protocol major version 3
- (void)handleHeartbeatACK;



@end

NS_ASSUME_NONNULL_END
