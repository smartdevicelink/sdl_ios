//
//  SDLStationIDNumberSpec.m
//  SmartDeviceLinkTests=
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLStationIDNumber.h"

QuickSpecBegin(SDLStationIDNumberSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLStationIDNumber* testStruct = [[SDLStationIDNumber alloc] init];

        testStruct.countryCode = @91;
        testStruct.fccFacilityId = @23;

        expect(testStruct.countryCode).to(equal(@91));
        expect(testStruct.fccFacilityId).to(equal(@23));;

    });

    it(@"Should set and get correctly", ^ {
        SDLStationIDNumber* testStruct = [[SDLStationIDNumber alloc] initWithCountryCode:@91 fccFacilityId:@23];

        expect(testStruct.countryCode).to(equal(@91));
        expect(testStruct.fccFacilityId).to(equal(@23));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameCountryCode:@91,
                                       SDLNameFccFacilityId:@23
                                       } mutableCopy];

        SDLStationIDNumber* testStruct = [[SDLStationIDNumber alloc] initWithDictionary:dict];

        expect(testStruct.countryCode).to(equal(@91));
        expect(testStruct.fccFacilityId).to(equal(@23));
    });

    it(@"Should return nil if not set", ^ {
        SDLStationIDNumber* testStruct = [[SDLStationIDNumber alloc] init];

        expect(testStruct.countryCode).to(beNil());
        expect(testStruct.fccFacilityId).to(beNil());
    });
});

QuickSpecEnd
