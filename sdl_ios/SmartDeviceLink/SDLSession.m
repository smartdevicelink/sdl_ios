//
//  SDLSession.m
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import "SDLSession.h"
#import <SDLBaseTransportConfig.h>
#import <SDLLockScreenManager.h>
#import <SDLConnection.h>

@interface SDLSession()

@property (strong, nonatomic) SDLConnection* sdlConnection;
@property (nonatomic) Byte wiproProtocolVersion;
@property (weak, nonatomic) id<SDLConnectionDelegate> delegate;
@property (strong, nonatomic) SDLBaseTransportConfig* transportConfig;
@property (strong, nonatomic) NSArray* shareConnections;

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
    }
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

@end
