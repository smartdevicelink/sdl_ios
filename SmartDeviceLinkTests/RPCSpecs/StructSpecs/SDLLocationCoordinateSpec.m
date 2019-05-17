//  SDLLocationCoordinateSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLocationCoordinate.h"
#import "SDLRPCParameterNames.h"


QuickSpecBegin(SDLLocationCoordinateSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLLocationCoordinate* testStruct = nil;
    __block NSNumber *someLatitude = nil;
    __block NSNumber *someLongitude = nil;
    
    
    describe(@"when initialized with init", ^{
        beforeEach(^{
            testStruct = [[SDLLocationCoordinate alloc] init];
        });
        
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someLatitude = @86.75;
                someLongitude = @(-3.09);
                
                testStruct.latitudeDegrees = someLatitude;
                testStruct.longitudeDegrees = someLongitude;
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get latitude correctly", ^{
                expect(testStruct.latitudeDegrees).to(equal(someLatitude));
                expect(testStruct.latitudeDegrees).to(beIdenticalTo(someLatitude));
            });
            
            it(@"should get longitude correctly", ^{
                expect(testStruct.longitudeDegrees).to(equal(someLongitude));
                expect(testStruct.longitudeDegrees).to(beIdenticalTo(someLongitude));
            });
        });
    });
    
    describe(@"when initialized with a dictionary", ^{
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someLongitude = @123.4567;
                someLatitude = @65.4321;
                NSDictionary *initDict = @{
                                           SDLRPCParameterNameLongitudeDegrees: someLongitude,
                                           SDLRPCParameterNameLatitudeDegrees: someLatitude,
                                           };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStruct = [[SDLLocationCoordinate alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
#pragma clang diagnostic pop
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get longitude correctly", ^{
                expect(testStruct.longitudeDegrees).to(equal(someLongitude));
                expect(testStruct.longitudeDegrees).to(beIdenticalTo(someLongitude));
            });
            
            it(@"should get latitude correctly", ^{
                expect(testStruct.latitudeDegrees).to(equal(someLatitude));
                expect(testStruct.latitudeDegrees).to(beIdenticalTo(someLatitude));
            });
        });

        context(@"when init with initWithLatitudeDegrees:longitudeDegrees", ^{
            it(@"should get and set correctly", ^{
                float testLatitude = 34.5;
                float testLongitude = 120.345;
                SDLLocationCoordinate *testStruct = [[SDLLocationCoordinate alloc] initWithLatitudeDegrees:testLatitude longitudeDegrees:testLongitude];

                expect(testStruct.latitudeDegrees).to(equal(testLatitude));
                expect(testStruct.longitudeDegrees).to(equal(testLongitude));
            });
        });

        context(@"when parameters are not set", ^{
            beforeEach(^{
                NSDictionary *initDict = @{
                                           };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                testStruct = [[SDLLocationCoordinate alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
#pragma clang diagnostic pop
            });
            
            it(@"should return nil for longitude", ^{
                expect(testStruct.longitudeDegrees).to(beNil());
            });
            
            it(@"should return nil for latitude", ^{
                expect(testStruct.latitudeDegrees).to(beNil());
            });
        });
    });
});

QuickSpecEnd
