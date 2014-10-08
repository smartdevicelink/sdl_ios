//  SDLMediaClockFormat.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLMediaClockFormat : SDLEnum {}

+(SDLMediaClockFormat*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLMediaClockFormat*) CLOCK1;
+(SDLMediaClockFormat*) CLOCK2;
+(SDLMediaClockFormat*) CLOCK3;
+(SDLMediaClockFormat*) CLOCKTEXT1;
+(SDLMediaClockFormat*) CLOCKTEXT2;
+(SDLMediaClockFormat*) CLOCKTEXT3;
+(SDLMediaClockFormat*) CLOCKTEXT4;

@end
