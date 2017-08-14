//
//  SDLModuleData.h
//

#import "SDLRPCMessage.h"
#import "SDLModuleType.h"

NS_ASSUME_NONNULL_BEGIN

@class SDLRadioControlData;
@class SDLClimateControlData;

@interface SDLModuleData : SDLRPCStruct

/**
 * The moduleType indicates which type of data should be changed
 * and identifies which data object exists in this struct.
 * For example, if the moduleType is CLIMATE then a "climateControlData" should exist
 */
@property (strong) SDLModuleType moduleType;

@property (nullable, strong, nonatomic) SDLRadioControlData *radioControlData;

@property (nullable, strong, nonatomic) SDLClimateControlData *climateControlData;

@end
NS_ASSUME_NONNULL_END
