//  SDLPowerModeQualificationStatus.m
//


#import "SDLPowerModeQualificationStatus.h"

SDLPowerModeQualificationStatus *SDLPowerModeQualificationStatus_POWER_MODE_UNDEFINED = nil;
SDLPowerModeQualificationStatus *SDLPowerModeQualificationStatus_POWER_MODE_EVALUATION_IN_PROGRESS = nil;
SDLPowerModeQualificationStatus *SDLPowerModeQualificationStatus_NOT_DEFINED = nil;
SDLPowerModeQualificationStatus *SDLPowerModeQualificationStatus_POWER_MODE_OK = nil;

NSArray *SDLPowerModeQualificationStatus_values = nil;

@implementation SDLPowerModeQualificationStatus

+ (SDLPowerModeQualificationStatus *)valueOf:(NSString *)value {
    for (SDLPowerModeQualificationStatus *item in SDLPowerModeQualificationStatus.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLPowerModeQualificationStatus_values == nil) {
        SDLPowerModeQualificationStatus_values = @[
            SDLPowerModeQualificationStatus.POWER_MODE_UNDEFINED,
            SDLPowerModeQualificationStatus.POWER_MODE_EVALUATION_IN_PROGRESS,
            SDLPowerModeQualificationStatus.NOT_DEFINED,
            SDLPowerModeQualificationStatus.POWER_MODE_OK,
        ];
    }
    return SDLPowerModeQualificationStatus_values;
}

+ (SDLPowerModeQualificationStatus *)POWER_MODE_UNDEFINED {
    if (SDLPowerModeQualificationStatus_POWER_MODE_UNDEFINED == nil) {
        SDLPowerModeQualificationStatus_POWER_MODE_UNDEFINED = [[SDLPowerModeQualificationStatus alloc] initWithValue:@"POWER_MODE_UNDEFINED"];
    }
    return SDLPowerModeQualificationStatus_POWER_MODE_UNDEFINED;
}

+ (SDLPowerModeQualificationStatus *)POWER_MODE_EVALUATION_IN_PROGRESS {
    if (SDLPowerModeQualificationStatus_POWER_MODE_EVALUATION_IN_PROGRESS == nil) {
        SDLPowerModeQualificationStatus_POWER_MODE_EVALUATION_IN_PROGRESS = [[SDLPowerModeQualificationStatus alloc] initWithValue:@"POWER_MODE_EVALUATION_IN_PROGRESS"];
    }
    return SDLPowerModeQualificationStatus_POWER_MODE_EVALUATION_IN_PROGRESS;
}

+ (SDLPowerModeQualificationStatus *)NOT_DEFINED {
    if (SDLPowerModeQualificationStatus_NOT_DEFINED == nil) {
        SDLPowerModeQualificationStatus_NOT_DEFINED = [[SDLPowerModeQualificationStatus alloc] initWithValue:@"NOT_DEFINED"];
    }
    return SDLPowerModeQualificationStatus_NOT_DEFINED;
}

+ (SDLPowerModeQualificationStatus *)POWER_MODE_OK {
    if (SDLPowerModeQualificationStatus_POWER_MODE_OK == nil) {
        SDLPowerModeQualificationStatus_POWER_MODE_OK = [[SDLPowerModeQualificationStatus alloc] initWithValue:@"POWER_MODE_OK"];
    }
    return SDLPowerModeQualificationStatus_POWER_MODE_OK;
}

@end
