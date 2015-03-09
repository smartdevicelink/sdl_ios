//  SDLUpdateMode.h
//



#import "SDLEnum.h"

/**
 * Specifies what function should be performed on the media clock/counter
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLUpdateMode : SDLEnum {}

/**
 * Convert String to SDLUpdateMode
 * @param value String
 * @return SDLUpdateMode
 */
+(SDLUpdateMode*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLUpdateMode
 @result return an array that store all possible SDLUpdateMode
 */
+(NSMutableArray*) values;

/*!
 @abstract Starts the media clock timer counting upward, in increments of 1 second.
 @result return SDLUpdateMode with value of <font color=gray><i> COUNTUP </i></font>
 */
+(SDLUpdateMode*) COUNTUP;
/*!
 @abstract Starts the media clock timer counting downward, in increments of 1 second.
 @result return SDLUpdateMode with value of <font color=gray><i> COUNTDOWN </i></font>
 */
+(SDLUpdateMode*) COUNTDOWN;
/*!
 @abstract Pauses the media clock timer.
 @result return SDLUpdateMode with value of <font color=gray><i> PAUSE </i></font>
 */
+(SDLUpdateMode*) PAUSE;
/*!
 @abstract Resumes the media clock timer. The timer resumes counting in whatever
 mode was in effect before pausing (i.e. COUNTUP or COUNTDOWN).
 @result return SDLUpdateMode with value of <font color=gray><i> RESUME </i></font>
 */
+(SDLUpdateMode*) RESUME;
/*!
 @abstract Clear the media clock timer.
 */
+(SDLUpdateMode*) CLEAR;

@end

