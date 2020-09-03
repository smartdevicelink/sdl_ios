//  SDLSeatControlData.h
//

#import "SDLRPCStruct.h"
#import "SDLSeatMemoryActionType.h"
#import "SDLSupportedSeat.h"

@class SDLMassageModeData;
@class SDLMassageCushionFirmness;
@class SDLSeatMemoryAction;

NS_ASSUME_NONNULL_BEGIN

/**
 * Seat control data corresponds to "SEAT" ModuleType.
 */

@interface SDLSeatControlData : SDLRPCStruct

/**
 * Convenience init for setting all possible seat control data
 *
 * @param heatingEnabled - heatingEnabled
 * @param coolingEnabled - coolingEnabled
 * @param heatingLevel - heatingLevel
 * @param coolingLevel - coolingLevel
 * @param horizontalPosition - horizontalPosition
 * @param verticalPosition - verticalPosition
 * @param frontVerticalPosition - frontVerticalPosition
 * @param backVerticalPosition - backVerticalPosition
 * @param backTiltAngle - backTiltAngle
 * @param headSupportHorizontalPosition - headSupportHorizontalPosition
 * @param headSupportVerticalPosition - headSupportVerticalPosition
 * @param massageEnabled - massageEnabled
 * @param massageMode - massageMode
 * @param massageCushionFirmness - massageCushionFirmness
 * @param memory - memory
 * @return A SDLSeatControlData object
 */
- (instancetype)initWithHeatingEnabled:(nullable NSNumber<SDLBool> *)heatingEnabled coolingEnabled:(nullable NSNumber<SDLBool> *)coolingEnabled heatingLevel:(nullable NSNumber<SDLUInt> *)heatingLevel coolingLevel:(nullable NSNumber<SDLUInt> *)coolingLevel horizontalPosition:(nullable NSNumber<SDLUInt> *)horizontalPosition verticalPosition:(nullable NSNumber<SDLUInt> *)verticalPosition frontVerticalPosition:(nullable NSNumber<SDLUInt> *)frontVerticalPosition backVerticalPosition:(nullable NSNumber<SDLUInt> *)backVerticalPosition backTiltAngle:(nullable NSNumber<SDLUInt> *)backTiltAngle headSupportHorizontalPosition:(nullable NSNumber<SDLUInt> *)headSupportHorizontalPosition headSupportVerticalPosition:(nullable NSNumber<SDLUInt> *)headSupportVerticalPosition massageEnabled:(nullable NSNumber<SDLBool> *)massageEnabled massageMode:(nullable NSArray<SDLMassageModeData *> *)massageMode massageCushionFirmness:(nullable NSArray<SDLMassageCushionFirmness *> *)massageCushionFirmness memory:(nullable SDLSeatMemoryAction *)memory;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
Constructs a newly allocated SDLSeatControlData object with cushion and firmness

@param supportedSeat id of remote controllable seat.
@return An instance of the SDLSeatControlData class
*/
- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat __deprecated_msg("Use initWithHeatingEnabled:coolingEnabled:heatingLevel:coolingLevel:horizontalPosition:verticalPosition:frontVerticalPosition:backVerticalPosition:backTiltAngle:headSupportHorizontalPosition:headSupportVerticalPosition:massageEnabled:massageMode:massageCushionFirmness:memory: instead");;
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
/**
 Constructs a newly allocated SDLSeatControlData object with cushion and firmness

@param supportedSeat id of remote controllable seat.
@param heatingEnable Whether or not heating is enabled.
@param coolingEnable Whether or not cooling is enabled.
@param heatingLevel heating level
@param coolingLevel cooling Level
@param horizontal horizontal Position
@param vertical vertical Position
@param frontVertical frontVertical Position
@param backVertical backVertical Position
@param backAngle backAngle Position
@param headSupportedHorizontal headSupportedHorizontal Position
@param headSupportedVertical headSupportedVertical Position
@param massageEnable Whether or not massage is enabled.
@param massageMode Array of massage mode data.
@param firmness Array of firmness data.
@param memoryAction type of action to be performed.
@return An instance of the SDLSeatControlData class
*/
- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat heatingEnabled:(BOOL)heatingEnable coolingEnable:(BOOL)coolingEnable heatingLevel:(UInt8)heatingLevel coolingLevel:(UInt8)coolingLevel horizontalPostion:(UInt8)horizontal verticalPostion:(UInt8)vertical frontVerticalPostion:(UInt8)frontVertical backVerticalPostion:(UInt8)backVertical backTiltAngle:(UInt8)backAngle headSupportedHorizontalPostion:(UInt8)headSupportedHorizontal headSupportedVerticalPostion:(UInt8)headSupportedVertical massageEnabled:(BOOL)massageEnable massageMode:(NSArray<SDLMassageModeData *> *)massageMode massageCussionFirmness:(NSArray<SDLMassageCushionFirmness *> *)firmness memory:(SDLSeatMemoryAction *)memoryAction __deprecated_msg("Use initWithHeatingEnabled:coolingEnabled:heatingLevel:coolingLevel:horizontalPosition:verticalPosition:frontVerticalPosition:backVerticalPosition:backTiltAngle:headSupportHorizontalPosition:headSupportVerticalPosition:massageEnabled:massageMode:massageCushionFirmness:memory: instead");
#pragma clang diagnostic pop

/**
* @abstract id of seat that is a remote controllable seat.
* @warning This should not be used to identify a seat, this is a deprecated parameter.
*
* Required
*/
@property (strong, nonatomic) SDLSupportedSeat id __deprecated;

/**
 * @abstract Whether or not heating is enabled.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *heatingEnabled;

/**
 * @abstract Whether or not cooling is enabled.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *coolingEnabled;

/**
 * @abstract heating level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *heatingLevel;

/**
 * @abstract cooling level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *coolingLevel;

/**
 * @abstract horizontal Position in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *horizontalPosition;

/**
 * @abstract heating level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *verticalPosition;

/**
 * @abstract heating level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *frontVerticalPosition;

/**
 * @abstract heating level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *backVerticalPosition;

/**
 * @abstract heating level in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *backTiltAngle;

/**
 * @abstract head Support Horizontal Position in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *headSupportHorizontalPosition;

/**
 * @abstract head Support Vertical Position in integer
 *
 * Optional, MinValue- 0 MaxValue= 100
 */
@property (nullable, strong, nonatomic) NSNumber<SDLInt> *headSupportVerticalPosition;

/**
 * @abstract Whether or not massage is enabled.

 * Optional
 */
@property (nullable, strong, nonatomic) NSNumber<SDLBool> *massageEnabled;

/**
 * @abstract Array of massage mode data.

 * Optional, Array of SDLMassageModeData objects, MinArray size-1 MaxArray size-2
 */
@property (nullable, strong, nonatomic) NSArray<SDLMassageModeData *> *massageMode;


/**
 * @abstract Array of firmness of a cushion.

 * Optional, Array of SDLMassageCushionFirmness objects, MinArray size-1 MaxArray size-5
 */
@property (nullable, strong, nonatomic) NSArray<SDLMassageCushionFirmness *> *massageCushionFirmness;

/**
 * @abstract type of action to be performed
 *
 * Required, @see SDLSeatMemoryAction
 */
@property (nullable, strong, nonatomic) SDLSeatMemoryAction *memory;

@end

NS_ASSUME_NONNULL_END
