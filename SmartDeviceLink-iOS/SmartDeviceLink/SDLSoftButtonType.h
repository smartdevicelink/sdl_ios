//  SDLSoftButtonType.h
//


#import "SDLEnum.h"

/**
 SoftButtonType (TEXT / IMAGE / BOTH)
 */
@interface SDLSoftButtonType : SDLEnum {
}

/**
 @abstract get SDLSoftButtonType according value string
 @param value NSString
 @return SDLSoftButtonType object
 */
+ (SDLSoftButtonType *)valueOf:(NSString *)value;
/**
 @abstract declare an array to store all possible SDLSoftButtonType values
 @return the array
 */
+ (NSArray *)values;

/**
 @abstract Text kind Softbutton
 @return SDLSoftButtonType object with string value *TEXT*
 */
+ (SDLSoftButtonType *)TEXT;
/**
 @abstract Image kind Softbutton
 @return SDLSoftButtonType object with string value *IMAGE*
 */
+ (SDLSoftButtonType *)IMAGE;
/**
 @abstract Both (Text & Image) kind Softbutton
 @return SDLSoftButtonType object with string value *BOTH*
 */
+ (SDLSoftButtonType *)BOTH;

@end
