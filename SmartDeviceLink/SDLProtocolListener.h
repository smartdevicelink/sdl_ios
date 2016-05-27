//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;


@protocol SDLProtocolListener <NSObject>

@optional
- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version __deprecated_msg("use handleProtocolStartSessionACK: instead");
- (void)handleProtocolStartSessionACK:(SDLProtocolHeader *)header;
- (void)handleProtocolStartSessionNACK:(SDLServiceType)serviceType;
- (void)handleProtocolEndSessionACK:(SDLServiceType)serviceType;
- (void)handleProtocolEndSessionNACK:(SDLServiceType)serviceType;
- (void)handleHeartbeatForSession:(Byte)session;
- (void)handleHeartbeatACK;
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg;
- (void)onProtocolOpened;
- (void)onProtocolClosed;
- (void)onError:(NSString *)info exception:(NSException *)e;

@end
