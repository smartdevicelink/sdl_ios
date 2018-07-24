//
//  SDLSisDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSisData.h"
#import "SDLStationIDNumber.h"
#import "SDLGPSLocation.h"


QuickSpecBegin(SDLSisDataSpec)

SDLStationIDNumber *someID = [[SDLStationIDNumber alloc] init];
SDLGPSLocation *someLocation = [[SDLGPSLocation alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSisData* testStruct = [[SDLSisData alloc] init];

        testStruct.stationShortName = @"short";
        testStruct.stationIDNumber = someID;
        testStruct.stationLongName = @"long";
        testStruct.stationLocation = someLocation;
        testStruct.stationMessage = @"message";


        expect(testStruct.stationShortName).to(equal(@"short"));
        expect(testStruct.stationIDNumber).to(equal(someID));
        expect(testStruct.stationLongName).to(equal(@"long"));
        expect(testStruct.stationLocation).to(equal(someLocation));
        expect(testStruct.stationMessage).to(equal(@"message"));

    });

    it(@"Should set and get correctly", ^ {
        SDLSisData* testStruct = [[SDLSisData alloc] initWithStationShortName:@"short" stationID:someID stationLongName:@"long" stationLocation:someLocation stationMessage:@"message"];

        expect(testStruct.stationShortName).to(equal(@"short"));
        expect(testStruct.stationIDNumber).to(equal(someID));
        expect(testStruct.stationLongName).to(equal(@"long"));
        expect(testStruct.stationLocation).to(equal(someLocation));
        expect(testStruct.stationMessage).to(equal(@"message"));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameStationShortName:@"short",
                                       SDLNameStationLongName:@"long",
                                       SDLNameStationLocation:someLocation,
                                       SDLNameStationIDNumber:someID,
                                       SDLNameStationMessage:@"message"
                                       } mutableCopy];

        SDLSisData* testStruct = [[SDLSisData alloc] initWithDictionary:dict];

        expect(testStruct.stationShortName).to(equal(@"short"));
        expect(testStruct.stationIDNumber).to(equal(someID));
        expect(testStruct.stationLongName).to(equal(@"long"));
        expect(testStruct.stationLocation).to(equal(someLocation));
        expect(testStruct.stationMessage).to(equal(@"message"));
    });

    it(@"Should return nil if not set", ^ {
        SDLSisData* testStruct = [[SDLSisData alloc] init];

        expect(testStruct.stationShortName).to(beNil());
        expect(testStruct.stationIDNumber).to(beNil());
        expect(testStruct.stationLongName).to(beNil());
        expect(testStruct.stationLocation).to(beNil());
        expect(testStruct.stationMessage).to(beNil());


    });
});

QuickSpecEnd
