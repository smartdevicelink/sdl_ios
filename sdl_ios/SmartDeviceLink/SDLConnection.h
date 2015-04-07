//
//  SDLConnection.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDLProtocolMessage.h"
#import "SDLAbstractTransport.h"
#import "SDLConnectionDelegate.h"
#import "SDLSession.h"
#import "SDLRPCRequest.h"

@interface SDLConnection : NSObject

-(instancetype)initWithTransportConfig:(SDLBaseTransportConfig*)transportConfig delegate:(id<SDLConnectionDelegate>)delegate;

@property (weak, nonatomic) id<SDLConnectionDelegate> delegate;

-(void)registerSession:(SDLSession*)session;
-(SDLTransportType)currentTransportType;
-(NSUInteger)sessionCount;
-(NSString*)notificationComment;
//TODO: This is a object mis-match from Android. Android sends a ProtocolMessage. However, SDLProtocol expects a SDLRPCRequest
-(void)sendMessage:(SDLRPCRequest*)message;
-(BOOL)isConnected;

@end
