//  SDLTextAlignment.h
//



#import "SDLEnum.h"

/**
 * The list of possible alignments of text in a field. May only work on some display types.
 *
 * Avaliable since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
@interface SDLTextAlignment : SDLEnum {}

/**
 * Convert String to SDLTextAlignment
 * @param value String
 * @return SDLTextAlignment
 */
+(SDLTextAlignment*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLTextAlignment
 @result return an array that store all possible SDLTextAlignment
 */
+(NSMutableArray*) values;

/**
 * @abstract Text aligned left.
 * @result return a SDLTextAlignment object with value of <font color=gray><i> LEFT_ALIGNED </i></font>
 */
+(SDLTextAlignment*) LEFT_ALIGNED;
/**
 * @abstract Text aligned right.
 * @result return a SDLTextAlignment object with value of <font color=gray><i> RIGHT_ALIGNED </i></font>
 */
+(SDLTextAlignment*) RIGHT_ALIGNED;
/**
 * @abstract Text aligned centered.
 * @result return a SDLTextAlignment object with value of <font color=gray><i> CENTERED </i></font>
 */
+(SDLTextAlignment*) CENTERED;

@end

