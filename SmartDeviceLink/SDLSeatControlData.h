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

- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat;

- (instancetype)initWithId:(SDLSupportedSeat)supportedSeat heatingEnabled:(BOOL)heatingEnable coolingEnable:(BOOL)coolingEnable heatingLevel:(UInt8)heatingLevel coolingLevel:(UInt8)coolingLevel horizontalPostion:(UInt8)horizontal verticalPostion:(UInt8)vertical frontVerticalPostion:(UInt8)frontVertical backVerticalPostion:(UInt8)backVertical backTiltAngle:(UInt8)backAngle headSupportedHorizontalPostion:(UInt8)headSupportedHorizontal headSupportedVerticalPostion:(UInt8)headSupportedVertical massageEnabled:(BOOL)massageEnable massageMode:(NSArray<SDLMassageModeData *> *)massageMode massageCussionFirmness:(NSArray<SDLMassageCushionFirmness *> *)firmness memory:(SDLSeatMemoryAction *)memoryAction;

/**
 * @abstract id of seat that is a remote controllable seat.
 *
 * Required
 */
@property (strong, nonatomic) SDLSupportedSeat id;

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
