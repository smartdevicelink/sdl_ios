//  SDLMediaClockFormat.h
//



#import "SDLEnum.h"

/**
 * Indicates the format of the time displayed on the connected SDL unit.
 *
 * Format description follows the following nomenclature:
 <br> &nbsp; &nbsp; Sp = Space<br> &nbsp;&nbsp; | = or <br>&nbsp;&nbsp; c = character
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLMediaClockFormat : SDLEnum {}

/*!
 @abstract Media Clock Format
 @param value NSString
 @result return SDLMediaClockFormat
 */
+(SDLMediaClockFormat*) valueOf:(NSString*) value;
/*!
 @abstract declare an array that store all possible Media clock formats inside
 @result return the array
 */
+(NSArray*) values;

/**
 * @abstract Media clock format : Clock1
 * @discussion <p>
 * </p>
 * <ul>
 * <li>maxHours = 19</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCK1 </i></font>
 */
+(SDLMediaClockFormat*) CLOCK1;
/**
 * @abstract Media clock format : Clock2
 * <p>
 * </p>
 * <ul>
 * <li>maxHours = 59</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCK </i></font>
 */
+(SDLMediaClockFormat*) CLOCK2;
/**
 * @abstract Media clock format : Clock3
 * <p>
 * </p>
 * <ul>
 * <li>maxHours = 9</li>
 * <li>maxMinutes = 59</li>
 * <li>maxSeconds = 59</li>
 * </ul>
 *
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCK3 </i></font>
 */
+(SDLMediaClockFormat*) CLOCK3;
/**
 * @abstract Media clock format : ClockText1
 * @discussion <p>
 * </p>
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
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCKTEXT1 </i></font>
 */
+(SDLMediaClockFormat*) CLOCKTEXT1;
/**
 * @abstract Media clock format : ClockText2
 * @discussion <p>
 * </p>
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
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCKTEXT2 </i></font>
 */
+(SDLMediaClockFormat*) CLOCKTEXT2;
/**
 * @abstract Media clock format : ClockText3
 * @discussion <p>
 * </p>
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
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCKTEXT3 </i></font>
 */
+(SDLMediaClockFormat*) CLOCKTEXT3;
/**
 * @abstract Media clock format : ClockText4
 * @discussion <p>
 * </p>
 * <ul>
 * <li>6 chars possible</li>
 * <li>Format:      c   :|sp   c   c   :   c   c</li>
 * <li>:|sp : colon or space</li>
 * <li>c    : character out of following character set: sp|0-9|[letters]</li>
 * <li>used for MFD3/4/5 headunits</li>
 * </ul>
 *
 * @since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 * @result return the SDLMediaClockFormat object with value <font color=gray><i> CLOCKTEXT4 </i></font>
 */
+(SDLMediaClockFormat*) CLOCKTEXT4;

@end
