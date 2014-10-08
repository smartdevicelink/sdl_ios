//  SDLAmbientLightStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLAmbientLightStatus : SDLEnum {}

+(SDLAmbientLightStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLAmbientLightStatus*) NIGHT;
+(SDLAmbientLightStatus*) TWILIGHT_1;
+(SDLAmbientLightStatus*) TWILIGHT_2;
+(SDLAmbientLightStatus*) TWILIGHT_3;
+(SDLAmbientLightStatus*) TWILIGHT_4;
+(SDLAmbientLightStatus*) DAY;
+(SDLAmbientLightStatus*) UNKNOWN;
+(SDLAmbientLightStatus*) INVALID;

@end
