//  SDLLocationDetailsSpec.m
//

#import <Foundation/Foundation.h>

@import Quick;
@import Nimble;

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLRPCParameterNames.h"
#import "SDLOasisAddress.h"

QuickSpecBegin(SDLLocationDetailsSpec)

describe(@"Getter/Setter Tests", ^ {
    __block SDLLocationDetails *testStruct = nil;
    __block NSString *someLocation = nil;
    __block NSString *someLocationDescription = nil;
    __block NSArray *someAddressLines = nil;
    __block NSString *somePhoneNumber = nil;
    __block SDLImage* someImage = nil;
    __block SDLLocationCoordinate* someCoordinate = nil;
    __block SDLOasisAddress* someAddress = nil;
    
    describe(@"when initialized with init", ^{
        beforeEach(^{
            testStruct = [[SDLLocationDetails alloc] init];
        });
        
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someCoordinate = [[SDLLocationCoordinate alloc] init];
                someLocation = @"Livio";
                someLocationDescription = @"A great place to work";
                someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
                somePhoneNumber = @"248-591-0333";
                someImage = [[SDLImage alloc] init];
                someAddress = [[SDLOasisAddress alloc] init];
                
                testStruct.coordinate = someCoordinate;
                testStruct.locationName = someLocation;
                testStruct.locationDescription = someLocationDescription;
                testStruct.addressLines = someAddressLines;
                testStruct.phoneNumber = somePhoneNumber;
                testStruct.locationImage = someImage;
                testStruct.searchAddress = someAddress;
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get coordinate correctly", ^{
                expect(testStruct.coordinate).to(equal(someCoordinate));
                expect(testStruct.coordinate).to(beIdenticalTo(someCoordinate));
            });
            
            it(@"should get location correctly", ^{
                expect(testStruct.locationName).to(equal(someLocation));
                expect(testStruct.locationName).to(beIdenticalTo(someLocation));
            });
            
            it(@"should get location description correctly", ^{
                expect(testStruct.locationDescription).to(equal(someLocationDescription));
                expect(testStruct.locationDescription).to(beIdenticalTo(someLocationDescription));
            });
            
            it(@"should get address lines correctly", ^{
                expect(testStruct.addressLines).to(equal(someAddressLines));
                expect(testStruct.addressLines).to(beIdenticalTo(someAddressLines));
            });
            
            it(@"should get phone number correctly", ^{
                expect(testStruct.phoneNumber).to(equal(somePhoneNumber));
                expect(testStruct.phoneNumber).to(beIdenticalTo(somePhoneNumber));
            });
            
            it(@"should get image correctly", ^{
                expect(testStruct.locationImage).to(equal(someImage));
                expect(testStruct.locationImage).to(beIdenticalTo(someImage));
            });
            
            it(@"should get address correctly", ^{
                expect(testStruct.searchAddress).to(equal(someAddress));
                expect(testStruct.searchAddress).to(beIdenticalTo(someAddress));
            });
   
        });
    });

    context(@"when initialized with a convenience init", ^{
        __block SDLLocationCoordinate *testCoordinate = nil;
        __block NSString *testLocationName = nil;
        __block NSArray<NSString *> *testAddressLines = nil;
        __block NSString *testLocationDescription = nil;
        __block NSString *testPhoneNumber = nil;
        __block SDLImage *testLocationImage = nil;
        __block SDLOasisAddress *testSearchAddress = nil;

        beforeEach(^{
            testCoordinate = [[SDLLocationCoordinate alloc] init];
            testLocationName = @"testLocationName";
            testAddressLines = @[@"testAddressLines1", @"testAddressLines2"];
            testLocationDescription = @"testLocationDescription";
            testPhoneNumber = @"testPhoneNumber";
            testLocationImage = [[SDLImage alloc] initWithStaticIconName:SDLStaticIconNameKey];
            testSearchAddress = [[SDLOasisAddress alloc] init];
        });

        it(@"should init correctly with initWithCoordinate:", ^{
            testStruct = [[SDLLocationDetails alloc] initWithCoordinate:testCoordinate];

            expect(testStruct.coordinate).to(equal(testCoordinate));
            expect(testStruct.locationName).to(beNil());
            expect(testStruct.addressLines).to(beNil());
            expect(testStruct.locationDescription).to(beNil());
            expect(testStruct.phoneNumber).to(beNil());
            expect(testStruct.locationImage).to(beNil());
            expect(testStruct.searchAddress).to(beNil());
        });

        it(@"should init correctly with all parameters", ^{
            testStruct = [[SDLLocationDetails alloc] initWithCoordinate:testCoordinate locationName:testLocationName addressLines:testAddressLines locationDescription:testLocationDescription phoneNumber:testPhoneNumber locationImage:testLocationImage searchAddress:testSearchAddress];

            expect(testStruct.coordinate).to(equal(testCoordinate));
            expect(testStruct.locationName).to(equal(testLocationName));
            expect(testStruct.addressLines).to(equal(testAddressLines));
            expect(testStruct.locationDescription).to(equal(testLocationDescription));
            expect(testStruct.phoneNumber).to(equal(testPhoneNumber));
            expect(testStruct.locationImage).to(equal(testLocationImage));
            expect(testStruct.searchAddress).to(equal(testSearchAddress));
        });

    });
    
    describe(@"when initialized with a dictionary", ^{
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someCoordinate = [[SDLLocationCoordinate alloc] init];
                someLocation = @"Livio";
                someLocationDescription = @"A great place to work";
                someAddressLines = @[@"332 E Lincoln Ave", @"Royal Oak, MI", @"48067"];
                somePhoneNumber = @"248-591-0333";
                someImage = [[SDLImage alloc] init];
                someAddress = [[SDLOasisAddress alloc] initWithSubThoroughfare:@"test" thoroughfare:@"1" locality:@"local" administrativeArea:@"admin" postalCode:@"48067" countryCode:@"12345"];
                NSDictionary *initDict = @{
                                           SDLRPCParameterNameLocationCoordinate: someCoordinate,
                                           SDLRPCParameterNameLocationName: someLocation,
                                           SDLRPCParameterNameLocationDescription: someLocationDescription,
                                           SDLRPCParameterNameAddressLines: someAddressLines,
                                           SDLRPCParameterNamePhoneNumber: somePhoneNumber,
                                           SDLRPCParameterNameLocationImage: someImage,
                                           SDLRPCParameterNameSearchAddress: someAddress
                                           };
                testStruct = [[SDLLocationDetails alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get coordinate correctly", ^{
                expect(testStruct.coordinate).to(equal(someCoordinate));
                expect(testStruct.coordinate).to(beIdenticalTo(someCoordinate));
            });
            
            it(@"should get location correctly", ^{
                expect(testStruct.locationName).to(equal(someLocation));
                expect(testStruct.locationName).to(beIdenticalTo(someLocation));
            });
            
            it(@"should get location description correctly", ^{
                expect(testStruct.locationDescription).to(equal(someLocationDescription));
                expect(testStruct.locationDescription).to(beIdenticalTo(someLocationDescription));
            });
            
            it(@"should get address lines correctly", ^{
                expect(testStruct.addressLines).to(equal(someAddressLines));
                expect(testStruct.addressLines).to(beIdenticalTo(someAddressLines));
            });
            
            it(@"should get phone number correctly", ^{
                expect(testStruct.phoneNumber).to(equal(somePhoneNumber));
                expect(testStruct.phoneNumber).to(beIdenticalTo(somePhoneNumber));
            });
            
            it(@"should get image correctly", ^{
                expect(testStruct.locationImage).to(equal(someImage));
                expect(testStruct.locationImage).to(beIdenticalTo(someImage));
            });

            it(@"should get address correctly", ^{
                expect(testStruct.searchAddress).to(equal(someAddress));
                expect(testStruct.searchAddress).to(beIdenticalTo(someAddress));
            });
        });
        
        context(@"when parameters are not set", ^{
            beforeEach(^{
                NSDictionary *initDict = @{
                                           SDLRPCParameterNameRequest: @{
                                                   SDLRPCParameterNameParameters: @{}
                                                   }
                                           };
                testStruct = [[SDLLocationDetails alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            it(@"should return nil for coordinate", ^{
                expect(testStruct.coordinate).to(beNil());
            });
            
            it(@"should return nil for location", ^{
                expect(testStruct.locationName).to(beNil());
            });
            
            it(@"should return nil for location description", ^{
                expect(testStruct.locationDescription).to(beNil());
            });
            
            it(@"should return nil for address lines", ^{
                expect(testStruct.addressLines).to(beNil());
            });
            
            it(@"should return nil for phone number", ^{
                expect(testStruct.phoneNumber).to(beNil());
            });
            
            it(@"should return nil for image", ^{
                expect(testStruct.locationImage).to(beNil());
            });
            
            it(@"should return nil for address", ^{
                expect(testStruct.searchAddress).to(beNil());
            });
        });
    });
});

QuickSpecEnd
