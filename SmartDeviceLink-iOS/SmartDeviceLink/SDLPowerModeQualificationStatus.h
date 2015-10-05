//  SDLPowerModeQualificationStatus.h
//


#import "SDLEnum.h"

@interface SDLPowerModeQualificationStatus : SDLEnum {
}

+ (SDLPowerModeQualificationStatus *)valueOf:(NSString *)value;
+ (NSArray *)values;

+ (SDLPowerModeQualificationStatus *)POWER_MODE_UNDEFINED;
+ (SDLPowerModeQualificationStatus *)POWER_MODE_EVALUATION_IN_PROGRESS;
+ (SDLPowerModeQualificationStatus *)NOT_DEFINED;
+ (SDLPowerModeQualificationStatus *)POWER_MODE_OK;

@end
