
//
//  SDLMetadataType.h
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLEnum.h"

/**
 * Text Field metadata types. Used in Show.
 */
typedef SDLEnum SDLMetadataType NS_TYPED_ENUM;

/**
 * The song / media title name
 */
extern SDLMetadataType const SDLMetadataTypeMediaTitle;

/**
 * The "artist" of the media
 */
extern SDLMetadataType const SDLMetadataTypeMediaArtist;

/**
 * The "album" of the media"
 */
extern SDLMetadataType const SDLMetadataTypeMediaAlbum;

/**
 * The "year" that the media was created
 */
extern SDLMetadataType const SDLMetadataTypeMediaYear;

/**
 * The "genre" of the media
 */
extern SDLMetadataType const SDLMetadataTypeMediaGenre;

/**
 * The "station" that the media is playing on
 */
extern SDLMetadataType const SDLMetadataTypeMediaStation;

/**
 * The "rating" given to the media
 */
extern SDLMetadataType const SDLMetadataTypeRating;

/**
 * The current temperature of the weather information
 */
extern SDLMetadataType const SDLMetadataTypeCurrentTemperature;

/**
 * The high / maximum temperature of the weather information for the current period
 */
extern SDLMetadataType const SDLMetadataTypeMaximumTemperature;

/**
 * The low / minimum temperature of the weather information for the current period
 */
extern SDLMetadataType const SDLMetadataTypeMinimumTemperature;

/**
 * A description of the weather for the current period
 */
extern SDLMetadataType const SDLMetadataTypeWeatherTerm;

/**
 * The humidity of the weather information for the current period
 */
extern SDLMetadataType const SDLMetadataTypeHumidity;

