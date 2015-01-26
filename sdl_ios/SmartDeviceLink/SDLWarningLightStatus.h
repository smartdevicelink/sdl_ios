//  SDLWarningLightStatus.h
//
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.


#import "SDLEnum.h"

@interface SDLWarningLightStatus : SDLEnum {}

+(SDLWarningLightStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLWarningLightStatus*) OFF;
+(SDLWarningLightStatus*) ON;
+(SDLWarningLightStatus*) FLASH;
+(SDLWarningLightStatus*) NOT_USED;

@end
