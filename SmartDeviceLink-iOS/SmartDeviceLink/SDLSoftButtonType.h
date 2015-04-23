//  SDLSoftButtonType.h
//



#import "SDLEnum.h"

/*!
 SoftButtonType (TEXT / IMAGE / BOTH)
 */
@interface SDLSoftButtonType : SDLEnum {}

/*!
 @abstract get SDLSoftButtonType according value string
 @param value NSString
 @result SDLSoftButtonType object
 */
+(SDLSoftButtonType*) valueOf:(NSString*) value;
/*!
 @abstract declare an array to store all possible SDLSoftButtonType values
 @result return the array
 */
+(NSArray*) values;

/*!
 @abstract Text kind Softbutton
 @result SDLSoftButtonType object with string value <font color=gray><i> TEXT </i></font>
 */
+(SDLSoftButtonType*) TEXT;
/*!
 @abstract Image kind Softbutton
 @result SDLSoftButtonType object with string value <font color=gray><i> IMAGE </i></font>
 */
+(SDLSoftButtonType*) IMAGE;
/*!
 @abstract Both (Text & Image) kind Softbutton
 @result SDLSoftButtonType object with string value <font color=gray><i> BOTH </i></font>
 */
+(SDLSoftButtonType*) BOTH;

@end
