//  SDLFileType.h
//
//

#import <Foundation/Foundation.h>
#import <SmartDeviceLink/SDLEnum.h>

/**
 * Enumeration listing possible file tpyes.
 *
 * This enum is avaliable since <font color=red><b> SmartDeviceLink 2.0 </b></font>
 */
@interface SDLFileType : SDLEnum {}

/**
 * Convert String to SDLFileType
 * @param value String
 * @return SDLFileType
 */
+(SDLFileType*) valueOf:(NSString*) value;
/*!
 @abstract Store the enumeration of all possible SDLFileType
 @result return an array that store all possible SDLFileType
 */
+(NSMutableArray*) values;

/*!
 @abstract file type : BMP
 @result SDLFileType with value of <font color=gray><i> GRAPHIC_BMP </i></font>
 */
+(SDLFileType*) GRAPHIC_BMP;
/*!
 @abstract file type : JPEG
 @result SDLFileType with value of <font color=gray><i> GRAPHIC_JPEG </i></font>
 */
+(SDLFileType*) GRAPHIC_JPEG;
/*!
 @abstract file type : PNG
 @result SDLFileType with value of <font color=gray><i> GRAPHIC_PNG </i></font>
 */
+(SDLFileType*) GRAPHIC_PNG;
/*!
 @abstract file type : WAVE
 @result SDLFileType with value of <font color=gray><i> AUDIO_WAVE </i></font>
 */
+(SDLFileType*) AUDIO_WAVE;
/*!
 @abstract file type : MP3
 @result SDLFileType with value of <font color=gray><i> AUDIO_MP3 </i></font>
 */
+(SDLFileType*) AUDIO_MP3;
/*!
 @abstract file type : AAC
 @result SDLFileType with value of <font color=gray><i> AUDIO_AAC </i></font>
 */
+(SDLFileType*) AUDIO_AAC;
/*!
 @abstract file type : BINARY
 @result SDLFileType with value of <font color=gray><i> BINARY </i></font>
 */
+(SDLFileType*) BINARY;
/*!
 @abstract file type : JSON
 @result SDLFileType with value of <font color=gray><i> JSON </i></font>
 */
+(SDLFileType*) JSON;

@end
