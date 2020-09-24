//  SDLPowerModeQualificationStatus.h
//


#import "SDLEnum.h"

/**
 Describes the power mode qualification status. Used in ClusterModeStatus.
 */
typedef SDLEnum SDLPowerModeQualificationStatus NS_TYPED_ENUM;

/**
 An undefined status
 */
extern SDLPowerModeQualificationStatus const SDLPowerModeQualificationStatusUndefined;

/**
 An "evaluation in progress" status
 */
extern SDLPowerModeQualificationStatus const SDLPowerModeQualificationStatusEvaluationInProgress;

/**
 A "not defined" status
 */
extern SDLPowerModeQualificationStatus const SDLPowerModeQualificationStatusNotDefined;

/**
 An "ok" status
 */
extern SDLPowerModeQualificationStatus const SDLPowerModeQualificationStatusOk;
