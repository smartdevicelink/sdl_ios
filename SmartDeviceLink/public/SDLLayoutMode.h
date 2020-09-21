//  SDLLayoutMode.h
//


#import "SDLEnum.h"

/** 
 * For touchscreen interactions, the mode of how the choices are presented. Used in PerformInteraction.
 *
 * @since SDL 3.0
 */
typedef SDLEnum SDLLayoutMode NS_TYPED_ENUM;

/**
 * This mode causes the interaction to display the previous set of choices as icons.
 */
extern SDLLayoutMode const SDLLayoutModeIconOnly;

/** 
 * This mode causes the interaction to display the previous set of choices as icons along with a search field in the HMI.
 */
extern SDLLayoutMode const SDLLayoutModeIconWithSearch;

/** 
 * This mode causes the interaction to display the previous set of choices as a list.
 */
extern SDLLayoutMode const SDLLayoutModeListOnly;

/** 
 * This mode causes the interaction to display the previous set of choices as a list along with a search field in the HMI.
 */
extern SDLLayoutMode const SDLLayoutModeListWithSearch;

/** 
 * This mode causes the interaction to immediately display a keyboard entry through the HMI.
 */
extern SDLLayoutMode const SDLLayoutModeKeyboard;
