//  SDLHmiZoneCapabilities.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLHMIZoneCapabilities : SDLEnum {}

+(SDLHMIZoneCapabilities*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLHMIZoneCapabilities*) FRONT;
+(SDLHMIZoneCapabilities*) BACK;

@end
