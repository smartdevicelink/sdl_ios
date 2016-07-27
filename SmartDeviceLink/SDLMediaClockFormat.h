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
@interface SDLMediaClockFormat : SDLEnum {
}

/**
 * @abstract Media Clock Format
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLMediaClockFormat
 */
+ (SDLMediaClockFormat *)valueOf:(NSString *)value;

/**
 * @abstract declare an array that store all possible Media clock formats inside
 *
 * @return the array
 */
+ (NSArray *)values;

/**
 * @abstract Media clock format: Clock1
 *
 * @discussion
 * <ul>
 * <li>maxHours = 19</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
  * @return The SDLMediaClockFormat object with value *CLOCK1*
 */
+ (SDLMediaClockFormat *)CLOCK1;

/**
 * @abstract Media clock format: Clock2
 *
 * @discussion
 * <ul>
 * <li>maxHours = 59</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
 * @return The SDLMediaClockFormat object with value *CLOCK2*
 */
+ (SDLMediaClockFormat *)CLOCK2;

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
 * @return The SDLMediaClockFormat object with value *CLOCK3*
 */
+ (SDLMediaClockFormat *)CLOCK3;

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
 *
 * @return The SDLMediaClockFormat object with value *CLOCKTEXT1*
 */
+ (SDLMediaClockFormat *)CLOCKTEXT1;

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
 *
 * @return The SDLMediaClockFormat object with value *CLOCKTEXT2*
 */
+ (SDLMediaClockFormat *)CLOCKTEXT2;

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
 *
 * @return The SDLMediaClockFormat object with value *CLOCKTEXT3*
 */
+ (SDLMediaClockFormat *)CLOCKTEXT3;

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
 * @return The SDLMediaClockFormat object with value *CLOCKTEXT4*
 */
+ (SDLMediaClockFormat *)CLOCKTEXT4;

@end
