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
#import "SDLGlobals.h"
#import "SDLLifecycleConfiguration.h"
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

- (void)stop {
    [self.protocol stop];
}


#pragma mark - SDLProtocolDelegate

/// Called when the transport is opened. We will send the RPC Start Service and wait for the RPC Start Service ACK
- (void)onProtocolOpened {
    [self sdl_postNotificationName:SDLTransportDidConnect infoObject:nil];

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

/// Called when the transport is closed.
- (void)onProtocolClosed {
    [self sdl_postNotificationName:SDLTransportDidDisconnect infoObject:nil];
}

- (void)onTransportError:(NSError *)error {
    [self sdl_postNotificationName:SDLTransportConnectError infoObject:error];
}

- (void)handleProtocolStartServiceACKMessage:(SDLProtocolMessage *)startServiceACK {
    [self.rpcStartServiceTimeoutTimer cancel];
    SDLLogD(@"Start Service (response)\nSessionId: %d for serviceType %d", startServiceACK.header.sessionID, startServiceACK.header.serviceType);

    if (startServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self sdl_postNotificationName:SDLRPCServiceDidConnect infoObject:nil];
    }
}

- (void)handleProtocolStartServiceNAKMessage:(SDLProtocolMessage *)startServiceNAK {
    [self.rpcStartServiceTimeoutTimer cancel];
    SDLLogD(@"Start Service (response)\nSessionId: %d for serviceType %d", startServiceNAK.header.sessionID, startServiceNAK.header.serviceType);

    if (startServiceNAK.header.serviceType == SDLServiceTypeRPC) {
        [self sdl_postNotificationName:SDLRPCServiceConnectionDidError infoObject:nil];
    }
}

- (void)handleProtocolEndServiceACKMessage:(SDLProtocolMessage *)endServiceACK {
    [self.rpcStartServiceTimeoutTimer cancel];
    SDLLogD(@"End Service (response)\nSessionId: %d for serviceType %d", endServiceACK.header.sessionID, endServiceACK.header.serviceType);

    if (endServiceACK.header.serviceType == SDLServiceTypeRPC) {
        [self sdl_postNotificationName:SDLRPCServiceDidDisconnect infoObject:nil];
    }
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg {
    NSDictionary<NSString *, id> *rpcMessageAsDictionary = [msg rpcDictionary];
    SDLRPCMessage *message = [[SDLRPCMessage alloc] initWithDictionary:rpcMessageAsDictionary];
    NSString *functionName = message.name;
    NSString *messageType = message.messageType;

    // If it's a response, append "response"
    if ([messageType isEqualToString:SDLRPCMessageTypeNameResponse]) {
        BOOL notGenericResponseMessage = ![functionName isEqualToString:SDLRPCFunctionNameGenericResponse];
        if (notGenericResponseMessage) {
            functionName = [NSString stringWithFormat:@"%@Response", functionName];
        }
    }

    // From the function name, create the corresponding RPCObject and initialize it
    NSString *functionClassName = [NSString stringWithFormat:@"SDL%@", functionName];
    SDLRPCMessage *newMessage = [[NSClassFromString(functionClassName) alloc] initWithDictionary:rpcMessageAsDictionary];

    // Log the RPC message
    SDLLogV(@"Message received: %@", newMessage);

    // Intercept and handle several messages ourselves

//    if ([functionName isEqualToString:@"RegisterAppInterfaceResponse"]) {
//        [self handleRegisterAppInterfaceResponse:(SDLRPCResponse *)newMessage];
//    }
//
//    if ([functionName isEqualToString:SDLRPCFunctionNameOnButtonPress]) {
//        SDLOnButtonPress *message = (SDLOnButtonPress *)newMessage;
//        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
//            BOOL handledRPC = [self sdl_handleOnButtonPressPostV5:message];
//            if (handledRPC) { return; }
//        } else { // RPC version of 4 or less (connected to an old head unit)
//            BOOL handledRPC = [self sdl_handleOnButtonPressPreV5:message];
//            if (handledRPC) { return; }
//        }
//    }
//
//    if ([functionName isEqualToString:SDLRPCFunctionNameOnButtonEvent]) {
//        SDLOnButtonEvent *message = (SDLOnButtonEvent *)newMessage;
//        if ([SDLGlobals sharedGlobals].rpcVersion.major >= 5) {
//            BOOL handledRPC = [self sdl_handleOnButtonEventPostV5:message];
//            if (handledRPC) { return; }
//        } else {
//            BOOL handledRPC = [self sdl_handleOnButtonEventPreV5:message];
//            if (handledRPC) { return; }
//        }
//    }

    SEL callbackSelector = NSSelectorFromString([NSString stringWithFormat:@"on%@", functionName]);
    ((void (*)(id, SEL, id))[(NSObject *)self.notificationDispatcher methodForSelector:callbackSelector])(self.notificationDispatcher, callbackSelector, newMessage);
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
