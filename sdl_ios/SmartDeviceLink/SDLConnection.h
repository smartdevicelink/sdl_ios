//
//  SDLConnection.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProtocolMessage.h"
#import "SDLSessionType.h"
#import "SDLProtocolHeader.h"
#import "SDLAbstractTransport.h"

@protocol SDLConnectionDelegate <NSObject>

- (void)transportDisconnected;
- (void)transportDidFailWithError:(NSString *)info exception:(NSException *)e;
- (void)protocolMessageDidReceive:(SDLProtocolMessage *)msg;
- (void)protocolSessionDidNACK:(SDLSessionType *)sessionType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationId;
- (void)protocolSessionDidStart:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationId;
- (void)protocolSessionDidEnd:(SDLServiceType)serviceType sessionID:(Byte)sessionID version:(Byte)version correlationID:(NSString*)correlationId;
- (void)protocolDidFailWithError:(NSString *)info exception:(NSException *)e;
- (void)heartbeatSessionDidTimeout:(Byte)sessionID;

@end

@interface SDLConnection : NSObject

@property (weak, nonatomic) id<SDLConnectionDelegate> delegate;

-(SDLTransportType)currentTransportType;
-(NSUInteger)sessionCount;
-(NSString*)notificationComment;

@end
