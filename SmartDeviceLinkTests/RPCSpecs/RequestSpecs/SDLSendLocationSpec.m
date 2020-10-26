//
//  SDLSendLocationSpec.m
//  SmartDeviceLink-iOS

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLRPCFunctionNames.h"
#import "SDLSendLocation.h"


QuickSpecBegin(SDLSendLocationSpec)

describe(@"Send Location RPC", ^{
    __block SDLSendLocation *testRequest = nil;
    __block NSNumber *someLongitude = nil;
    __block NSNumber *someLatitude = nil;
    __block NSString *someLocation = nil;
    __block NSString *someLocationDescription = nil;
    __block NSArray<NSString *> *someAddressLines = nil;
    __block NSString *somePhoneNumber = nil;
    __block SDLImage *someImage = nil;
    __block SDLDeliveryMode someDeliveryMode = nil;
    __block SDLDateTime* someTime = nil;
    __block SDLOasisAddress* someAddress = nil;
    
    describe(@"when initialized with init", ^{
        beforeEach(^{
            someLongitude = @123.4567;
            someLatitude = @65.4321;
            someLocation = @"Livio";
            someLocationDescription = @"A great place to work";
            someAddressLines = @[@"3136 Hilton Rd", @"Ferndale, MI", @"48220"];
            somePhoneNumber = @"248-591-0333";
            someImage = [[SDLImage alloc] init];
            someDeliveryMode = SDLDeliveryModePrompt;
            someTime = [[SDLDateTime alloc] init];
            someAddress = [[SDLOasisAddress alloc] init];
            testRequest = [[SDLSendLocation alloc] init];
        });
        
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                testRequest.longitudeDegrees = someLongitude;
                testRequest.latitudeDegrees = someLatitude;
                testRequest.locationName = someLocation;
                testRequest.locationDescription = someLocationDescription;
                testRequest.addressLines = someAddressLines;
                testRequest.phoneNumber = somePhoneNumber;
                testRequest.locationImage = someImage;
                testRequest.deliveryMode = someDeliveryMode;
                testRequest.timeStamp = someTime;
                testRequest.address = someAddress;
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get parameters correctly", ^{
                expect(testRequest.longitudeDegrees).to(beIdenticalTo(someLongitude));
                expect(testRequest.latitudeDegrees).to(beIdenticalTo(someLatitude));
                expect(testRequest.locationName).to(beIdenticalTo(someLocation));
                expect(testRequest.locationDescription).to(beIdenticalTo(someLocationDescription));
                expect(testRequest.addressLines).to(beIdenticalTo(someAddressLines));
                expect(testRequest.phoneNumber).to(beIdenticalTo(somePhoneNumber));
                expect(testRequest.locationImage).to(beIdenticalTo(someImage));
                expect(testRequest.deliveryMode).to(beIdenticalTo(someDeliveryMode));
                expect(testRequest.timeStamp).to(beIdenticalTo(someTime));
                expect(testRequest.address).to(beIdenticalTo(someAddress));
            });
        });
        
        context(@"when parameters are not set", ^{
            it(@"should return nil for longitude", ^{
                expect(testRequest.longitudeDegrees).to(beNil());
                expect(testRequest.latitudeDegrees).to(beNil());
                expect(testRequest.locationName).to(beNil());
                expect(testRequest.locationDescription).to(beNil());
                expect(testRequest.addressLines).to(beNil());
                expect(testRequest.phoneNumber).to(beNil());
                expect(testRequest.locationImage).to(beNil());
                expect(testRequest.deliveryMode).to(beNil());
                expect(testRequest.timeStamp).to(beNil());
                expect(testRequest.address).to(beNil());
            });
        });
    });

    describe(@"when initialized with convenience inits", ^{
        context(@"initWithAddress: addressLines: locationName: locationDescription: phoneNumber: image: deliveryMode: timeStamp:", ^{
            beforeEach(^{
                testRequest = [[SDLSendLocation alloc] initWithAddress:someAddress addressLines:someAddressLines locationName:someLocation locationDescription:someLocationDescription phoneNumber:somePhoneNumber image:someImage deliveryMode:someDeliveryMode timeStamp:someTime];
            });

            it(@"should set parameters correctly", ^{
                expect(testRequest.longitudeDegrees).to(beNil());
                expect(testRequest.latitudeDegrees).to(beNil());
                expect(testRequest.locationName).to(equal(someLocation));
                expect(testRequest.locationDescription).to(equal(someLocationDescription));
                expect(testRequest.addressLines).to(equal(someAddressLines));
                expect(testRequest.phoneNumber).to(equal(somePhoneNumber));
                expect(testRequest.locationImage).to(equal(someImage));
                expect(testRequest.deliveryMode).to(equal(someDeliveryMode));
                expect(testRequest.timeStamp).to(equal(someTime));
                expect(testRequest.address).to(equal(someAddress));
            });
        });

        context(@"initWithLongitude: latitude: locationName: locationDescription: address: phoneNumber: image:", ^{
            beforeEach(^{
                testRequest = [[SDLSendLocation alloc] initWithLongitude:someLongitude.doubleValue latitude:someLatitude.doubleValue locationName:someLocation locationDescription:someLocationDescription address:someAddressLines phoneNumber:somePhoneNumber image:someImage];
            });

            it(@"should set parameters correctly", ^{
                expect(testRequest.longitudeDegrees).to(equal(someLongitude));
                expect(testRequest.latitudeDegrees).to(equal(someLatitude));
                expect(testRequest.locationName).to(equal(someLocation));
                expect(testRequest.locationDescription).to(equal(someLocationDescription));
                expect(testRequest.addressLines).to(equal(someAddressLines));
                expect(testRequest.phoneNumber).to(equal(somePhoneNumber));
                expect(testRequest.locationImage).to(equal(someImage));
                expect(testRequest.deliveryMode).to(beNil());
                expect(testRequest.timeStamp).to(beNil());
                expect(testRequest.address).to(beNil());
            });
        });

        context(@"initWithLongitude: latitude: locationName: locationDescription: displayAddressLines: phoneNumber: image: deliveryMode: timeStamp: address:", ^{
            beforeEach(^{
                testRequest = [[SDLSendLocation alloc] initWithLongitude:someLongitude.doubleValue latitude:someLatitude.doubleValue locationName:someLocation locationDescription:someLocationDescription displayAddressLines:someAddressLines phoneNumber:somePhoneNumber image:someImage deliveryMode:someDeliveryMode timeStamp:someTime address:someAddress];
            });

            it(@"should set parameters correctly", ^{
                expect(testRequest.longitudeDegrees).to(equal(someLongitude));
                expect(testRequest.latitudeDegrees).to(equal(someLatitude));
                expect(testRequest.locationName).to(equal(someLocation));
                expect(testRequest.locationDescription).to(equal(someLocationDescription));
                expect(testRequest.addressLines).to(equal(someAddressLines));
                expect(testRequest.phoneNumber).to(equal(somePhoneNumber));
                expect(testRequest.locationImage).to(equal(someImage));
                expect(testRequest.deliveryMode).to(equal(someDeliveryMode));
                expect(testRequest.timeStamp).to(equal(someTime));
                expect(testRequest.address).to(equal(someAddress));
            });
        });
    });
    
    describe(@"when initialized with a dictionary", ^{
        context(@"when parameters are set correctly", ^{
            beforeEach(^{
                NSDictionary *initDict = @{
                                           SDLRPCParameterNameRequest: @{
                                                   SDLRPCParameterNameParameters: @{
                                                           SDLRPCParameterNameLongitudeDegrees: someLongitude,
                                                           SDLRPCParameterNameLatitudeDegrees: someLatitude,
                                                           SDLRPCParameterNameLocationName: someLocation,
                                                           SDLRPCParameterNameLocationDescription: someLocationDescription,
                                                           SDLRPCParameterNameAddressLines: someAddressLines,
                                                           SDLRPCParameterNamePhoneNumber: somePhoneNumber,
                                                           SDLRPCParameterNameLocationImage: someImage,
                                                           SDLRPCParameterNameDeliveryMode: someDeliveryMode,
                                                           SDLRPCParameterNameTimeStamp: someTime,
                                                           SDLRPCParameterNameAddress: someAddress
                                                           },
                                                   SDLRPCParameterNameOperationName:SDLRPCFunctionNameSendLocation
                                                   }
                                           };
                testRequest = [[SDLSendLocation alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            // Since all the properties are immutable, a copy should be executed as a retain, which means they should be identical
            it(@"should get parameters correctly", ^{
                expect(testRequest.longitudeDegrees).to(beIdenticalTo(someLongitude));
                expect(testRequest.latitudeDegrees).to(beIdenticalTo(someLatitude));
                expect(testRequest.locationName).to(beIdenticalTo(someLocation));
                expect(testRequest.locationDescription).to(beIdenticalTo(someLocationDescription));
                expect(testRequest.addressLines).to(beIdenticalTo(someAddressLines));
                expect(testRequest.phoneNumber).to(beIdenticalTo(somePhoneNumber));
                expect(testRequest.locationImage).to(beIdenticalTo(someImage));
                expect(testRequest.deliveryMode).to(beIdenticalTo(someDeliveryMode));
                expect(testRequest.timeStamp).to(beIdenticalTo(someTime));
                expect(testRequest.address).to(beIdenticalTo(someAddress));
            });
        });
    
        context(@"when parameters are not set", ^{
            beforeEach(^{
                NSDictionary<NSString *, id> *initDict = @{
                                           SDLRPCParameterNameRequest: @{
                                                   SDLRPCParameterNameParameters: @{}
                                                   }
                                           };
                testRequest = [[SDLSendLocation alloc] initWithDictionary:[NSMutableDictionary dictionaryWithDictionary:initDict]];
            });
            
            it(@"should return nil for parameters", ^{
                expect(testRequest.longitudeDegrees).to(beNil());
                expect(testRequest.latitudeDegrees).to(beNil());
                expect(testRequest.locationName).to(beNil());
                expect(testRequest.locationDescription).to(beNil());
                expect(testRequest.addressLines).to(beNil());
                expect(testRequest.phoneNumber).to(beNil());
                expect(testRequest.locationImage).to(beNil());
                expect(testRequest.deliveryMode).to(beNil());
                expect(testRequest.timeStamp).to(beNil());
                expect(testRequest.address).to(beNil());
            });
        });
    });
});

QuickSpecEnd
