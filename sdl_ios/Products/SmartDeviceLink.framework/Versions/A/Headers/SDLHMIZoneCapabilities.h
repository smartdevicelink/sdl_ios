//  SDLHmiZoneCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLHmiZoneCapabilities : SDLEnum {}

+(SDLHmiZoneCapabilities*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLHmiZoneCapabilities*) FRONT;
+(SDLHmiZoneCapabilities*) BACK;

@end
