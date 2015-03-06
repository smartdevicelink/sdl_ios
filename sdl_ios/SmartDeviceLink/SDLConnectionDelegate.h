//
//  SDLConnectionDelegate.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLSessionType.h>

@class SDLProtocolMessage;

@protocol SDLConnectionDelegate <NSObject>

-(void)onTransportDisconnected;
-(void)onTransportError:(NSError*)error;
-(void)onProtocolMessageReceived:(SDLProtocolMessage*)msg;
-(void)onProtocolSessionStarted:(SDLSessionType*)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationID;
-(void)onProtocolSessionNACKed:(SDLSessionType*)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationID;
-(void)onProtocolSessionEnded:(SDLSessionType*)sessionType sessionID:(Byte)sessionID correlationID:(NSString*)correlationID;
-(void)onProtocolError:(NSError*)error;
-(void)onHeartbeatTimedOut:(Byte)sessionID;

@end
