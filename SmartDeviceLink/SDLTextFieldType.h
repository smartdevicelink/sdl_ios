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
@interface SDLTextFieldType : SDLEnum {
}

/**
 * Convert String to SDLTextAlignment
 *
 * @param value The value of the string to get an object for
 *
 * @return SDLTextAlignment
 */
+ (SDLTextFieldType *)valueOf:(NSString *)value;

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
+ (SDLTextFieldType *)MEDIA_TITLE;

/**
 * @abstract The data in this field contains the artist or creator of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_ARTIST*
 */
+ (SDLTextFieldType *)MEDIA_ARTIST;

/**
 * @abstract The data in this field contains the album title of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_ALBUM*
 */
+ (SDLTextFieldType *)MEDIA_ALBUM;

/**
 * @abstract The data in this field contains the creation year of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_YEAR*
 */
+ (SDLTextFieldType *)MEDIA_YEAR;

/**
 * @abstract The data in this field contains the genre of the currently playing audio track.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_GENRE*
 */
+ (SDLTextFieldType *)MEDIA_GENRE;

/**
 * @abstract The data in this field contains the name of the current source for the media.
 *
 * @return A SDLTextFieldType object with value of *MEDIA_STATION*
 */
+ (SDLTextFieldType *)MEDIA_STATION;

/**
 * @abstract The data in this field is a rating.
 *
 * @return A SDLTextFieldType object with value of *RATING*
 */
+ (SDLTextFieldType *)RATING;

/**
 * @abstract The data in this field is the current temperature.
 *
 * @return A SDLTextFieldType object with value of *CURRENT_TEMPERATURE*
 */
+ (SDLTextFieldType *)CURRENT_TEMPERATURE;

/**
 * @abstract The data in this field is the maximum temperature for the day.
 *
 * @return A SDLTextFieldType object with value of *MAXIMUM_TEMPERATURE*
 */
+ (SDLTextFieldType *)MAXIMUM_TEMPERATURE;

/**
 * @abstract The data in this field is the minimum temperature for the day.
 *
 * @return A SDLTextFieldType object with value of *MINIMUM_TEMPERATURE*
 */
+ (SDLTextFieldType *)MINIMUM_TEMPERATURE;

/**
 * @abstract The data in this field describes the current weather (ex. cloudy, clear, etc.).
 *
 * @return A SDLTextFieldType object with value of *WEATHER_TERM*
 */
+ (SDLTextFieldType *)WEATHER_TERM;

/**
 * @abstract The data in this field describes the current humidity value.
 *
 * @return A SDLTextFieldType object with value of *HUMIDITY*
 */
+ (SDLTextFieldType *)HUMIDITY;

@end
