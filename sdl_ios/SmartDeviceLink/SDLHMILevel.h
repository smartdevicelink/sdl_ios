//  SDLHMILevel.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLHMILevel : SDLEnum {}

+(SDLHMILevel*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLHMILevel*) HMI_FULL;
+(SDLHMILevel*) HMI_LIMITED;
+(SDLHMILevel*) HMI_BACKGROUND;
+(SDLHMILevel*) HMI_NONE;

@end
