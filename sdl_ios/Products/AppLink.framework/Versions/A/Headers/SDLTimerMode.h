//  SDLTimerMode.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLTimerMode : SDLEnum {}

+(SDLTimerMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLTimerMode*) UP;
+(SDLTimerMode*) DOWN;
+(SDLTimerMode*) NONE;

@end
