//
//  SDLTextFieldTypeSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/2/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTextFieldType.h"

QuickSpecBegin(SDLTextFieldTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect(SDLTextFieldTypeMediaTitle).to(equal(@"MEDIA_TITLE"));
        expect(SDLTextFieldTypeMediaArtist).to(equal(@"MEDIA_ARTIST"));
        expect(SDLTextFieldTypeMediaAlbum).to(equal(@"MEDIA_ALBUM"));
        expect(SDLTextFieldTypeMediaYear).to(equal(@"MEDIA_YEAR"));
        expect(SDLTextFieldTypeMediaGenre).to(equal(@"MEDIA_GENRE"));
        expect(SDLTextFieldTypeMediaStation).to(equal(@"MEDIA_STATION"));
        expect(SDLTextFieldTypeRating).to(equal(@"RATING"));
        expect(SDLTextFieldTypeCurrentTemperature).to(equal(@"CURRENT_TEMPERATURE"));
        expect(SDLTextFieldTypeMaximumTemperature).to(equal(@"MAXIMUM_TEMPERATURE"));
        expect(SDLTextFieldTypeMinimumTemperature).to(equal(@"MINIMUM_TEMPERATURE"));
        expect(SDLTextFieldTypeWeatherTerm).to(equal(@"WEATHER_TERM"));
        expect(SDLTextFieldTypeHumidity).to(equal(@"HUMIDITY"));
    });
});

QuickSpecEnd
