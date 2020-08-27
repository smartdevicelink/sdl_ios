//
//  SDLProtocolDelegateHandler.m
//  SmartDeviceLink
//
//  Created by Joel Fischer on 6/10/20.
//  Copyright © 2020 smartdevicelink. All rights reserved.
//

#import "SDLLifecycleProtocolHandler.h"

#import "SDLConfiguration.h"
#import "SDLControlFramePayloadRPCStartService.h"
#import "SDLError.h"
#import "SDLGlobals.h"
#import "SDLLifecycleConfiguration.h"
#import "SDLLifecycleRPCAdapter.h"
#import "SDLLogMacros.h"
#import "SDLNotificationConstants.h"
#import "SDLNotificationDispatcher.h"
#import "SDLProtocol.h"
#import "SDLProtocolHeader.h"
#import "SDLProtocolMessage.h"
#import "SDLRPCFunctionNames.h"
#import "SDLRPCMessage.h"
#import "SDLRPCMessageType.h"
#import "SDLTimer.h"

static const float StartSessionTime = 10.0;

NS_ASSUME_NONNULL_BEGIN

@interface SDLLifecycleProtocolHandler ()

@property (weak, nonatomic) SDLNotificationDispatcher *notificationDispatcher;

@property (strong, nonatomic) SDLTimer *rpcStartServiceTimeoutTimer;
@property (copy, nonatomic) NSString *appId;

@end

@implementation SDLLifecycleProtocolHandler

- (instancetype)initWithProtocol:(SDLProtocol *)protocol notificationDispatcher:(SDLNotificationDispatcher *)notificationDispatcher configuration:(SDLConfiguration *)configuration {
    self = [super init];
    if (!self) { return nil; }

    _protocol = protocol;
    _notificationDispatcher = notificationDispatcher;

    _appId = configuration.lifecycleConfig.fullAppId ? configuration.lifecycleConfig.fullAppId : configuration.lifecycleConfig.appId;
    _protocol.appId = _appId;

    [_protocol.protocolDelegateTable addObject:self];

    return self;
}

- (void)start {
    [self.protocol start];
}

- (void)stopWithCompletionHandler:(void (^)(void))disconnectCompletionHandler {
    [self.protocol stopWithCompletionHandler:^{
        disconnectCompletionHandler();
    }];
}


#pragma mark - SDLProtocolDelegate

/// Called when the transport is opened. We will send the RPC Start Service and wait for the RPC Start Service ACK
- (void)protocolDidOpen:(SDLProtocol *)protocol {
    if (self.protocol != protocol) { return; }

    SDLLogD(@"Transport opened, sending an RPC Start Service, and starting timer for RPC Start Service ACK to be received.");
    [self.notificationDispatcher postNotificationName:SDLTransportDidConnect infoObject:nil];

    SDLControlFramePayloadRPCStartService *startServicePayload = [[SDLControlFramePayloadRPCStartService alloc] initWithVersion:SDLMaxProxyProtocolVersion];
    [self.protocol startServiceWithType:SDLServiceTypeRPC payload:startServicePayload.data];

    if (self.rpcStartServiceTimeoutTimer == nil) {
        self.rpcStartServiceTimeoutTimer = [[SDLTimer alloc] initWithDuration:StartSessionTime repeat:NO];
        __weak typeof(self) weakSelf = self;
        self.rpcStartServiceTimeoutTimer.elapsedBlock = ^{
            SDLLogE(@"Start session timed out after %f seconds, closing the connection.", StartSessionTime);
            [weakSelf.protocol stopWithCompletionHandler:^{}];
        };
    }
    [self.rpcStartServiceTimeoutTimer start];
}

/// Called when the transport is closed.
- (void)protocolDidClose:(SDLProtocol *)protocol {
    if (self.protocol != protocol) { return; }

    SDLLogW(@"Transport disconnected");
    [self.notificationDispatcher postNotificationName:SDLTransportDidDisconnect infoObject:nil];
}

- (void)protocol:(SDLProtocol *)protocol transportDidError:(NSError *)error {
    if (self.protocol != protocol) { return; }

    SDLLogW(@"Transport error: %@", error);
    [self.notificationDispatcher postNotificationName:SDLTransportConnectError infoObject:error];
}

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceACK:(SDLProtocolMessage *)startServiceACK {
    if (self.protocol != protocol) { return; }

    SDLLogD(@"Start Service (ACK) SessionId: %d for serviceType %d", startServiceACK.header.sessionID, startServiceACK.header.serviceType);

    if (startServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self.rpcStartServiceTimeoutTimer cancel];
        [self.notificationDispatcher postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
    }
}

