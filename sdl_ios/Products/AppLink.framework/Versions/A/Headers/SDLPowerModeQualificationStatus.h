//  SDLPowerModeQualificationStatus.h
//  SyncProxy
//  Copyright (c) 2014 Ford Motor Company. All rights reserved.

#import <Foundation/Foundation.h>
#import <AppLink/SDLEnum.h>

@interface SDLPowerModeQualificationStatus : SDLEnum {}

+(SDLPowerModeQualificationStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPowerModeQualificationStatus*) POWER_MODE_UNDEFINED;
+(SDLPowerModeQualificationStatus*) POWER_MODE_EVALUATION_IN_PROGRESS;
+(SDLPowerModeQualificationStatus*) NOT_DEFINED;
+(SDLPowerModeQualificationStatus*) POWER_MODE_OK;

@end
