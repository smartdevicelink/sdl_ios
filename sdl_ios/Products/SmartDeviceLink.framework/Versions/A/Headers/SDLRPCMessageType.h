//  SDLRPCMessageType.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLRPCMessageType : SDLEnum {}

+(SDLRPCMessageType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLRPCMessageType*) request;
+(SDLRPCMessageType*) response;
+(SDLRPCMessageType*) notification;

@end
