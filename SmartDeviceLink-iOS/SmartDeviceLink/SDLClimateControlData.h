//
//  SDLClimateControlData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@class SDLTemperatureUnit;
@class SDLDefrostZone;


NS_ASSUME_NONNULL_BEGIN

@interface SDLClimateControlData : SDLRPCStruct

/**
 *  Optional, Integer, value 0 - 100
 */
@property (copy, nonatomic, nullable) NSNumber *fanSpeed;

/**
 *  Optional, Integer, value 0 - 100
 */
@property (copy, nonatomic, nullable) NSNumber *currentTemperature;

/**
 *  Optional, Integer, value 0 - 100
 */
@property (copy, nonatomic, nullable) NSNumber *desiredTemperature;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLTemperatureUnit *temperatureUnit;

/**
 *  Optional, Boolean
 */
@property (copy, nonatomic, nullable) NSNumber *airConditioningOn;

/**
 *  Optional, Boolean
 */
@property (copy, nonatomic, nullable) NSNumber *autoModeOn;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLDefrostZone *defrostZone;

/**
 *  Optional, Boolean
 */
@property (copy, nonatomic, nullable) NSNumber *dualModeOn;

@end

NS_ASSUME_NONNULL_END
