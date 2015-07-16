//
//  SDLConnection.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLConnection.h"
#import "SDLTransportDelegate.h"
#import "SDLSession.h"
#import "SDLProtocol.h"
#import "SDLBaseTransportConfig.h"
#import "SDLTCPTransport.h"
#import "SDLIAPTransport.h"
#import "SDLProtocolHeader.h"
#import "SDLDebugTool.h"

@interface SDLConnection() <SDLProtocolListener, SDLTransportDelegate>

@property (strong, nonatomic) SDLProtocol* protocol;
@property (strong, nonatomic) SDLAbstractTransport* transport;
@property (strong, nonatomic) NSMutableArray* sessions;
@property (nonatomic) SDLProxyTransportType currentTransportType;
@property (nonatomic, getter=isConnected) BOOL connected;

@end

@implementation SDLConnection

-(instancetype)initWithTransportConfig:(SDLBaseTransportConfig*)transportConfig delegate:(id<SDLConnectionDelegate>)delegate{
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _currentTransportType = transportConfig.transportType;
        
        if (transportConfig.transportType == SDLProxyTransportTypeIAP) {
            _transport = [SDLIAPTransport new];
            _transport.delegate = self;
        }
        else if (transportConfig.transportType == SDLProxyTransportTypeTCP){
            //TODO: This constructor does not exist.
//            _transport = [[SDLTCPTransport alloc] initWithTransportConfig:transportConfig delegate:self];
        }
        _protocol = [SDLProtocol new];
        _protocol.protocolDelegate = self;
        _protocol.transport = _transport;//TODO: Why does the protocol have a reference to the transport in iOS but not Android?
    }
    return self;
}

-(NSMutableArray*)sessions{
    if (!_sessions) {
        _sessions = [NSMutableArray new];
    }
    return _sessions;
}

-(NSUInteger)sessionCount{
    return [self.sessions count];
}

//TODO: This is a object mis-match from Android. Android sends a ProtocolMessage
-(void)sendMessage:(SDLRPCRequest*)message{
    [SDLDebugTool logInfo:[NSString stringWithFormat:@"%@-%@ called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
    [self.protocol sendRPC:message];
}

-(void)startHandShake{
    [SDLDebugTool logInfo:[NSString stringWithFormat:@"%@-%@ called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
    
    if (_protocol) {
        
        [_protocol sendStartSessionWithType:SDLServiceType_RPC];
    }
}

-(void)registerSession:(SDLSession*)session{
    [self.sessions addObject:session];
    
    if (![self isConnected]) {
        [self startTransport];
    }
    else{
        [self startHandShake];
    }
}

-(void)startTransport{
    [_transport connect];
}

-(NSString*)notificationComment{
    if (!_transport) {
        return @"";
    }
    return nil;
    //TODO: Transport does not implement this meathod
//    return [_transport notificationComment];
}

-(void)unregisterSession:(SDLSession*)session{
    [self.sessions removeObject:session];
    [self closeConnection:([self.sessions count] == 0) sessionId:session.sessionID];
}

-(void)closeConnection:(BOOL)willRecycle sessionId:(Byte)sessionId{
    if (self.protocol) {
        if (self.transport && self.isConnected) {
            [self.protocol sendEndSessionWithType:SDLServiceType_RPC sessionID:sessionId];
        }
        if (willRecycle) {
            self.protocol = nil;
        }
    }
    if (willRecycle) {
        if (self.transport) {
            [self.transport disconnect];
        }
        self.transport = nil;
    }
}

-(NSUInteger)registrationCount{
    return [self.sessions count];
}

#pragma mark SDLProtocolListener

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version{
    [self.delegate protocolSessionStarted:serviceType sessionID:sessionID version:version correlationID:nil];
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg{
    [self.delegate protocolMessageReceived:msg];
}

- (void)onProtocolOpened{
    
}

- (void)onProtocolClosed{
    
}

- (void)onError:(NSString *)info exception:(NSException *)e{
    [self.delegate protocolErrorWithInfo:info exception:e];
}

#pragma mark SDLTransportDelegate

- (void)onTransportConnected{
    self.connected = YES;
    [SDLDebugTool logInfo:[NSString stringWithFormat:@"%@-%@ called", NSStringFromClass([self class]), NSStringFromSelector(_cmd)]];
    if (_protocol) {
        for (SDLSession* session in self.sessions) {
            if (session.sessionID == 0) {
                [self startHandShake];
            }
        }
    }
}

- (void)onTransportDisconnected{
    self.connected = NO;
    [self.delegate transportDisconnected];
}

- (void)onDataReceived:(NSData *)receivedData{
    [self.protocol handleBytesFromTransport:receivedData];
}

@end
