//  SDLPowerModeQualificationStatus.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

@interface SDLPowerModeQualificationStatus : SDLEnum {}

+(SDLPowerModeQualificationStatus*) valueOf:(NSString*) value;
+(NSMutableArray*) values;

+(SDLPowerModeQualificationStatus*) POWER_MODE_UNDEFINED;
+(SDLPowerModeQualificationStatus*) POWER_MODE_EVALUATION_IN_PROGRESS;
+(SDLPowerModeQualificationStatus*) NOT_DEFINED;
+(SDLPowerModeQualificationStatus*) POWER_MODE_OK;

@end
