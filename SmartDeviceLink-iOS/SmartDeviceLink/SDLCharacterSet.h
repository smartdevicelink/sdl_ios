//  SDLCharacterSet.h
//


#import "SDLEnum.h"

/**
 * Character sets supported by SDL.
 *
 * This enum is avaliable since <font color=red><b>SmartDeviceLink 1.0</b></font>
 */
@interface SDLCharacterSet : SDLEnum {
}

/**
 @abstract Convert String to SDLCharacterSet
 @param value NSString
 @result SDLCharacterSet
 */
+ (SDLCharacterSet *)valueOf:(NSString *)value;
/**
 @abstract Store the enumeration of all possible SDLCharacterSet
 @result return an array that store all possible SDLCharacterSet
 */
+ (NSMutableArray *)values;

+ (SDLCharacterSet *)TYPE2SET;
+ (SDLCharacterSet *)TYPE5SET;
+ (SDLCharacterSet *)CID1SET;
+ (SDLCharacterSet *)CID2SET;

@end
