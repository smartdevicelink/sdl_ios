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
        expect(SDLMetadataTypeMediaTitle).to(equal(@"mediaTitle"));
        expect(SDLMetadataTypeMediaArtist).to(equal(@"mediaArtist"));
        expect(SDLMetadataTypeMediaAlbum).to(equal(@"mediaAlbum"));
        expect(SDLMetadataTypeMediaYear).to(equal(@"mediaYear"));
        expect(SDLMetadataTypeMediaGenre).to(equal(@"mediaGenre"));
        expect(SDLMetadataTypeMediaStation).to(equal(@"mediaStation"));
        expect(SDLMetadataTypeRating).to(equal(@"rating"));
        expect(SDLMetadataTypeCurrentTemperature).to(equal(@"currentTemperature"));
        expect(SDLMetadataTypeMaximumTemperature).to(equal(@"maximumTemperature"));
        expect(SDLMetadataTypeMinimumTemperature).to(equal(@"minimumTemperature"));
        expect(SDLMetadataTypeWeatherTerm).to(equal(@"weatherTerm"));
        expect(SDLMetadataTypeHumidity).to(equal(@"humidity"));
    });
});

QuickSpecEnd
