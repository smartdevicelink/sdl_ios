//
//  SDLTextFieldType.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import "SDLTextFieldType.h"

SDLTextFieldType *SDLTextFieldType_MEDIA_TITLE = nil;
SDLTextFieldType *SDLTextFieldType_MEDIA_ARTIST = nil;
SDLTextFieldType *SDLTextFieldType_MEDIA_ALBUM = nil;
SDLTextFieldType *SDLTextFieldType_MEDIA_YEAR = nil;
SDLTextFieldType *SDLTextFieldType_MEDIA_GENRE = nil;
SDLTextFieldType *SDLTextFieldType_MEDIA_STATION = nil;
SDLTextFieldType *SDLTextFieldType_RATING = nil;
SDLTextFieldType *SDLTextFieldType_CURRENT_TEMPERATURE = nil;
SDLTextFieldType *SDLTextFieldType_MAXIMUM_TEMPERATURE = nil;
SDLTextFieldType *SDLTextFieldType_MINIMUM_TEMPERATURE = nil;
SDLTextFieldType *SDLTextFieldType_WEATHER_TERM = nil;
SDLTextFieldType *SDLTextFieldType_HUMIDITY = nil;

NSArray *SDLTextFieldType_values = nil;

@implementation SDLTextFieldType

+ (SDLTextFieldType *)valueOf:(NSString *)value {
    for (SDLTextFieldType *item in SDLTextFieldType.values) {
        if ([item.value isEqualToString:value]) {
            return item;
        }
    }
    return nil;
}

+ (NSArray *)values {
    if (SDLTextFieldType_values == nil) {
        SDLTextFieldType_values = @[
                                    SDLTextFieldType.MEDIA_TITLE,
                                    SDLTextFieldType.MEDIA_ARTIST,
                                    SDLTextFieldType.MEDIA_ALBUM,
                                    SDLTextFieldType.MEDIA_YEAR,
                                    SDLTextFieldType.MEDIA_GENRE,
                                    SDLTextFieldType.MEDIA_STATION,
                                    SDLTextFieldType.RATING,
                                    SDLTextFieldType.CURRENT_TEMPERATURE,
                                    SDLTextFieldType.MAXIMUM_TEMPERATURE,
                                    SDLTextFieldType.MINIMUM_TEMPERATURE,
                                    SDLTextFieldType.WEATHER_TERM,
                                    SDLTextFieldType.HUMIDITY];
    }
    return SDLTextFieldType_values;
}

+ (SDLTextFieldType *)MEDIA_TITLE {
    if (SDLTextFieldType_MEDIA_TITLE== nil) {
        SDLTextFieldType_MEDIA_TITLE = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_TITLE"];
    }
    return SDLTextFieldType_MEDIA_TITLE;
}

+ (SDLTextFieldType *)MEDIA_ARTIST {
    if (SDLTextFieldType_MEDIA_ARTIST== nil) {
        SDLTextFieldType_MEDIA_ARTIST = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_ARTIST"];
    }
    return SDLTextFieldType_MEDIA_ARTIST;
}

+ (SDLTextFieldType *)MEDIA_ALBUM {
    if (SDLTextFieldType_MEDIA_ALBUM== nil) {
        SDLTextFieldType_MEDIA_ALBUM = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_ALBUM"];
    }
    return SDLTextFieldType_MEDIA_ALBUM;
}

+ (SDLTextFieldType *)MEDIA_YEAR {
    if (SDLTextFieldType_MEDIA_YEAR== nil) {
        SDLTextFieldType_MEDIA_YEAR = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_YEAR"];
    }
    return SDLTextFieldType_MEDIA_YEAR;
}

+ (SDLTextFieldType *)MEDIA_GENRE {
    if (SDLTextFieldType_MEDIA_GENRE== nil) {
        SDLTextFieldType_MEDIA_GENRE = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_GENRE"];
    }
    return SDLTextFieldType_MEDIA_GENRE;
}

+ (SDLTextFieldType *)MEDIA_STATION {
    if (SDLTextFieldType_MEDIA_STATION== nil) {
        SDLTextFieldType_MEDIA_STATION = [[SDLTextFieldType alloc] initWithValue:@"MEDIA_STATION"];
    }
    return SDLTextFieldType_MEDIA_STATION;
}

+ (SDLTextFieldType *)RATING {
    if (SDLTextFieldType_RATING== nil) {
        SDLTextFieldType_RATING = [[SDLTextFieldType alloc] initWithValue:@"RATING"];
    }
    return SDLTextFieldType_RATING;
}

+ (SDLTextFieldType *)CURRENT_TEMPERATURE {
    if (SDLTextFieldType_CURRENT_TEMPERATURE== nil) {
        SDLTextFieldType_CURRENT_TEMPERATURE = [[SDLTextFieldType alloc] initWithValue:@"CURRENT_TEMPERATURE"];
    }
    return SDLTextFieldType_CURRENT_TEMPERATURE;
}

+ (SDLTextFieldType *)MAXIMUM_TEMPERATURE {
    if (SDLTextFieldType_MAXIMUM_TEMPERATURE== nil) {
        SDLTextFieldType_MAXIMUM_TEMPERATURE = [[SDLTextFieldType alloc] initWithValue:@"MAXIMUM_TEMPERATURE"];
    }
    return SDLTextFieldType_MAXIMUM_TEMPERATURE;
}

+ (SDLTextFieldType *)MINIMUM_TEMPERATURE {
    if (SDLTextFieldType_MINIMUM_TEMPERATURE== nil) {
        SDLTextFieldType_MINIMUM_TEMPERATURE = [[SDLTextFieldType alloc] initWithValue:@"MINIMUM_TEMPERATURE"];
    }
    return SDLTextFieldType_MINIMUM_TEMPERATURE;
}

+ (SDLTextFieldType *)WEATHER_TERM {
    if (SDLTextFieldType_WEATHER_TERM== nil) {
        SDLTextFieldType_WEATHER_TERM = [[SDLTextFieldType alloc] initWithValue:@"WEATHER_TERM"];
    }
    return SDLTextFieldType_WEATHER_TERM;
}

+ (SDLTextFieldType *)HUMIDITY {
    if (SDLTextFieldType_HUMIDITY== nil) {
        SDLTextFieldType_HUMIDITY = [[SDLTextFieldType alloc] initWithValue:@"HUMIDITY"];
    }
    return SDLTextFieldType_HUMIDITY;
}

@end
