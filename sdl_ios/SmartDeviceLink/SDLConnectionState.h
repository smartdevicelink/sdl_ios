//
//  SDLConnectionState.h
//  SmartDeviceLink
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLConnectionState : SDLEnum {}

+(SDLConnectionState*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLConnectionState*) CONNECTED;
+(SDLConnectionState*) DISCONNECTED;

@end
