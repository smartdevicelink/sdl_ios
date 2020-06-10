//
//  SDLProtocolDelegateHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleProtocolHandler.h"

#import "SDLControlFramePayloadRPCStartService.h"
#import "SDLGlobals.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLTimer.h"

static const float StartSessionTime = 10.0;

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;

@property (strong, nonatomic) SDLTimer *rpcStartServiceTimeoutTimer;

@end

@implementation SDLLifecycleProtocolHandler

- (instancetype)initWithProtocol:(SDLProtocol *)protocol notificationDispatcher:(SDLNotificationDispatcher *)notificationDispatcher {
    self = [super init];
    if (!self) { return nil; }

    _protocol = protocol;
    _notificationDispatcher = notificationDispatcher;

    [_protocol.protocolDelegateTable addObject:self];

    return self;
}

- (void)start {
    [self.protocol start];
}

- (void)stop {
    [self.protocol stop];
}


#pragma mark - SDLProtocolDelegate

- (void)onProtocolOpened {
    SDLControlFramePayloadRPCStartService *startServicePayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:SDLMaxProxyProtocolVersion];
    [self.protocol startServiceWithType:SDLServiceTypeRPC payload:startServicePayload.data];

    if (self.rpcStartServiceTimeoutTimer == nil) {
        self.rpcStartServiceTimeoutTimer = [[SDLTimer alloc] initWithDuration:StartSessionTime repeat:NO];
        __weak typeof(self) weakSelf = self;
        self.rpcStartServiceTimeoutTimer.elapsedBlock = ^{
            SDLLogE(@"Start session timed out after %f, closing the connection.", StartSessionTime);
            [weakSelf performSelector:@selector(onProtocolClosed) withObject:nil afterDelay:0.1];
        };
    }
    [self.rpcStartServiceTimeoutTimer start];
}

- (void)onProtocolClosed {
    
}

- (void)onError:(NSString *)info exception:(NSException *)e {

}

- (void)onTransportError:(NSError *)error {

}

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    [self.rpcStartServiceTimeoutTimer cancel];
    SDLLogV(@"StartSession (response)\nSessionId: %d for serviceType %d", startServiceACK.header.sessionID, startServiceACK.header.serviceType);

    if (startServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self sdl_postNotificationName:SDLTransportDidConnect infoObject:nil];
        [self sdl_postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {

}

#pragma mark - Utilities

- (void)sdl_postNotificationName:(NSString *)name infoObject:(nullable id)infoObject {
    NSDictionary<NSString *, id> *userInfo = nil;
    if (infoObject != nil) {
        userInfo = @{SDLNotificationUserInfoObject: infoObject};
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:name object:self userInfo:userInfo];
}

@end
