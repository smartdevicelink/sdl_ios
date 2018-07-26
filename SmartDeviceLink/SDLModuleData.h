//
//  SDLModuleData.h
//

#import "SDLRPCMessage.h"
#import "SDLModuleType.h"

@class SDLRadioControlData;
@class SDLClimateControlData;
@class SDLSeatControlData;

NS_ASSUME_NONNULL_BEGIN

/**
 Describes a remote control module's data
 */
@interface SDLModuleData : SDLRPCStruct

/**
 Constructs a newly allocated SDLModuleData object with radio control data

 @param radioControlData The radio control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithRadioControlData:(SDLRadioControlData *)radioControlData;

/**
 Constructs a newly allocated SDLModuleData object with climate control data

 @param climateControlData The climate control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithClimateControlData:(SDLClimateControlData *)climateControlData;

/**
 Constructs a newly allocated SDLModuleData object with seat control data

 @param seatControlData The seat control data
 @return An instance of the SDLModuleData class
 */
- (instancetype)initWithSeatControlData:(SDLSeatControlData *)seatControlData;

/**
 The moduleType indicates which type of data should be changed and identifies which data object exists in this struct.

 For example, if the moduleType is CLIMATE then a "climateControlData" should exist

 Required
 */
@property (strong, nonatomic) SDLModuleType moduleType;

/**
 The radio control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLRadioControlData *radioControlData;

/**
 The climate control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLClimateControlData *climateControlData;

/**
 The seat control data

 Optional
 */
@property (nullable, strong, nonatomic) SDLSeatControlData *seatControlData;

@end

NS_ASSUME_NONNULL_END
