//  SDLEmergencyEventType.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLEmergencyEventType : SDLEnum {}

+(SDLEmergencyEventType*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLEmergencyEventType*) NO_EVENT;
+(SDLEmergencyEventType*) FRONTAL;
+(SDLEmergencyEventType*) SIDE;
+(SDLEmergencyEventType*) REAR;
+(SDLEmergencyEventType*) ROLLOVER;
+(SDLEmergencyEventType*) NOT_SUPPORTED;
+(SDLEmergencyEventType*) FAULT;

@end
