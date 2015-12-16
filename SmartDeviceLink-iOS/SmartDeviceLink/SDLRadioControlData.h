//
//  SDLRadioControlData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/4/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@class SDLRadioBand;
@class SDLRadioState;
@class SDLRDSData;


NS_ASSUME_NONNULL_BEGIN

@interface SDLRadioControlData : SDLRPCStruct

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  The integer part of the frequency. i.e. for 101.7 this value should be 101
 *
 *  Optional, Integer, value 0 - 1710
 */
@property (copy, nonatomic, nullable) NSNumber *frequencyInteger;

/**
 *  The fractional part of the frequency. i.e. for 101.7 is 7
 *
 *  Optional, Integer, value 0 - 9
 */
@property (copy, nonatomic, nullable) NSNumber *frequencyFraction;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLRadioBand *band;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLRDSData *rdsData;

/**
 *  Number of HD sub-channels if available
 *
 *  Optional, Integer, value 1 - 3
 */
@property (copy, nonatomic, nullable) NSNumber *availableHDChannels;

/**
 *  Current HD sub-channel if available
 *
 *  Optional, Integer, value 1 - 3
 */
@property (copy, nonatomic, nullable) NSNumber *currentHDChannel;

/**
 *  Optional, Integer, value 0 - 100
 */
@property (copy, nonatomic, nullable) NSNumber *signalStrength;

/**
 *  If the signal strength falls below the set value for this parameter, the radio will tune to an alternative frequency
 *
 *  Optional, Integer, value 0 - 100
 */
@property (copy, nonatomic, nullable) NSNumber *signalChangeThreshold;

/**
 *  True if the radio is on, false is the radio is off
 *
 *  Optional, Boolean
 */
@property (copy, nonatomic, nullable) NSNumber *radioOn;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLRadioState *radioState;

@end

NS_ASSUME_NONNULL_END
