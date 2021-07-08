//
//  SDLTireStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTireStatus.h"
#import "SDLSingleTireStatus.h"
#import "SDLWarningLightStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLTireStatusSpec)

SDLSingleTireStatus* tire1 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire2 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire3 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire4 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire5 = [[SDLSingleTireStatus alloc] init];
SDLSingleTireStatus* tire6 = [[SDLSingleTireStatus alloc] init];
// make all tires different to prevent misplacement (eg left front != right front etc.)
tire1.pressure = @(1.0);
tire2.pressure = @(2.0);
tire3.pressure = @(3.0);
tire4.pressure = @(4.0);
tire5.pressure = @(5.0);
tire6.pressure = @(6.0);
SDLWarningLightStatus pressureTelltale = SDLWarningLightStatusOff;
NSDictionary* dataDict = @{
    SDLRPCParameterNamePressureTelltale:pressureTelltale,
    SDLRPCParameterNameLeftFront:tire1,
    SDLRPCParameterNameRightFront:tire2,
    SDLRPCParameterNameLeftRear:tire3,
    SDLRPCParameterNameRightRear:tire4,
    SDLRPCParameterNameInnerLeftRear:tire5,
    SDLRPCParameterNameInnerRightRear:tire6,
};

describe(@"getter/setter tests", ^{
    context(@"init and assign", ^{
        SDLTireStatus *testStruct = [[SDLTireStatus alloc] init];
        testStruct.pressureTelltale = pressureTelltale;
        testStruct.leftFront = tire1;
        testStruct.rightFront = tire2;
        testStruct.leftRear = tire3;
        testStruct.rightRear = tire4;
        testStruct.innerLeftRear = tire5;
        testStruct.innerRightRear = tire6;

        it(@"expect to be set correctly", ^{
            expect(testStruct.pressureTelltale).to(equal(pressureTelltale));
            expect(testStruct.leftFront).to(equal(tire1));
            expect(testStruct.rightFront).to(equal(tire2));
            expect(testStruct.leftRear).to(equal(tire3));
            expect(testStruct.rightRear).to(equal(tire4));
            expect(testStruct.innerLeftRear).to(equal(tire5));
            expect(testStruct.innerRightRear).to(equal(tire6));
        });

        it(@"expect not equal to wrong values", ^{
            expect(testStruct.pressureTelltale).notTo(equal(SDLWarningLightStatusFlash));
            expect(testStruct.leftFront).notTo(equal(tire3));
            expect(testStruct.rightFront).notTo(equal(tire1));
            expect(testStruct.leftRear).notTo(equal(tire2));
            expect(testStruct.rightRear).notTo(equal(tire6));
            expect(testStruct.innerLeftRear).notTo(equal(tire4));
            expect(testStruct.innerRightRear).notTo(equal(tire5));
        });
    });

    context(@"initWithDictionary: and then nulify all", ^{
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] initWithDictionary:dataDict];
        testStruct.pressureTelltale = nil;
        testStruct.leftFront = nil;
        testStruct.rightFront = nil;
        testStruct.leftRear = nil;
        testStruct.rightRear = nil;
        testStruct.innerLeftRear = nil;
        testStruct.innerRightRear = nil;

        it(@"expect all properties to be nil", ^{
            expect(testStruct.pressureTelltale).to(beNil());
            expect(testStruct.leftFront).to(beNil());
            expect(testStruct.rightFront).to(beNil());
            expect(testStruct.leftRear).to(beNil());
            expect(testStruct.rightRear).to(beNil());
            expect(testStruct.innerLeftRear).to(beNil());
            expect(testStruct.innerRightRear).to(beNil());
        });
    });

    context(@"initWithDictionary:", ^{
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] initWithDictionary:dataDict];

        it(@"expect to be set correctly", ^{
            expect(testStruct.pressureTelltale).to(equal(pressureTelltale));
            expect(testStruct.leftFront).to(equal(tire1));
            expect(testStruct.rightFront).to(equal(tire2));
            expect(testStruct.leftRear).to(equal(tire3));
            expect(testStruct.rightRear).to(equal(tire4));
            expect(testStruct.innerLeftRear).to(equal(tire5));
            expect(testStruct.innerRightRear).to(equal(tire6));
        });
    });

    context(@"init", ^{
        SDLTireStatus *testStruct = [[SDLTireStatus alloc] init];

        it(@"expect all properties to be nil", ^{
            expect(testStruct.pressureTelltale).to(beNil());
            expect(testStruct.leftFront).to(beNil());
            expect(testStruct.rightFront).to(beNil());
            expect(testStruct.leftRear).to(beNil());
            expect(testStruct.rightRear).to(beNil());
            expect(testStruct.innerLeftRear).to(beNil());
            expect(testStruct.innerRightRear).to(beNil());
        });
    });
});

QuickSpecEnd
