//  SDLMediaClockFormat.h
//


#import "SDLEnum.h"

/**
 * Indicates the format of the time displayed on the connected SDL unit.
 *
 * Format description follows the following nomenclature: <br>
 * Sp = Space <br>
 * | = or <br>
 * c = character <br>
 *
 * @since SDL 1.0
 */
typedef SDLEnum SDLMediaClockFormat SDL_SWIFT_ENUM;

/**
 * @abstract Media clock format: Clock1
 *
 * @discussion
 * <ul>
 * <li>maxHours = 19</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock1;

/**
 * @abstract Media clock format: Clock2
 *
 * @discussion
 * <ul>
 * <li>maxHours = 59</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock2;

/**
 * @abstract Media clock format: Clock3
 *
 * @discussion
 * <ul>
 * <li>maxHours = 9</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClock3;

/**
 * @abstract Media clock format: ClockText1
 *
 * @discussion
 * <ul>
 * <li>5 characters possible</li>
 * <li>Format: 1|sp c :|sp c c</li>
 * <li>1|sp : digit "1" or space</li>
 * <li>c : character out of following character set: sp|0-9|[letters, see
 * TypeII column in XLS.</li>
 * <li>:|sp : colon or space</li>
 * <li>used for Type II headunit</li>
 * </ul>
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText1;

/**
 * @abstract Media clock format: ClockText2
 *
 * @discussion
 * <ul>
 * <li>5 characters possible</li>
 * <li>Format: 1|sp c :|sp c c</li>
 * <li>1|sp : digit "1" or space</li>
 * <li>c : character out of following character set: sp|0-9|[letters, see
 * CID column in XLS.</li>
 * <li>:|sp : colon or space</li>
 * <li>used for CID headunit</li>
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText2;

/**
 * @abstract Media clock format: ClockText3
 *
 * @discussion
 * <ul>
 * <li>6 chars possible</li>
 * <li>Format: 1|sp c c :|sp c c</li>
 * <li>1|sp : digit "1" or space</li>
 * <li>c : character out of following character set: sp|0-9|[letters, see
 * Type 5 column in XLS].</li>
 * <li>:|sp : colon or space</li>
 * <li>used for Type V headunit</li>
 * </ul>
 * difference between CLOCKTEXT1 and CLOCKTEXT2 is the supported character
 * set
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText3;

/**
 * @abstract Media clock format: ClockText4
 *
 * @discussion
 * <ul>
 * <li>6 chars possible</li>
 * <li>Format:      c   :|sp   c   c   :   c   c</li>
 * <li>:|sp : colon or space</li>
 * <li>c    : character out of following character set: sp|0-9|[letters]</li>
 * <li>used for MFD3/4/5 headunits</li>
 * </ul>
 *
 * @since SDL 2.0
 */
extern SDLMediaClockFormat const SDLMediaClockFormatClockText4;
