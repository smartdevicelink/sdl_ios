//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;


@protocol SDLProtocolListener <NSObject>

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version;
- (void)handleHeartbeatForSession:(Byte)session;
- (void)handleHeartbeatACK;
- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg;
- (void)onProtocolOpened;
- (void)onProtocolClosed;
- (void)onError:(NSString *)info exception:(NSException *)e;

@end
