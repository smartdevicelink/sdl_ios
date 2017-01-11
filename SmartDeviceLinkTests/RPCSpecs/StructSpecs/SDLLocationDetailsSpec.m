//  SDLLocationDetailsSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLocationDetails.h"

#import "SDLImage.h"
#import "SDLLocationCoordinate.h"
#import "SDLNames.h"
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
                                           NAMES_locationCoordinate: someCoordinate,
                                           NAMES_locationName: someLocation,
                                           NAMES_locationDescription: someLocationDescription,
                                           NAMES_addressLines: someAddressLines,
                                           NAMES_phoneNumber: somePhoneNumber,
                                           NAMES_locationImage: someImage,
                                           NAMES_searchAddress: someAddress
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
                                           NAMES_request: @{
                                                   NAMES_parameters: @{}
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