- (void)protocol:(SDLProtocol *)protocol didReceiveStartServiceNAK:(SDLProtocolMessage *)startServiceNAK {
    if (self.protocol != protocol) { return; }

    SDLLogD(@"Start Service (NAK): SessionId: %d for serviceType %d", startServiceNAK.header.sessionID, startServiceNAK.header.serviceType);

    if (startServiceNAK.header.serviceType == SDLServiceTypeRPC) {
        [self.rpcStartServiceTimeoutTimer cancel];
        [self.notificationDispatcher postNotificationName:SDLRPCServiceConnectionDidError infoObject:nil];
    }
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceACK:(SDLProtocolMessage *)endServiceACK {
    if (self.protocol != protocol) { return; }

    SDLLogD(@"End Service (ACK): SessionId: %d for serviceType %d", endServiceACK.header.sessionID, endServiceACK.header.serviceType);

    if (endServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self.rpcStartServiceTimeoutTimer cancel];
        [self.notificationDispatcher postNotificationName:SDLRPCServiceDidDisconnect infoObject:nil];
    }
}

- (void)protocol:(SDLProtocol *)protocol didReceiveEndServiceNAK:(SDLProtocolMessage *)endServiceNAK {
    if (self.protocol != protocol) { return; }

    if (endServiceNAK.header.serviceType == SDLServiceTypeRPC) {
        NSError *error = [NSError sdl_lifecycle_unknownRemoteErrorWithDescription:@"RPC Service failed to stop" andReason:nil];
        [self.notificationDispatcher postNotificationName:SDLRPCServiceConnectionDidError infoObject:error];
    }
}

- (void)protocol:(SDLProtocol *)protocol didReceiveMessage:(SDLProtocolMessage *)msg {
    if (self.protocol != protocol) { return; }

    NSDictionary<NSString *, id> *rpcMessageAsDictionary = [msg rpcDictionary];
    SDLRPCMessage *receivedMessage = [[SDLRPCMessage alloc] initWithDictionary:rpcMessageAsDictionary];
    NSString *fullName = [self sdl_fullNameForMessage:receivedMessage];

    // From the function name, create the corresponding RPCObject and initialize it
    NSString *functionClassName = [NSString stringWithFormat:@"SDL%@", fullName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:rpcMessageAsDictionary];

    // If we were unable to create the message, it's an unknown type; discard it
    if (newMessage == nil) { return; }

    // Adapt the incoming message then call the callback
    NSArray<SDLRPCMessage *> *adaptedMessages = [SDLLifecycleRPCAdapter adaptRPC:newMessage direction:SDLRPCDirectionIncoming];
    for (SDLRPCMessage *message in adaptedMessages) {
        [self sdl_sendCallbackForMessage:message];
    }
}

#pragma mark - Utilities

- (void)sdl_sendCallbackForMessage:(SDLRPCMessage *)message {
    // Log the RPC message
    SDLLogV(@"Sending callback for RPC message: %@", message);

    SDLNotificationName notificationName = [self sdl_notificationNameForMessage:message];
    if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameResponse]) {
        [self.notificationDispatcher postRPCResponseNotification:notificationName response:(SDLRPCResponse *)message];
    } else if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameRequest]) {
        [self.notificationDispatcher postRPCRequestNotification:notificationName request:(SDLRPCRequest *)message];
    } else if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameNotification]) {
        [self.notificationDispatcher postRPCNotificationNotification:notificationName notification:(SDLRPCNotification *)message];
    }
}

- (SDLNotificationName)sdl_notificationNameForMessage:(SDLRPCMessage *)message {
    NSString *messageName = message.name;
    if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameResponse]) {
        return [NSString stringWithFormat:@"com.sdl.response.%@", messageName];
    } else if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameRequest]) {
        return [NSString stringWithFormat:@"com.sdl.request.%@", messageName];
    } else if ([message.messageType isEqualToEnum:SDLRPCMessageTypeNameNotification]) {
        return [NSString stringWithFormat:@"com.sdl.notification.%@", messageName];
    }

    return messageName;
}

- (NSString *)sdl_fullNameForMessage:(SDLRPCMessage *)message {
    NSString *functionName = message.name;
    NSString *messageType = message.messageType;

    // If it's a response, append "response"
    if ([messageType isEqualToEnum:SDLRPCMessageTypeNameResponse]) {
        if (![functionName isEqualToEnum:SDLRPCFunctionNameGenericResponse]) {
            functionName = [NSString stringWithFormat:@"%@Response", functionName];
        }
    }

    return functionName;
}

@end

NS_ASSUME_NONNULL_END
