//
//  SDLMetadataTypeSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMetadataType.h"

QuickSpecBegin(SDLMetadataTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLMetadataTypeMediaTitle).to(equal(@"MEDIA_TITLE"));
        expect(SDLMetadataTypeMediaArtist).to(equal(@"MEDIA_ARTIST"));
        expect(SDLMetadataTypeMediaAlbum).to(equal(@"MEDIA_ALBUM"));
        expect(SDLMetadataTypeMediaYear).to(equal(@"MEDIA_YEAR"));
        expect(SDLMetadataTypeMediaGenre).to(equal(@"MEDIA_GENRE"));
        expect(SDLMetadataTypeMediaStation).to(equal(@"MEDIA_STATION"));
        expect(SDLMetadataTypeRating).to(equal(@"RATING"));
        expect(SDLMetadataTypeCurrentTemperature).to(equal(@"CURRENT_TEMPERATURE"));
        expect(SDLMetadataTypeMaximumTemperature).to(equal(@"MAXIMUM_TEMPERATURE"));
        expect(SDLMetadataTypeMinimumTemperature).to(equal(@"MINIMUM_TEMPERATURE"));
        expect(SDLMetadataTypeWeatherTerm).to(equal(@"WEATHER_TERM"));
        expect(SDLMetadataTypeHumidity).to(equal(@"HUMIDITY"));
    });
});

QuickSpecEnd
