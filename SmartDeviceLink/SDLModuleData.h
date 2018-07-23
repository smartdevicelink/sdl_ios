//
//  SDLModuleData.h
//

#import "SDLRPCMessage.h"
#import "SDLModuleType.h"

@class SDLRadioControlData;
@class SDLClimateControlData;
@class SDLAudioControlData;
@class SDLHMISettingsControlData;
@class SDLLightControlData;


NS_ASSUME_NONNULL_BEGIN

/**
 Describes a remote control module's data
 */
@interface SDLModuleData : SDLRPCStruct

- (instancetype)initWithRadioControlData:(SDLRadioControlData *)radioControlData;
- (instancetype)initWithClimateControlData:(SDLClimateControlData *)climateControlData;
- (instancetype)initWithAudioControlData:(SDLAudioControlData *)audioControlData;
- (instancetype)initWithLightControlData:(SDLLightControlData *)lightControlData;
- (instancetype)initWithHMISettingsControlData:(SDLHMISettingsControlData *)hmiSettingsControlData;

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

@property (nullable, strong, nonatomic) SDLAudioControlData *audioControlData;

@property (nullable, strong, nonatomic) SDLLightControlData *lightControlData;

@property (nullable, strong, nonatomic) SDLHMISettingsControlData *hmiSettingsControlData;

@end

NS_ASSUME_NONNULL_END
