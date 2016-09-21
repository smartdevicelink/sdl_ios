//  SDLButtonPressMode.h
//


#import "SDLEnum.h"

/**
 * Indicates whether this is a LONG or SHORT button press
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLButtonPressMode NS_EXTENSIBLE_STRING_ENUM;

/**
 * @abstract A button was released, after it was pressed for a long time. Actual timing is defined by the head unit and may vary.
 */
extern SDLButtonPressMode SDLButtonPressModeLong;

/**
 * @abstract A button was released, after it was pressed for a short time. Actual timing is defined by the head unit and may vary.
 */
extern SDLButtonPressMode SDLButtonPressModeShort;
