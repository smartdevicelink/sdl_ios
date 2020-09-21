//  SDLMediaClockFormat.h
//


#import "SDLEnum.h"

/**
 Indicates the format of the time displayed on the connected SDL unit.

 Format description follows the following nomenclature: <br>
 Sp = Space <br>
 | = or <br>
 c = character <br>

 Used in DisplayCapabilities

 @since SDL 1.0
 */
typedef SDLEnum SDLMediaClockFormat NS_TYPED_ENUM;

/**
 * Media clock format: Clock1
 *
 * maxHours = 19
 * maxMinutes = 59
 * maxSeconds = 59
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock1;

/**
 * Media clock format: Clock2
 *
 * maxHours = 59
 * maxMinutes = 59
 * maxSeconds = 59
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock2;

/**
 * Media clock format: Clock3
 *
 * @discussion
 * <ul>
 * maxHours = 9
 * maxMinutes = 59
 * maxSeconds = 59
 * </ul>
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock3;

/**
 * Media clock format: ClockText1
 *
 * @discussion
 * <ul>
 * 5 characters possible
 * Format: 1|sp c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * TypeII column in XLS.
 * :|sp : colon or space
 * used for Type II headunit
 * </ul>
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText1;

/**
 * Media clock format: ClockText2
 *
 * @discussion
 * <ul>
 * 5 characters possible
 * Format: 1|sp c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * CID column in XLS.
 * :|sp : colon or space
 * used for CID headunit
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText2;

/**
 * Media clock format: ClockText3
 *
 * @discussion
 * <ul>
 * 6 chars possible
 * Format: 1|sp c c :|sp c c
 * 1|sp : digit "1" or space
 * c : character out of following character set: sp|0-9|[letters, see
 * Type 5 column in XLS].
 * :|sp : colon or space
 * used for Type V headunit
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText3;

/**
 * Media clock format: ClockText4
 *
 * 6 chars possible
 * Format:      c   :|sp   c   c   :   c   c
 * :|sp : colon or space
 * c    : character out of following character set: sp|0-9|[letters] used for MFD3/4/5 headunits
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText4;
