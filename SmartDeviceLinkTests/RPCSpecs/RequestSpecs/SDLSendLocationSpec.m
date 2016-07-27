//
//  SDLSendLocationSpec.m
//  SmartDeviceLink-iOS

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
#import "SDLSendLocation.h"


QuickSpecBegin(SDLSendLocationSpec)

describe(@"Send Location RPC", ^{
    __block SDLSendLocation *testRequest = nil;
    __block NSNumber *someLongitude = nil;
    __block NSNumber *someLatitude = nil;
    __block NSString *someLocation = nil;
    __block NSString *someLocationDescription = nil;
    __block NSArray *someAddressLines = nil;
    __block NSString *somePhoneNumber = nil;
    __block SDLImage *someImage = nil;
    
    describe(@"when initialized with init", ^{
        beforeEach(^{
            testRequest = [[SDLSendLocation alloc] init];
        });
        
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someLongitude = @123.4567;
                someLatitude = @65.4321;
                someLocation = @"Livio";
                someLocationDescription = @"A great place to work";
                someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
                somePhoneNumber = @"248-591-0333";
                someImage = [[SDLImage alloc] init];
                
                testRequest.longitudeDegrees = someLongitude;
                testRequest.latitudeDegrees = someLatitude;
                testRequest.locationName = someLocation;
                testRequest.locationDescription = someLocationDescription;
                testRequest.addressLines = someAddressLines;
                testRequest.phoneNumber = somePhoneNumber;
                testRequest.locationImage = someImage;
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get longitude correctly", ^{
                expect(testRequest.longitudeDegrees).to(equal(someLongitude));
                expect(testRequest.longitudeDegrees).to(beIdenticalTo(someLongitude));
            });
            
            it(@"should get latitude correctly", ^{
                expect(testRequest.latitudeDegrees).to(equal(someLatitude));
                expect(testRequest.latitudeDegrees).to(beIdenticalTo(someLatitude));
            });
            
            it(@"should get location correctly", ^{
                expect(testRequest.locationName).to(equal(someLocation));
                expect(testRequest.locationName).to(beIdenticalTo(someLocation));
            });
            
            it(@"should get location description correctly", ^{
                expect(testRequest.locationDescription).to(equal(someLocationDescription));
                expect(testRequest.locationDescription).to(beIdenticalTo(someLocationDescription));
            });
            
            it(@"should get address lines correctly", ^{
                expect(testRequest.addressLines).to(equal(someAddressLines));
                expect(testRequest.addressLines).to(beIdenticalTo(someAddressLines));
            });
            
            it(@"should get phone number correctly", ^{
                expect(testRequest.phoneNumber).to(equal(somePhoneNumber));
                expect(testRequest.phoneNumber).to(beIdenticalTo(somePhoneNumber));
            });
            
            it(@"should get image correctly", ^{
                expect(testRequest.locationImage).to(equal(someImage));
                expect(testRequest.locationImage).to(beIdenticalTo(someImage));
            });
        });
        
        context(@"when parameters are not set", ^{
            it(@"should return nil for longitude", ^{
                expect(testRequest.longitudeDegrees).to(beNil());
            });
            
            it(@"should return nil for latitude", ^{
                expect(testRequest.latitudeDegrees).to(beNil());
            });
            
            it(@"should return nil for location", ^{
                expect(testRequest.locationName).to(beNil());
            });
            
            it(@"should return nil for location description", ^{
                expect(testRequest.locationDescription).to(beNil());
            });
            
            it(@"should return nil for address lines", ^{
                expect(testRequest.addressLines).to(beNil());
            });
            
            it(@"should return nil for phone number", ^{
                expect(testRequest.phoneNumber).to(beNil());
            });
            
            it(@"should return nil for image", ^{
                expect(testRequest.locationImage).to(beNil());
            });
        });
    });
    
    describe(@"when initialized with a dictionary", ^{
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                someLongitude = @123.4567;
                someLatitude = @65.4321;
                someLocation = @"Livio";
                someLocationDescription = @"A great place to work";
                someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
                somePhoneNumber = @"248-591-0333";
                someImage = [[SDLImage alloc] init];
                NSDictionary *initDict = @{
                                           NAMES_request: @{
                                                   NAMES_parameters: @{
                                                           NAMES_longitudeDegrees: someLongitude,
                                                           NAMES_latitudeDegrees: someLatitude,
                                                           NAMES_locationName: someLocation,
                                                           NAMES_locationDescription: someLocationDescription,
                                                           NAMES_addressLines: someAddressLines,
                                                           NAMES_phoneNumber: somePhoneNumber,
                                                           NAMES_locationImage: someImage
                                                           }
                                                   }
                                           };
                
                testRequest = [[SDLSendLocation alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get longitude correctly", ^{
                expect(testRequest.longitudeDegrees).to(equal(someLongitude));
                expect(testRequest.longitudeDegrees).to(beIdenticalTo(someLongitude));
            });
            
            it(@"should get latitude correctly", ^{
                expect(testRequest.latitudeDegrees).to(equal(someLatitude));
                expect(testRequest.latitudeDegrees).to(beIdenticalTo(someLatitude));
            });
            
            it(@"should get location correctly", ^{
                expect(testRequest.locationName).to(equal(someLocation));
                expect(testRequest.locationName).to(beIdenticalTo(someLocation));
            });
            
            it(@"should get location description correctly", ^{
                expect(testRequest.locationDescription).to(equal(someLocationDescription));
                expect(testRequest.locationDescription).to(beIdenticalTo(someLocationDescription));
            });
            
            it(@"should get address lines correctly", ^{
                expect(testRequest.addressLines).to(equal(someAddressLines));
                expect(testRequest.addressLines).to(beIdenticalTo(someAddressLines));
            });
            
            it(@"should get phone number correctly", ^{
                expect(testRequest.phoneNumber).to(equal(somePhoneNumber));
                expect(testRequest.phoneNumber).to(beIdenticalTo(somePhoneNumber));
            });
            
            it(@"should get image correctly", ^{
                expect(testRequest.locationImage).to(equal(someImage));
                expect(testRequest.locationImage).to(beIdenticalTo(someImage));
            });
        });
    
        context(@"when parameters are not set", ^{
            beforeEach(^{
                NSDictionary *initDict = @{
                                           NAMES_request: @{
                                                   NAMES_parameters: @{}
                                                   }
                                           };
                
                testRequest = [[SDLSendLocation alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            it(@"should return nil for longitude", ^{
                expect(testRequest.longitudeDegrees).to(beNil());
            });
            
            it(@"should return nil for latitude", ^{
                expect(testRequest.latitudeDegrees).to(beNil());
            });
            
            it(@"should return nil for location", ^{
                expect(testRequest.locationName).to(beNil());
            });
            
            it(@"should return nil for location description", ^{
                expect(testRequest.locationDescription).to(beNil());
            });
            
            it(@"should return nil for address lines", ^{
                expect(testRequest.addressLines).to(beNil());
            });
            
            it(@"should return nil for phone number", ^{
                expect(testRequest.phoneNumber).to(beNil());
            });
            
            it(@"should return nil for image", ^{
                expect(testRequest.locationImage).to(beNil());
            });
        });
    });
});

QuickSpecEnd
