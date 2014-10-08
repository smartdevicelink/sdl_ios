//  SDLProtocolListener.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>

#import "SDLAppLinkProtocolHeader.h"
@class SDLAppLinkProtocolMessage;

@protocol SDLProtocolListener

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version;
- (void)onProtocolMessageReceived:(SDLAppLinkProtocolMessage *)msg;

- (void)onProtocolOpened;
- (void)onProtocolClosed;
- (void)onError:(NSString *)info exception:(NSException *)e;

@end

