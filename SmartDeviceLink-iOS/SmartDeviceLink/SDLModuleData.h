//
//  SDLModuleData.h
//  SmartDeviceLink-iOS
//
//  Created by Joel Fischer on 12/7/15.
//  Copyright © 2015 smartdevicelink. All rights reserved.
//

#import "SDLRPCStruct.h"

@class SDLClimateControlData;
@class SDLInteriorZone;
@class SDLModuleType;
@class SDLRadioControlData;


NS_ASSUME_NONNULL_BEGIN

@interface SDLModuleData : SDLRPCStruct

- (instancetype)init;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

/**
 *  The moduleType indicates which type of data should be changed and identifies which data object exists in this struct. For example, if the moduleType is CLIMATE then a "climateControlData" should exist.
 */
@property (strong, nonatomic) SDLModuleType *moduleType;

@property (strong, nonatomic) SDLInteriorZone *moduleZone;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLClimateControlData *climateControlData;

/**
 *  Optional
 */
@property (strong, nonatomic, nullable) SDLRadioControlData *radioControlData;

@end

NS_ASSUME_NONNULL_END
