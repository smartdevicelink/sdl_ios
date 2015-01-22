//  SDLImageType.h
//
//  

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Contains information about the type of image.
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLImageType : SDLEnum {}

/*!
 @abstract return SDLImageType (STATIC / DYNAMIC)
 @param value NSString
 @result return SDLImageType
 */
+(SDLImageType*) valueOf:(NSString*) value;
/*!
 @abstract store all possible SDLImageType values
 @result return an array with all possible SDLImageType values inside
 */
+(NSMutableArray*) values;

/**
 * @abstract Just the static hex icon value to be used
 * @result return the Image Type with value <font color=gray><i> STATIC </i></font>
 */
+(SDLImageType*) STATIC;
/**
 * @abstract Binary image file to be used (identifier to be sent by PutFile)
 * @result return the Image Type with value <font color=gray><i> DYNAMIC </i></font>
 */
+(SDLImageType*) DYNAMIC;

@end
