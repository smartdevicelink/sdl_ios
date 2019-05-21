//
//  SDLSISDataSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLSISData.h"
#import "SDLStationIDNumber.h"
#import "SDLGPSData.h"

QuickSpecBegin(SDLSISDataSpec)

SDLStationIDNumber *someID = [[SDLStationIDNumber alloc] init];
SDLGPSData *someLocation = [[SDLGPSData alloc] init];

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLSISData* testStruct = [[SDLSISData alloc] init];

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
        SDLSISData* testStruct = [[SDLSISData alloc] initWithStationShortName:@"short" stationIDNumber:someID stationLongName:@"long" stationLocation:someLocation stationMessage:@"message"];

        expect(testStruct.stationShortName).to(equal(@"short"));
        expect(testStruct.stationIDNumber).to(equal(someID));
        expect(testStruct.stationLongName).to(equal(@"long"));
        expect(testStruct.stationLocation).to(equal(someLocation));
        expect(testStruct.stationMessage).to(equal(@"message"));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameStationShortName:@"short",
                                       SDLRPCParameterNameStationLongName:@"long",
                                       SDLRPCParameterNameStationLocation:someLocation,
                                       SDLRPCParameterNameStationIDNumber:someID,
                                       SDLRPCParameterNameStationMessage:@"message"
                                       } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLSISData* testStruct = [[SDLSISData alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.stationShortName).to(equal(@"short"));
        expect(testStruct.stationIDNumber).to(equal(someID));
        expect(testStruct.stationLongName).to(equal(@"long"));
        expect(testStruct.stationLocation).to(equal(someLocation));
        expect(testStruct.stationMessage).to(equal(@"message"));
    });

    it(@"Should return nil if not set", ^ {
        SDLSISData* testStruct = [[SDLSISData alloc] init];

        expect(testStruct.stationShortName).to(beNil());
        expect(testStruct.stationIDNumber).to(beNil());
        expect(testStruct.stationLongName).to(beNil());
        expect(testStruct.stationLocation).to(beNil());
        expect(testStruct.stationMessage).to(beNil());


    });
});

QuickSpecEnd
