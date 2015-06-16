//
//  SDLSession.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLConnectionDelegate.h>
#import <SmartDeviceLink/SDLAbstractTransport.h>
#import "SDLLockScreenManager.h"
#import "SDLRPCRequest.h"

@class SDLBaseTransportConfig;
@class SDLHeartbeatMonitor;

@interface SDLSession : NSObject

-(void)close;

+(instancetype)createSessionWithWiProVersion:(Byte)wiproVersion interfaceBroker:(id<SDLConnectionDelegate>)interfaceBroker transportConfig:(SDLBaseTransportConfig*)transportConfig;

@property (nonatomic) Byte sessionID;
@property (strong, nonatomic) SDLLockScreenManager* lockScreenManager;
@property (strong, nonatomic) SDLHeartbeatMonitor* heartbeatMonitor;
-(void)startSession;
-(NSString*)notificationComment;
-(SDLProxyTransportType)currentTransportType;
-(void)sendMessage:(SDLRPCRequest*)message;
-(BOOL)isConnected;

@end
