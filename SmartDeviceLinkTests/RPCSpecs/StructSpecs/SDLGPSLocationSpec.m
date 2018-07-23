//
//  SDLGPSLocationSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLGPSLocation.h"



QuickSpecBegin(SDLGPSLocationSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLGPSLocation* testStruct = [[SDLGPSLocation alloc] init];

        testStruct.longitudeDegrees = @(-60);
        testStruct.latitudeDegrees = @60;
        testStruct.altitudeMeters = @5000;

        expect(testStruct.longitudeDegrees).to(equal(@(-60)));
        expect(testStruct.latitudeDegrees).to(equal(@60));
        expect(testStruct.altitudeMeters).to(equal(@5000));

    });

    it(@"Should set and get correctly", ^ {
        SDLGPSLocation* testStruct = [[SDLGPSLocation alloc] initWithLatitudeDegrees:-60 LongitudeDegrees:60];

        expect(testStruct.latitudeDegrees).to(equal(@(-60)));
        expect(testStruct.longitudeDegrees).to(equal(@60));
    });

    it(@"Should set and get correctly", ^ {
        SDLGPSLocation* testStruct = [[SDLGPSLocation alloc] initWithLatitudeDegrees:-60 LongitudeDegrees:60 altitudeMeter:@5000];

        expect(testStruct.latitudeDegrees).to(equal(@(-60)));
        expect(testStruct.longitudeDegrees).to(equal(@60));
        expect(testStruct.altitudeMeters).to(equal(@5000));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLNameLatitudeDegrees:@(-60),
                                       SDLNameLongitudeDegrees:@60,
                                       SDLNameAltitudeMeters:@5000
                                       } mutableCopy];

        SDLGPSLocation* testStruct = [[SDLGPSLocation alloc] initWithDictionary:dict];

        expect(testStruct.latitudeDegrees).to(equal(@(-60)));
        expect(testStruct.longitudeDegrees).to(equal(@60));
        expect(testStruct.altitudeMeters).to(equal(@5000));
    });

    it(@"Should return nil if not set", ^ {
        SDLGPSLocation* testStruct = [[SDLGPSLocation alloc] init];

        expect(testStruct.longitudeDegrees).to(beNil());
        expect(testStruct.latitudeDegrees).to(beNil());
        expect(testStruct.altitudeMeters).to(beNil());

    });
});

QuickSpecEnd
