//  SDLVRCapabilities.h
//



#import "SDLEnum.h"

/**
 * The VR capabilities of the connected SDL platform.
 *
 */
@interface SDLVRCapabilities : SDLEnum {}

/**
 * Convert String to SDLVRCapabilities
 * @param value String
 * @return SDLVRCapabilities
 */
+(SDLVRCapabilities*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLVRCapabilities
 @result return an array that store all possible SDLVRCapabilities
 */
+(NSMutableArray*) values;

/**
 * @abstract The SDL platform is capable of recognizing spoken text in the current
 * language.
 * @result return an SDLVRCapabilities instance pointer with value of <font color=gray><i> TEXT </i></font>
 * @since <font color=red><b> SmartDeviceLink 1.0 </b></font>
 */
+(SDLVRCapabilities*) TEXT;

@end
