//  SDLButtonCapabilities.h
//

#import "SDLRPCMessage.h"

#import "SDLButtonName.h"
#import "SDLModuleInfo.h"


/**
 * Provides information about the capabilities of a SDL HMI button.
 * 
 * @since SDL 1.0
 */

NS_ASSUME_NONNULL_BEGIN

@interface SDLButtonCapabilities : SDLRPCStruct

/**
 * The name of the SDL HMI button.

 Required
 */
@property (strong, nonatomic) SDLButtonName name;

/**
 * A NSNumber value indicates whether the button supports a SHORT press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *shortPressAvailable;

/**
 * A NSNumber value indicates whether the button supports a LONG press
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *longPressAvailable;

/**
 * A NSNumber value indicates whether the button supports "button down" and "button up"
 *
 * Required, Boolean
 */
@property (strong, nonatomic) NSNumber<SDLBool> *upDownAvailable;

/**
 *  Information about a RC module, including its id.
 *
 *  Optional
 */
@property (nullable, strong, nonatomic) SDLModuleInfo *moduleInfo;

@end

NS_ASSUME_NONNULL_END
