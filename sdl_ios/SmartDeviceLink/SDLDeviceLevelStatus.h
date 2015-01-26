//  SDLDeviceLevelStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLDeviceLevelStatus : SDLEnum {}

+(SDLDeviceLevelStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLDeviceLevelStatus*) ZERO_LEVEL_BARS;
+(SDLDeviceLevelStatus*) ONE_LEVEL_BARS;
+(SDLDeviceLevelStatus*) TWO_LEVEL_BARS;
+(SDLDeviceLevelStatus*) THREE_LEVEL_BARS;
+(SDLDeviceLevelStatus*) FOUR_LEVEL_BARS;
+(SDLDeviceLevelStatus*) NOT_PROVIDED;

@end
