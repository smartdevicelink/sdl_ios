//  SDLRPCMessageType.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLRPCMessageType : SDLEnum {}

+(SDLRPCMessageType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLRPCMessageType*) request;
+(SDLRPCMessageType*) response;
+(SDLRPCMessageType*) notification;

@end
