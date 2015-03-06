//
//  SDLSession.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLConnectionDelegate.h>
#import <SmartDeviceLink/SDLBaseTransportConfig.h>
#import <SmartDeviceLink/SDLAbstractTransport.h>
#import <SmartDeviceLink/SDLLockScreenManager.h>

@interface SDLSession : NSObject

@property (nonatomic, getter=isConnected) BOOL connected;

-(void)close;

+(instancetype)createSessionWithWiProVersion:(Byte)wiproVersion interfaceBroker:(id<SDLConnectionDelegate>)interfaceBroker transportConfig:(SDLBaseTransportConfig*)transportConfig;

@property (nonatomic) Byte sessionID;
@property (nonatomic) SDLLockScreenManager* lockScreenManager;

-(void)startSession;
-(NSString*)notificationComment;
-(SDLTransportType)currentTransportType;
-(void)sendMessage:(SDLProtocolMessage*)message;

@end
