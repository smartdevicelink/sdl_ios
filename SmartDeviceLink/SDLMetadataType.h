//
//  SDLTextFieldType.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * The list of possible metadata for text fields
 *
 * @since SDL 4.7.0
 */
@interface SDLMetadataType : SDLEnum {
}

/**
 * Convert String to SDLTextAlignment
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLTextAlignment
 */
+ (SDLMetadataType *)valueOf:(NSString *)value;

/**
 * @abstract Store the enumeration of all possible SDLTextFieldType
 *
 * @return an array that store all possible SDLTextFieldType
 */
+ (NSArray *)values;

/**
 * @abstract The data in this field contains the title of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_TITLE*
 */
+ (SDLMetadataType *)MEDIA_TITLE;

/**
 * @abstract The data in this field contains the artist or creator of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_ARTIST*
 */
+ (SDLMetadataType *)MEDIA_ARTIST;

/**
 * @abstract The data in this field contains the album title of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_ALBUM*
 */
+ (SDLMetadataType *)MEDIA_ALBUM;

/**
 * @abstract The data in this field contains the creation year of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_YEAR*
 */
+ (SDLMetadataType *)MEDIA_YEAR;

/**
 * @abstract The data in this field contains the genre of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_GENRE*
 */
+ (SDLMetadataType *)MEDIA_GENRE;

/**
 * @abstract The data in this field contains the name of the current source for the media.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_STATION*
 */
+ (SDLMetadataType *)MEDIA_STATION;

/**
 * @abstract The data in this field is a rating.
 *
 * @return A SDLTextFieldType object with value of *RATING*
 */
+ (SDLMetadataType *)RATING;

/**
 * @abstract The data in this field is the current temperature.
 *
 * @return A SDLTextFieldType object with value of *CURRENT_TEMPERATURE*
 */
+ (SDLMetadataType *)CURRENT_TEMPERATURE;

/**
 * @abstract The data in this field is the maximum temperature for the day.
 *
 * @return A SDLTextFieldType object with value of *MAXIMUM_TEMPERATURE*
 */
+ (SDLMetadataType *)MAXIMUM_TEMPERATURE;

/**
 * @abstract The data in this field is the minimum temperature for the day.
 *
 * @return A SDLTextFieldType object with value of *MINIMUM_TEMPERATURE*
 */
+ (SDLMetadataType *)MINIMUM_TEMPERATURE;

/**
 * @abstract The data in this field describes the current weather (ex. cloudy, clear, etc.).
 *
 * @return A SDLTextFieldType object with value of *WEATHER_TERM*
 */
+ (SDLMetadataType *)WEATHER_TERM;

/**
 * @abstract The data in this field describes the current humidity value.
 *
 * @return A SDLTextFieldType object with value of *HUMIDITY*
 */
+ (SDLMetadataType *)HUMIDITY;

@end
