//
//  SDLSession.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLSession.h"
#import "SDLBaseTransportConfig.h"
#import "SDLLockScreenManager.h"
#import "SDLConnection.h"
#import "SDLHeartbeatMonitor.h"

@interface SDLSession() <SDLConnectionDelegate>

@property (strong, nonatomic) SDLConnection* sdlConnection;
@property (nonatomic) Byte wiproProtocolVersion;
@property (weak, nonatomic) id<SDLConnectionDelegate> delegate;
@property (strong, nonatomic) SDLBaseTransportConfig* transportConfig;
@property (strong, nonatomic) NSMutableArray* shareConnections;

@end

@implementation SDLSession

+(instancetype)createSessionWithWiProVersion:(Byte)wiproVersion interfaceBroker:(id<SDLConnectionDelegate>)delegate transportConfig:(SDLBaseTransportConfig *)transportConfig{
    SDLSession* session = [SDLSession new];
    session.wiproProtocolVersion = wiproVersion;
    session.delegate = delegate;
    session.transportConfig = transportConfig;
    return session;
}

-(void)startSession{
    SDLConnection* connection;
    if (self.transportConfig.shareConnection) {
        connection = [self properConnectionForTransport:self.transportConfig];
        if (!connection) {
            connection = [[SDLConnection alloc] initWithTransportConfig:self.transportConfig delegate:self.delegate];
            [self.shareConnections addObject:connection];
        }
    }
    else{
        connection = [[SDLConnection alloc] initWithTransportConfig:self.transportConfig delegate:self.delegate];
    }
    
    self.sdlConnection = connection;
    [connection registerSession:self];
}

-(SDLConnection*)properConnectionForTransport:(SDLBaseTransportConfig*)transportConfig{
    
    SDLConnection* connection;
    
    NSUInteger minCount = 0;
    for (SDLConnection* conn in self.shareConnections) {
        if (conn.currentTransportType == transportConfig.transportType) {
            if (minCount == 0 || minCount >= [conn sessionCount]) {
                connection = conn;
                minCount = [conn sessionCount];
            }
        }
    }
    return connection;
}

-(void)close{
    if (self.sdlConnection) {
        [self.sdlConnection unregisterSession:self];
        
        if ([self.sdlConnection registrationCount] == 0) {
            [self.shareConnections removeObject:self.sdlConnection];
        }
        self.sdlConnection = nil;
    }
}

-(NSString *)notificationComment{
    SDLConnection* connection;
    if (_transportConfig.shareConnection) {
        connection = [self properConnectionForTransport:_transportConfig];
    } else {
        connection = self.sdlConnection;
    }
    
    if (connection != nil)
        return [connection notificationComment];
    
    return @"";
}

-(void)sendMessage:(SDLRPCRequest *)message{
    [self.sdlConnection sendMessage:message];
}

-(BOOL)isConnected{
    return [self.sdlConnection isConnected];
}

-(void)initializeSession{
    if (self.heartbeatMonitor) {
        //TODO: Implement
//        [self.heartbeatMonitor start];
    }
}

#pragma mark SDLConnectionDelegate Methods

-(void)transportDisconnected{
    [self.delegate transportDisconnected];
}

-(void)transportError:(NSError *)error{
    [self.delegate transportError:error];
}

-(void)protocolMessageReceived:(SDLProtocolMessage *)msg{
    [self.delegate protocolMessageReceived:msg];
}

-(void)heartbeatTimedOut:(Byte)sessionID{
    [self.delegate heartbeatTimedOut:sessionID];
}

-(void)protocolSessionStarted:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString *)correlationID{
    self.sessionID = sessionID;
    //TODO: Implement
//    self.lockScreenManager.sessionId = sessionId;
    [self.delegate protocolSessionStarted:sessionType sessionID:sessionID version:version correlationID:correlationID];
    [self initializeSession];
}

-(void)protocolSessionEnded:(SDLServiceType)sessionType sessionID:(Byte)sessionID correlationID:(NSString *)correlationID{
    [self.delegate protocolSessionEnded:sessionType sessionID:sessionID correlationID:correlationID];
}

-(void)protocolErrorWithInfo:(NSString *)info exception:(NSException *)e{
    [self.delegate protocolErrorWithInfo:info exception:e];
}

@end
