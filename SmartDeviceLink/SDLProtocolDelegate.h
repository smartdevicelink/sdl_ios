//  SDLProtocolDelegate.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocol;
@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProtocolDelegate <NSObject>

@optional

#pragma mark - v4.7.0 protocol handlers

/**
 *  Called when the message is a start service success message.
 *
 *  @param startServiceACK  A SDLProtocolMessage object
 */
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK;

/**
 *  Called when the message is a start service failed message.
 *
 *  @param startServiceNAK  A SDLProtocolMessage object
 */
- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK;

/**
 *  Called when the message is a end service success message.
 *
 *  @param endServiceACK   A SDLProtocolMessage object
 */
- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK;

/**
 *  Called when the message is a end service failed message.
 *
 *  @param endServiceNAK   A SDLProtocolMessage object
 */
- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK;
- (void)handleProtocolRegisterSecondaryTransportACKMessage:(SDLProtocolMessage *)registerSecondaryTransportACK;
- (void)handleProtocolRegisterSecondaryTransportNAKMessage:(SDLProtocolMessage *)registerSecondaryTransportNAK;
- (void)handleTransportEventUpdateMessage:(SDLProtocolMessage *)transportEventUpdate;

#pragma mark - Older protocol handlers

/**
 *  Called when the message is a heartbeat message.
 *
 *  @param session Session number
 */
- (void)handleHeartbeatForSession:(Byte)session;

/**
 *  Called when the message is a heartbeat success message.
 */
- (void)handleHeartbeatACK;

/**
 *  Called when the message is protocol message.
 *
 *  @param msg A SDLProtocolMessage object
 */
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg;

/// Called when the transport opens
/// @param protocol The transport's protocol
- (void)onProtocolOpened:(SDLProtocol *)protocol;

/// Called when the transport closes
/// @param protocol The transport's protocol
- (void)onProtocolClosed:(SDLProtocol *)protocol;

/// Called when the transport errors.
/// @discussion Currently, this is used only by TCP transport.
/// @param error The error
/// @param protocol The transport's protocol
- (void)onTransportError:(NSError *)error protocol:(SDLProtocol *)protocol;

@end

NS_ASSUME_NONNULL_END
