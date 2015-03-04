//  SDLUpdateMode.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLUpdateMode : SDLEnum {}

+(SDLUpdateMode*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLUpdateMode*) COUNTUP;
+(SDLUpdateMode*) COUNTDOWN;
+(SDLUpdateMode*) PAUSE;
+(SDLUpdateMode*) RESUME;
+(SDLUpdateMode*) CLEAR;

@end
