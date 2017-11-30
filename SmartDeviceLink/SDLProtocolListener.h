//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;

NS_ASSUME_NONNULL_BEGIN

@protocol SDLProtocolListener <NSObject>

@optional
// v4.7.0 protocol handlers
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK;
- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK;
- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK;
- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK;

// Older protocol handlers
- (void)handleHeartbeatForSession:(Byte)session;
- (void)handleHeartbeatACK;
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg;
- (void)onProtocolOpened;
- (void)onProtocolClosed;
- (void)onError:(NSString *)info exception:(NSException *)e;

@end

NS_ASSUME_NONNULL_END
