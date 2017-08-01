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

#import "SDLTextFieldType.h"

QuickSpecBegin(SDLTextFieldTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTextFieldType MEDIA_TITLE].value).to(equal(@"MEDIA_TITLE"));
        expect([SDLTextFieldType MEDIA_ARTIST].value).to(equal(@"MEDIA_ARTIST"));
        expect([SDLTextFieldType MEDIA_ALBUM].value).to(equal(@"MEDIA_ALBUM"));
        expect([SDLTextFieldType MEDIA_YEAR].value).to(equal(@"MEDIA_YEAR"));
        expect([SDLTextFieldType MEDIA_GENRE].value).to(equal(@"MEDIA_GENRE"));
        expect([SDLTextFieldType MEDIA_STATION].value).to(equal(@"MEDIA_STATION"));
        expect([SDLTextFieldType RATING].value).to(equal(@"RATING"));
        expect([SDLTextFieldType CURRENT_TEMPERATURE].value).to(equal(@"CURRENT_TEMPERATURE"));
        expect([SDLTextFieldType MAXIMUM_TEMPERATURE].value).to(equal(@"MAXIMUM_TEMPERATURE"));
        expect([SDLTextFieldType MINIMUM_TEMPERATURE].value).to(equal(@"MINIMUM_TEMPERATURE"));
        expect([SDLTextFieldType WEATHER_TERM].value).to(equal(@"WEATHER_TERM"));
        expect([SDLTextFieldType HUMIDITY].value).to(equal(@"HUMIDITY"));

    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTextFieldType valueOf:@"MEDIA_TITLE"]).to(equal([SDLTextFieldType MEDIA_TITLE]));
        expect([SDLTextFieldType valueOf:@"MEDIA_ARTIST"]).to(equal([SDLTextFieldType MEDIA_ARTIST]));
        expect([SDLTextFieldType valueOf:@"MEDIA_ALBUM"]).to(equal([SDLTextFieldType MEDIA_ALBUM]));
        expect([SDLTextFieldType valueOf:@"MEDIA_YEAR"]).to(equal([SDLTextFieldType MEDIA_YEAR]));
        expect([SDLTextFieldType valueOf:@"MEDIA_GENRE"]).to(equal([SDLTextFieldType MEDIA_GENRE]));
        expect([SDLTextFieldType valueOf:@"MEDIA_STATION"]).to(equal([SDLTextFieldType MEDIA_STATION]));
        expect([SDLTextFieldType valueOf:@"RATING"]).to(equal([SDLTextFieldType RATING]));
        expect([SDLTextFieldType valueOf:@"CURRENT_TEMPERATURE"]).to(equal([SDLTextFieldType CURRENT_TEMPERATURE]));
        expect([SDLTextFieldType valueOf:@"MAXIMUM_TEMPERATURE"]).to(equal([SDLTextFieldType MAXIMUM_TEMPERATURE]));
        expect([SDLTextFieldType valueOf:@"MINIMUM_TEMPERATURE"]).to(equal([SDLTextFieldType MINIMUM_TEMPERATURE]));
        expect([SDLTextFieldType valueOf:@"WEATHER_TERM"]).to(equal([SDLTextFieldType WEATHER_TERM]));
        expect([SDLTextFieldType valueOf:@"HUMIDITY"]).to(equal([SDLTextFieldType HUMIDITY]));
    });

    it(@"Should return nil when invalid", ^ {
        expect([SDLTextFieldType valueOf:nil]).to(beNil());
        expect([SDLTextFieldType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLTextFieldType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTextFieldType MEDIA_TITLE],
                           [SDLTextFieldType MEDIA_ARTIST],
                           [SDLTextFieldType MEDIA_ALBUM],
                           [SDLTextFieldType MEDIA_YEAR],
                           [SDLTextFieldType MEDIA_GENRE],
                           [SDLTextFieldType MEDIA_STATION],
                           [SDLTextFieldType RATING],
                           [SDLTextFieldType CURRENT_TEMPERATURE],
                           [SDLTextFieldType MAXIMUM_TEMPERATURE],
                           [SDLTextFieldType MINIMUM_TEMPERATURE],
                           [SDLTextFieldType WEATHER_TERM],
                           [SDLTextFieldType HUMIDITY]] copy];
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
