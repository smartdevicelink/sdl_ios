//  SDLProtocolListener.h
//

#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;


@protocol SDLProtocolListener <NSObject>

@optional
- (void)handleProtocolStartSessionACK:(SDLServiceType)serviceType sessionID:(Byte)sessionID hashID:(UInt32)hashID version:(Byte)version;
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
