//  SDLPowerModeStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLPowerModeStatus : SDLEnum {}

+(SDLPowerModeStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPowerModeStatus*) KEY_OUT;
+(SDLPowerModeStatus*) KEY_RECENTLY_OUT;
+(SDLPowerModeStatus*) KEY_APPROVED_0;
+(SDLPowerModeStatus*) POST_ACCESORY_0;
+(SDLPowerModeStatus*) ACCESORY_1;
+(SDLPowerModeStatus*) POST_IGNITION_1;
+(SDLPowerModeStatus*) IGNITION_ON_2;
+(SDLPowerModeStatus*) RUNNING_2;
+(SDLPowerModeStatus*) CRANK_3;

@end
