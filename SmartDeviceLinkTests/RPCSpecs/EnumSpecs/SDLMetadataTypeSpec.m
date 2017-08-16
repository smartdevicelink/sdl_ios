//
//  SDLTextFieldTypeSpec.m
//  SmartDeviceLink-iOS
//
//  Created by Brett McIsaac on 8/1/17.
//  Copyright © 2017 smartdevicelink. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMetadataType.h"

QuickSpecBegin(SDLMetadataTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLMetadataType MEDIA_TITLE].value).to(equal(@"MEDIA_TITLE"));
        expect([SDLMetadataType MEDIA_ARTIST].value).to(equal(@"MEDIA_ARTIST"));
        expect([SDLMetadataType MEDIA_ALBUM].value).to(equal(@"MEDIA_ALBUM"));
        expect([SDLMetadataType MEDIA_YEAR].value).to(equal(@"MEDIA_YEAR"));
        expect([SDLMetadataType MEDIA_GENRE].value).to(equal(@"MEDIA_GENRE"));
        expect([SDLMetadataType MEDIA_STATION].value).to(equal(@"MEDIA_STATION"));
        expect([SDLMetadataType RATING].value).to(equal(@"RATING"));
        expect([SDLMetadataType CURRENT_TEMPERATURE].value).to(equal(@"CURRENT_TEMPERATURE"));
        expect([SDLMetadataType MAXIMUM_TEMPERATURE].value).to(equal(@"MAXIMUM_TEMPERATURE"));
        expect([SDLMetadataType MINIMUM_TEMPERATURE].value).to(equal(@"MINIMUM_TEMPERATURE"));
        expect([SDLMetadataType WEATHER_TERM].value).to(equal(@"WEATHER_TERM"));
        expect([SDLMetadataType HUMIDITY].value).to(equal(@"HUMIDITY"));

    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLMetadataType valueOf:@"MEDIA_TITLE"]).to(equal([SDLMetadataType MEDIA_TITLE]));
        expect([SDLMetadataType valueOf:@"MEDIA_ARTIST"]).to(equal([SDLMetadataType MEDIA_ARTIST]));
        expect([SDLMetadataType valueOf:@"MEDIA_ALBUM"]).to(equal([SDLMetadataType MEDIA_ALBUM]));
        expect([SDLMetadataType valueOf:@"MEDIA_YEAR"]).to(equal([SDLMetadataType MEDIA_YEAR]));
        expect([SDLMetadataType valueOf:@"MEDIA_GENRE"]).to(equal([SDLMetadataType MEDIA_GENRE]));
        expect([SDLMetadataType valueOf:@"MEDIA_STATION"]).to(equal([SDLMetadataType MEDIA_STATION]));
        expect([SDLMetadataType valueOf:@"RATING"]).to(equal([SDLMetadataType RATING]));
        expect([SDLMetadataType valueOf:@"CURRENT_TEMPERATURE"]).to(equal([SDLMetadataType CURRENT_TEMPERATURE]));
        expect([SDLMetadataType valueOf:@"MAXIMUM_TEMPERATURE"]).to(equal([SDLMetadataType MAXIMUM_TEMPERATURE]));
        expect([SDLMetadataType valueOf:@"MINIMUM_TEMPERATURE"]).to(equal([SDLMetadataType MINIMUM_TEMPERATURE]));
        expect([SDLMetadataType valueOf:@"WEATHER_TERM"]).to(equal([SDLMetadataType WEATHER_TERM]));
        expect([SDLMetadataType valueOf:@"HUMIDITY"]).to(equal([SDLMetadataType HUMIDITY]));
    });

    it(@"Should return nil when invalid", ^ {
        expect([SDLMetadataType valueOf:nil]).to(beNil());
        expect([SDLMetadataType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLMetadataType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLMetadataType MEDIA_TITLE],
                           [SDLMetadataType MEDIA_ARTIST],
                           [SDLMetadataType MEDIA_ALBUM],
                           [SDLMetadataType MEDIA_YEAR],
                           [SDLMetadataType MEDIA_GENRE],
                           [SDLMetadataType MEDIA_STATION],
                           [SDLMetadataType RATING],
                           [SDLMetadataType CURRENT_TEMPERATURE],
                           [SDLMetadataType MAXIMUM_TEMPERATURE],
                           [SDLMetadataType MINIMUM_TEMPERATURE],
                           [SDLMetadataType WEATHER_TERM],
                           [SDLMetadataType HUMIDITY]] copy];
    });

    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });

    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd
