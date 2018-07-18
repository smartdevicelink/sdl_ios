//  SDLMassageModeData.h
//

#import "SDLRPCStruct.h"
#import "SDLMassageZone.h"
#import "SDLMassageMode.h"

/**
 * Specify the mode of a massage zone.
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLMassageModeData : SDLRPCStruct

/**
 * @abstract Constructs a newly allocated SDLMassageModeData object with massageMode and massageZone
 */
- (instancetype)initWithMassageMode:(SDLMassageMode)massageMode massageZone:(SDLMassageZone)massageZone;

/**
* @abstract mode of a massage zone
*
* @see SDLMassageMode
*
*/
@property (strong, nonatomic) SDLMassageMode massageMode;

/**
 * @abstract zone of a multi-contour massage seat.
 *
 * @see SDLMassageZone
 *
 */
@property (strong, nonatomic) SDLMassageZone massageZone;

@end

NS_ASSUME_NONNULL_END
