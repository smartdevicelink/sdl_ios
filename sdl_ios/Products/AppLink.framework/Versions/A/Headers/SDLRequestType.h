//  SDLRequestType.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLRequestType : SDLEnum {}

+(SDLRequestType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLRequestType*) HTTP;
+(SDLRequestType*) FILE_RESUME;
+(SDLRequestType*) AUTH_REQUEST;
+(SDLRequestType*) AUTH_CHALLENGE;
+(SDLRequestType*) AUTH_ACK;
+(SDLRequestType*) PROPRIETARY;

@end
