//
//  SDLNavigationInstructionSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/22/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDateTime.h"
#import "SDLImage.h"
#import "SDLLocationDetails.h"
#import "SDLNavigationInstruction.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLNavigationInstructionSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLLocationDetails *testLocationDetails = nil;
    __block SDLNavigationAction testAction = nil;
    __block SDLDateTime *testETA = nil;
    __block int testBearing = 34;
    __block SDLNavigationJunction testJunctionType = nil;
    __block SDLDirection testDrivingSide = nil;
    __block NSString *testDetails = nil;
    __block SDLImage *testImage = nil;

    beforeEach(^{
        testLocationDetails = [[SDLLocationDetails alloc] init];
        testAction = SDLNavigationActionExit;
        testETA = [[SDLDateTime alloc] initWithHour:3 minute:2];
        testJunctionType = SDLNavigationJunctionJughandle;
        testDrivingSide = SDLDirectionLeft;
        testDetails = @"testDetails";
        testImage = [[SDLImage alloc] init];
    });

    it(@"Should set and get correctly", ^{
        SDLNavigationInstruction *testStruct = [[SDLNavigationInstruction alloc] init];
        testStruct.locationDetails = testLocationDetails;
        testStruct.action = testAction;
        testStruct.eta = testETA;
        testStruct.bearing = @(testBearing);
        testStruct.junctionType = testJunctionType;
        testStruct.drivingSide = testDrivingSide;
        testStruct.details = testDetails;
        testStruct.image = testImage;

        expect(testStruct.locationDetails).to(equal(testLocationDetails));
        expect(testStruct.action).to(equal(testAction));
        expect(testStruct.eta).to(equal(testETA));
        expect(testStruct.bearing).to(equal(testBearing));
        expect(testStruct.junctionType).to(equal(testJunctionType));
        expect(testStruct.drivingSide).to(equal(testDrivingSide));
        expect(testStruct.details).to(equal(testDetails));
        expect(testStruct.image).to(equal(testImage));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameLocationDetails:testLocationDetails,
                               SDLRPCParameterNameAction:testAction,
                               SDLRPCParameterNameETA:testETA,
                               SDLRPCParameterNameBearing:@(testBearing),
                               SDLRPCParameterNameJunctionType:testJunctionType,
                               SDLRPCParameterNameDrivingSide:testDrivingSide,
                               SDLRPCParameterNameDetails:testDetails,
                               SDLRPCParameterNameImage:testImage
                               };
        SDLNavigationInstruction *testStruct = [[SDLNavigationInstruction alloc] initWithDictionary:dict];

        expect(testStruct.locationDetails).to(equal(testLocationDetails));
        expect(testStruct.action).to(equal(testAction));
        expect(testStruct.eta).to(equal(testETA));
        expect(testStruct.bearing).to(equal(testBearing));
        expect(testStruct.junctionType).to(equal(testJunctionType));
        expect(testStruct.drivingSide).to(equal(testDrivingSide));
        expect(testStruct.details).to(equal(testDetails));
        expect(testStruct.image).to(equal(testImage));
    });

    it(@"Should initialize correctly with initWithLocationDetails:action:", ^{
        SDLNavigationInstruction *testStruct = [[SDLNavigationInstruction alloc] initWithLocationDetails:testLocationDetails action:testAction];

        expect(testStruct.locationDetails).to(equal(testLocationDetails));
        expect(testStruct.action).to(equal(testAction));
        expect(testStruct.eta).to(beNil());
        expect(testStruct.bearing).to(beNil());
        expect(testStruct.junctionType).to(beNil());
        expect(testStruct.drivingSide).to(beNil());
        expect(testStruct.details).to(beNil());
        expect(testStruct.image).to(beNil());
    });

    it(@"Should initialize correctly with initWithLocationDetails:action:eta:bearing:junctionType:drivingSide:details:details image:", ^{
        SDLNavigationInstruction *testStruct = [[SDLNavigationInstruction alloc] initWithLocationDetails:testLocationDetails action:testAction eta:testETA bearing:testBearing junctionType:testJunctionType drivingSide:testDrivingSide details:testDetails image:testImage];

        expect(testStruct.locationDetails).to(equal(testLocationDetails));
        expect(testStruct.action).to(equal(testAction));
        expect(testStruct.eta).to(equal(testETA));
        expect(testStruct.bearing).to(equal(testBearing));
        expect(testStruct.junctionType).to(equal(testJunctionType));
        expect(testStruct.drivingSide).to(equal(testDrivingSide));
        expect(testStruct.details).to(equal(testDetails));
        expect(testStruct.image).to(equal(testImage));
    });

    it(@"Should return nil if not set", ^{
        SDLNavigationInstruction *testStruct = [[SDLNavigationInstruction alloc] init];

        expect(testStruct.locationDetails).to(beNil());
        expect(testStruct.action).to(beNil());
        expect(testStruct.eta).to(beNil());
        expect(testStruct.bearing).to(beNil());
        expect(testStruct.junctionType).to(beNil());
        expect(testStruct.drivingSide).to(beNil());
        expect(testStruct.details).to(beNil());
        expect(testStruct.image).to(beNil());
    });
});

QuickSpecEnd

