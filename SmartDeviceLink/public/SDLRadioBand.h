//
//  SDLRadioBand.h
//

#import "SDLEnum.h"

/**
 Radio bands, such as AM and FM, used in RadioControlData
 */
typedef SDLEnum SDLRadioBand NS_TYPED_ENUM;

/**
 * Represents AM radio band
 */
extern SDLRadioBand const SDLRadioBandAM NS_SWIFT_NAME(am);

/**
 * Represents FM radio band
 */
extern SDLRadioBand const SDLRadioBandFM NS_SWIFT_NAME(fm);

/**
 * Represents XM radio band
 */
extern SDLRadioBand const SDLRadioBandXM NS_SWIFT_NAME(xm);
