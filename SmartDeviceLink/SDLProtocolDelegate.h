//  SDLProtocolDelegate.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocol;
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProtocolDelegate <NSObject>

@optional


#pragma mark - Protocol Messages

/// Called when a protocol message is received.
/// @param msg A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg protocol:(SDLProtocol *)protocol;

/// Called when the start service request succeeds.
/// @param startServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK protocol:(SDLProtocol *)protocol;

/// Called when the start service request fails.
/// @param startServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK protocol:(SDLProtocol *)protocol;

/// Called when the end service request succeeds.
/// @param endServiceACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK protocol:(SDLProtocol *)protocol;

/// Called when the end service request fails.
/// @param endServiceNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK protocol:(SDLProtocol *)protocol;

#pragma mark Secondary Transport Messages

/// Called when the secondary transport registration succeeds.
/// @param registerSecondaryTransportACK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolRegisterSecondaryTransportACKMessage:(SDLProtocolMessage *)registerSecondaryTransportACK protocol:(SDLProtocol *)protocol;

/// Called when the secondary transport registration fails.
/// @param registerSecondaryTransportNAK A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleProtocolRegisterSecondaryTransportNAKMessage:(SDLProtocolMessage *)registerSecondaryTransportNAK protocol:(SDLProtocol *)protocol;

/// Called when the status or configuration of one or more transports has updated.
/// @param transportEventUpdate A SDLProtocolMessage object
/// @param protocol The transport's protocol
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate protocol:(SDLProtocol *)protocol;

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

#pragma mark - Deprecated Protocol Messages

/// A ping packet that is sent to ensure the connection is still active and the service is still valid.
/// @param session The session number
- (void)handleHeartbeatForSession:(Byte)session;

/// Called when the heartbeat message was recieved successfully.
- (void)handleHeartbeatACK;

@end

NS_ASSUME_NONNULL_END
