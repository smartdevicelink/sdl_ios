//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;


@protocol SDLProtocolListener <NSObject>

@optional
// v4.7.0 protocol handlers
- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK;
- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK;
- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK;
- (void)handleProtocolEndServiceNAKMessage:(SDLProtocolMessage *)endServiceNAK;

// Older protocol handlers
- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version __deprecated_msg("use handleProtocolStartSessionACKMessage: instead");
- (void)handleProtocolStartSessionACK:(SDLProtocolHeader *)header __deprecated_msg("use handleProtocolStartSessionACKMessage: instead");
- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType __deprecated_msg("use handleProtocolStartSessionNAKMessage: instead");
- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType __deprecated_msg("use handleProtocolEndSessionACKMessage: instead");
- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType __deprecated_msg("use handleProtocolEndSessionNAKMessage: instead");
- (void)handleHeartbeatForSession:(Byte)session;
- (void)handleHeartbeatACK;
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg;
- (void)onProtocolOpened;
- (void)onProtocolClosed;
- (void)onError:(NSString *)info exception:(NSException *)e;

@end
