//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProtocolListener <NSObject>

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

/**
 *  Called when the message is a protocol opened message.
 */
- (void)onProtocolOpened;

/**
 *  Called when the message is a protocol closed message.
 */
- (void)onProtocolClosed;

/**
 *  Called when the message is an error message.
 *
 *  @param info The error info message
 *  @param e    The exception
 */
- (void)onError:(NSString *)info exception:(NSException *)e;

@end

NS_ASSUME_NONNULL_END
