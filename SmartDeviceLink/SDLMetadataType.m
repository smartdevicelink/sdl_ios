//
//  SDLMetadataType.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLMetadataType.h"

SDLMetadataType *SDLMetadataType_MEDIA_TITLE = nil;
SDLMetadataType *SDLMetadataType_MEDIA_ARTIST = nil;
SDLMetadataType *SDLMetadataType_MEDIA_ALBUM = nil;
SDLMetadataType *SDLMetadataType_MEDIA_YEAR = nil;
SDLMetadataType *SDLMetadataType_MEDIA_GENRE = nil;
SDLMetadataType *SDLMetadataType_MEDIA_STATION = nil;
SDLMetadataType *SDLMetadataType_RATING = nil;
SDLMetadataType *SDLMetadataType_CURRENT_TEMPERATURE = nil;
SDLMetadataType *SDLMetadataType_MAXIMUM_TEMPERATURE = nil;
SDLMetadataType *SDLMetadataType_MINIMUM_TEMPERATURE = nil;
SDLMetadataType *SDLMetadataType_WEATHER_TERM = nil;
SDLMetadataType *SDLMetadataType_HUMIDITY = nil;

NSArray *SDLMetadataType_values = nil;

@implementation SDLMetadataType

+ (SDLMetadataType *)valueOf:(NSString *)value {
    for (SDLMetadataType *item in SDLMetadataType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLMetadataType_values == nil) {
        SDLMetadataType_values = @[
                                   SDLMetadataType.MEDIA_TITLE,
                                   SDLMetadataType.MEDIA_ARTIST,
                                   SDLMetadataType.MEDIA_ALBUM,
                                   SDLMetadataType.MEDIA_YEAR,
                                   SDLMetadataType.MEDIA_GENRE,
                                   SDLMetadataType.MEDIA_STATION,
                                   SDLMetadataType.RATING,
                                   SDLMetadataType.CURRENT_TEMPERATURE,
                                   SDLMetadataType.MAXIMUM_TEMPERATURE,
                                   SDLMetadataType.MINIMUM_TEMPERATURE,
                                   SDLMetadataType.WEATHER_TERM,
                                   SDLMetadataType.HUMIDITY];
    }
    return SDLMetadataType_values;
}

+ (SDLMetadataType *)MEDIA_TITLE {
    if (SDLMetadataType_MEDIA_TITLE== nil) {
        SDLMetadataType_MEDIA_TITLE = [[SDLMetadataType alloc] initWithValue:@"mediaTitle"];
    }
    return SDLMetadataType_MEDIA_TITLE;
}

+ (SDLMetadataType *)MEDIA_ARTIST {
    if (SDLMetadataType_MEDIA_ARTIST== nil) {
        SDLMetadataType_MEDIA_ARTIST = [[SDLMetadataType alloc] initWithValue:@"mediaArtist"];
    }
    return SDLMetadataType_MEDIA_ARTIST;
}

+ (SDLMetadataType *)MEDIA_ALBUM {
    if (SDLMetadataType_MEDIA_ALBUM== nil) {
        SDLMetadataType_MEDIA_ALBUM = [[SDLMetadataType alloc] initWithValue:@"mediaAlbum"];
    }
    return SDLMetadataType_MEDIA_ALBUM;
}

+ (SDLMetadataType *)MEDIA_YEAR {
    if (SDLMetadataType_MEDIA_YEAR == nil) {
        SDLMetadataType_MEDIA_YEAR = [[SDLMetadataType alloc] initWithValue:@"mediaYear"];
    }
    return SDLMetadataType_MEDIA_YEAR;
}

+ (SDLMetadataType *)MEDIA_GENRE {
    if (SDLMetadataType_MEDIA_GENRE == nil) {
        SDLMetadataType_MEDIA_GENRE = [[SDLMetadataType alloc] initWithValue:@"mediaGenre"];
    }
    return SDLMetadataType_MEDIA_GENRE;
}

+ (SDLMetadataType *)MEDIA_STATION {
    if (SDLMetadataType_MEDIA_STATION == nil) {
        SDLMetadataType_MEDIA_STATION = [[SDLMetadataType alloc] initWithValue:@"mediaStation"];
    }
    return SDLMetadataType_MEDIA_STATION;
}

+ (SDLMetadataType *)RATING {
    if (SDLMetadataType_RATING == nil) {
        SDLMetadataType_RATING = [[SDLMetadataType alloc] initWithValue:@"rating"];
    }
    return SDLMetadataType_RATING;
}

+ (SDLMetadataType *)CURRENT_TEMPERATURE {
    if (SDLMetadataType_CURRENT_TEMPERATURE == nil) {
        SDLMetadataType_CURRENT_TEMPERATURE = [[SDLMetadataType alloc] initWithValue:@"currentTemperature"];
    }
    return SDLMetadataType_CURRENT_TEMPERATURE;
}

+ (SDLMetadataType *)MAXIMUM_TEMPERATURE {
    if (SDLMetadataType_MAXIMUM_TEMPERATURE == nil) {
        SDLMetadataType_MAXIMUM_TEMPERATURE = [[SDLMetadataType alloc] initWithValue:@"maximumTemperature"];
    }
    return SDLMetadataType_MAXIMUM_TEMPERATURE;
}

+ (SDLMetadataType *)MINIMUM_TEMPERATURE {
    if (SDLMetadataType_MINIMUM_TEMPERATURE == nil) {
        SDLMetadataType_MINIMUM_TEMPERATURE = [[SDLMetadataType alloc] initWithValue:@"minimumTemperature"];
    }
    return SDLMetadataType_MINIMUM_TEMPERATURE;
}

+ (SDLMetadataType *)WEATHER_TERM {
    if (SDLMetadataType_WEATHER_TERM == nil) {
        SDLMetadataType_WEATHER_TERM = [[SDLMetadataType alloc] initWithValue:@"weatherTerm"];
    }
    return SDLMetadataType_WEATHER_TERM;
}

+ (SDLMetadataType *)HUMIDITY {
    if (SDLMetadataType_HUMIDITY == nil) {
        SDLMetadataType_HUMIDITY = [[SDLMetadataType alloc] initWithValue:@"humidity"];
    }
    return SDLMetadataType_HUMIDITY;
}

@end
