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

@interface SDLConnection() <SDLProtocolListener, SDLTransportDelegate>

@property (strong, nonatomic) SDLProtocol* protocol;
@property (strong, nonatomic) SDLAbstractTransport* transport;
@property (strong, nonatomic) NSArray* sessions;

@end

@implementation SDLConnection

-(instancetype)initWithTransportConfig:(SDLBaseTransportConfig*)transportConfig{
    self = [super init];
    
    if (transportConfig.transportType == SDLTransportTypeiAP) {
        _transport = [SDLIAPTransport new];
    }
    else if (transportConfig.transportType == SDLTransportTypeTCP){
        _transport = [[SDLTCPTransport alloc] initWithTransportConfig:transportConfig delegate:self];
    }
    
    if (self) {
        if (_protocol) {
            _protocol = nil;
        }
        _protocol = [SDLProtocol new];
        _protocol.protocolDelegate = self;
    }
    return self;
}

-(NSArray*)sessions{
    if (_sessions) {
        _sessions = [NSArray new];
    }
    return _sessions;
}

-(NSUInteger)sessionCount{
    return [self.sessions count];
}

-(void)startHandShake{
    if (_protocol) {
        [_protocol sendStartSessionWithType:SDLServiceType_RPC];
    }
}

-(SDLTransportType)currentTransportType{
    return _transport.transportType;
}

-(NSString*)notificationComment{
    if (!_transport) {
        return @"";
    }
    return [_transport notificationComment];
}

#pragma mark SDLProtocolListener

- (void)handleProtocolSessionStarted:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version{
    //TODO: This needs a correlationID
    [self.delegate protocolSessionDidStart:serviceType sessionID:sessionID version:version correlationID:nil];
}

- (void)onProtocolMessageReceived:(SDLProtocolMessage *)msg{
    [self.delegate protocolMessageDidReceive:msg];
}

- (void)onProtocolOpened{
    
}

- (void)onProtocolClosed{
    
}

- (void)onError:(NSString *)info exception:(NSException *)e{
    [self.delegate protocolDidFailWithError:info exception:e];
}

#pragma mark SDLTransportDelegate

- (void)onTransportConnected{
    if (_protocol) {
        for (SDLSession* session in self.sessions) {
            if (session.sessionID == 0) {
                [self startHandShake];
            }
        }
    }
}

- (void)onTransportDisconnected{
    [self.delegate transportDisconnected];
}

- (void)onDataReceived:(NSData *)receivedData{
    
}

@end
