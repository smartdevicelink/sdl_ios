//
//  SDLProtocolDelegateHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleProtocolHandler.h"

#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;

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


#pragma mark - SDLProtocolDelegate

- (void)onProtocolOpened {

}

- (void)onProtocolClosed {
    
}

- (void)onError:(NSString *)info exception:(NSException *)e {

}

- (void)onTransportError:(NSError *)error {

}

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {

}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {

}

@end
