//
//  SDLConnectionDelegate.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProtocolHeader.h"

@class SDLProtocolMessage;

@protocol SDLConnectionDelegate <NSObject>

-(void)transportDisconnected;
-(void)transportError:(NSError*)error;
-(void)protocolMessageReceived:(SDLProtocolMessage*)msg;
-(void)protocolSessionStarted:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationID;
-(void)protocolSessionNACKed:(SDLServiceType)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationID;
-(void)protocolSessionEnded:(SDLServiceType)sessionType sessionID:(Byte)sessionID correlationID:(NSString*)correlationID;
-(void)protocolErrorWithInfo:(NSString*)info exception:(NSException*)e;
-(void)heartbeatTimedOut:(Byte)sessionID;

@end
