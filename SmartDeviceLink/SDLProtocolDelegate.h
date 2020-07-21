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
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg protocol:(SDLProtocol *)protocol;

/// Called when the start service frame succeeds.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param startServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK protocol:(SDLProtocol *)protocol;

/// Called when the start service frame fails.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param startServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK protocol:(SDLProtocol *)protocol;

/// Called when the end service frame succeeds.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param endServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK protocol:(SDLProtocol *)protocol;

/// Called when the end service frame fails.
/// @discussion This frame can be sent on both the primary and secondary transports
/// @param endServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK protocol:(SDLProtocol *)protocol;

#pragma mark Secondary Transport Messages

/// Called when the secondary transport registration frame succeeds.
/// @discussion This frame is only sent on the secondary transport
/// @param registerSecondaryTransportACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolRegisterSecondaryTransportACKMessage:(SDLProtocolMessage *)registerSecondaryTransportACK protocol:(SDLProtocol *)protocol;

/// Called when the secondary transport registration frame fails.
/// @discussion This frame is only sent on the secondary transport
/// @param registerSecondaryTransportNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolRegisterSecondaryTransportNAKMessage:(SDLProtocolMessage *)registerSecondaryTransportNAK protocol:(SDLProtocol *)protocol;

/// Called when the status or configuration of one or more transports has updated.
/// @discussion This frame is only sent on the primary transport
/// @param transportEventUpdate A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate protocol:(SDLProtocol *)protocol;

#pragma mark Deprecated Messages

/// A ping packet that is sent to ensure the connection is still active and the service is still valid.
/// @discussion Deprecated - requires protocol major version 3
/// @param session The session number
- (void)handleHeartbeatForSession:(Byte)session;

/// Called when the heartbeat frame was recieved successfully.
/// @discussion Deprecated - requires protocol major version 3
- (void)handleHeartbeatACK;

#pragma mark - Transport Lifecycle

/// Called when the transport opens.
/// @param protocol The transport's protocol
- (void)onProtocolOpened:(SDLProtocol *)protocol;

/// Called when the transport closes.
/// @param protocol The transport's protocol
- (void)onProtocolClosed:(SDLProtocol *)protocol;

/// Called when the transport errors.
/// @discussion Currently only used by TCP transport.
/// @param error The error
/// @param protocol The transport's protocol
- (void)onTransportError:(NSError *)error protocol:(SDLProtocol *)protocol;


@end

NS_ASSUME_NONNULL_END
