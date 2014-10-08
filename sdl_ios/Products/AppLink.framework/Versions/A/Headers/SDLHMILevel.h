//  SDLHMILevel.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLHMILevel : SDLEnum {}

+(SDLHMILevel*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLHMILevel*) HMI_FULL;
+(SDLHMILevel*) HMI_LIMITED;
+(SDLHMILevel*) HMI_BACKGROUND;
+(SDLHMILevel*) HMI_NONE;

@end
