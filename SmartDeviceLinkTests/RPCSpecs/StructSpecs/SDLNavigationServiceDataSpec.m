//
//  SDLNavigationServiceDataSpec.m
//  SmartDeviceLinkTests
//
//  Created by Nicole on 2/25/19.
//  Copyright © 2019 smartdevicelink. All rights reserved.
//

@import Quick;
@import Nimble;

#import "SDLDateTime.h"
#import "SDLLocationDetails.h"
#import "SDLRPCParameterNames.h"
#import "SDLNavigationInstruction.h"
#import "SDLNavigationServiceData.h"


QuickSpecBegin(SDLNavigationServiceDataSpec)

describe(@"Getter/Setter Tests", ^{
    __block SDLDateTime *testTimestamp = nil;
    __block SDLLocationDetails *testOrigin = nil;
    __block SDLLocationDetails *testDestination = nil;
    __block SDLDateTime *testDestinationETA = nil;
    __block NSArray<SDLNavigationInstruction *> *testInstructions = nil;
    __block SDLDateTime *testNextInstructionETA = nil;
    __block float testNextInstructionDistance = 45.3;
    __block float testNextInstructionDistanceScale = 0.3;
    __block NSString *testPrompt = nil;

    beforeEach(^{
        testTimestamp = [[SDLDateTime alloc] initWithHour:4 minute:3];
        testOrigin = [[SDLLocationDetails alloc] init];
        testDestination = [[SDLLocationDetails alloc] init];
        testDestinationETA = [[SDLDateTime alloc] initWithHour:6 minute:1 second:1 millisecond:1];
        testInstructions = @[[[SDLNavigationInstruction alloc] init], [[SDLNavigationInstruction alloc] init]];
        testNextInstructionETA = [[SDLDateTime alloc] initWithHour:2 minute:0];
        testPrompt = @"testPrompt";
    });

    it(@"Should set and get correctly", ^{
        SDLNavigationServiceData *testStruct = [[SDLNavigationServiceData alloc] init];
        testStruct.timestamp = testTimestamp;
        testStruct.origin = testOrigin;
        testStruct.destination = testDestination;
        testStruct.destinationETA = testDestinationETA;
        testStruct.instructions = testInstructions;
        testStruct.nextInstructionETA = testNextInstructionETA;
        testStruct.nextInstructionDistance = @(testNextInstructionDistance);
        testStruct.nextInstructionDistanceScale = @(testNextInstructionDistanceScale);
        testStruct.prompt = testPrompt;

        expect(testStruct.timestamp).to(equal(testTimestamp));
        expect(testStruct.origin).to(equal(testOrigin));
        expect(testStruct.destination).to(equal(testDestination));
        expect(testStruct.destinationETA).to(equal(testDestinationETA));
        expect(testStruct.instructions).to(equal(testInstructions));
        expect(testStruct.nextInstructionETA).to(equal(testNextInstructionETA));
        expect(testStruct.nextInstructionDistance).to(equal(testNextInstructionDistance));
        expect(testStruct.nextInstructionDistanceScale).to(equal(testNextInstructionDistanceScale));
        expect(testStruct.prompt).to(equal(testPrompt));
    });

    it(@"Should get correctly when initialized with a dictionary", ^{
        NSDictionary *dict = @{SDLRPCParameterNameTimeStamp:testTimestamp,
                               SDLRPCParameterNameOrigin:testOrigin,
                               SDLRPCParameterNameDestination:testDestination,
                               SDLRPCParameterNameDestinationETA:testDestinationETA,
                               SDLRPCParameterNameInstructions:testInstructions,
                               SDLRPCParameterNameNextInstructionETA:testNextInstructionETA,
                               SDLRPCParameterNameNextInstructionDistance:@(testNextInstructionDistance),
                               SDLRPCParameterNameNextInstructionDistanceScale:@(testNextInstructionDistanceScale),
                               SDLRPCParameterNamePrompt:testPrompt
                               };
        SDLNavigationServiceData *testStruct = [[SDLNavigationServiceData alloc] initWithDictionary:dict];

        expect(testStruct.timestamp).to(equal(testTimestamp));
        expect(testStruct.origin).to(equal(testOrigin));
        expect(testStruct.destination).to(equal(testDestination));
        expect(testStruct.destinationETA).to(equal(testDestinationETA));
        expect(testStruct.instructions).to(equal(testInstructions));
        expect(testStruct.nextInstructionETA).to(equal(testNextInstructionETA));
        expect(testStruct.nextInstructionDistance).to(equal(testNextInstructionDistance));
        expect(testStruct.nextInstructionDistanceScale).to(equal(testNextInstructionDistanceScale));
        expect(testStruct.prompt).to(equal(testPrompt));
    });

    it(@"Should initialize correctly with initWithTimestamp:", ^{
        SDLNavigationServiceData *testStruct = [[SDLNavigationServiceData alloc] initWithTimestamp:testTimestamp];

        expect(testStruct.timestamp).to(equal(testTimestamp));
        expect(testStruct.origin).to(beNil());
        expect(testStruct.destination).to(beNil());
        expect(testStruct.destinationETA).to(beNil());
        expect(testStruct.instructions).to(beNil());
        expect(testStruct.nextInstructionETA).to(beNil());
        expect(testStruct.nextInstructionDistance).to(beNil());
        expect(testStruct.nextInstructionDistanceScale).to(beNil());
        expect(testStruct.prompt).to(beNil());
    });

    it(@"Should initialize correctly with initWithTimestamp:origin:destination:destinationETA:instructions:nextInstructionETA:nextInstructionDistance:nextInstructionDistanceScale:prompt:", ^{
        SDLNavigationServiceData *testStruct = [[SDLNavigationServiceData alloc] initWithTimestamp:testTimestamp origin:testOrigin destination:testDestination destinationETA:testDestinationETA instructions:testInstructions nextInstructionETA:testNextInstructionETA nextInstructionDistance:testNextInstructionDistance nextInstructionDistanceScale:testNextInstructionDistanceScale prompt:testPrompt];

        expect(testStruct.timestamp).to(equal(testTimestamp));
        expect(testStruct.origin).to(equal(testOrigin));
        expect(testStruct.destination).to(equal(testDestination));
        expect(testStruct.destinationETA).to(equal(testDestinationETA));
        expect(testStruct.instructions).to(equal(testInstructions));
        expect(testStruct.nextInstructionETA).to(equal(testNextInstructionETA));
        expect(testStruct.nextInstructionDistance).to(equal(testNextInstructionDistance));
        expect(testStruct.nextInstructionDistanceScale).to(equal(testNextInstructionDistanceScale));
        expect(testStruct.prompt).to(equal(testPrompt));
    });

    it(@"Should return nil if not set", ^{
        SDLNavigationServiceData *testStruct = [[SDLNavigationServiceData alloc] init];

        expect(testStruct.timestamp).to(beNil());
        expect(testStruct.origin).to(beNil());
        expect(testStruct.destination).to(beNil());
        expect(testStruct.destinationETA).to(beNil());
        expect(testStruct.instructions).to(beNil());
        expect(testStruct.nextInstructionETA).to(beNil());
        expect(testStruct.nextInstructionDistance).to(beNil());
        expect(testStruct.nextInstructionDistanceScale).to(beNil());
        expect(testStruct.prompt).to(beNil());
    });
});

QuickSpecEnd
