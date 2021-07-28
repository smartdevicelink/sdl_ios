//
//  SDLTireStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSingleTireStatus.h"
#import "SDLTireStatus.h"
#import "SDLRPCParameterNames.h"
#import "SDLWarningLightStatus.h"

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

describe(@"getter/setter tests", ^{
    __block SDLTireStatus* testStruct = nil;

    context(@"init", ^{
        beforeEach(^{
            testStruct = [[SDLTireStatus alloc] init];
            testStruct.pressureTelltale = SDLWarningLightStatusFlash;
            testStruct.leftFront = tire1;
            testStruct.rightFront = tire2;
            testStruct.leftRear = tire3;
            testStruct.rightRear = tire4;
            testStruct.innerLeftRear = tire5;
            testStruct.innerRightRear = tire6;
        });

        it(@"should set and get correctly", ^{
            expect(testStruct.pressureTelltale).to(equal(SDLWarningLightStatusFlash));
            expect(testStruct.leftFront).to(equal(tire1));
            expect(testStruct.leftFront).notTo(equal(tire2));
            expect(testStruct.rightFront).to(equal(tire2));
            expect(testStruct.rightFront).notTo(equal(tire1));
            expect(testStruct.leftRear).to(equal(tire3));
            expect(testStruct.leftRear).notTo(equal(tire1));
            expect(testStruct.rightRear).to(equal(tire4));
            expect(testStruct.rightRear).notTo(equal(tire1));
            expect(testStruct.innerLeftRear).to(equal(tire5));
            expect(testStruct.innerLeftRear).notTo(equal(tire1));
            expect(testStruct.innerRightRear).to(equal(tire6));
            expect(testStruct.innerRightRear).notTo(equal(tire1));
        });
    });

    context(@"initWithDictionary:", ^{
        beforeEach(^{
            NSDictionary* dataDict = @{
                SDLRPCParameterNamePressureTelltale: pressureTelltale,
                SDLRPCParameterNameLeftFront: tire1,
                SDLRPCParameterNameRightFront: tire2,
                SDLRPCParameterNameLeftRear: tire3,
                SDLRPCParameterNameRightRear: tire4,
                SDLRPCParameterNameInnerLeftRear: tire5,
                SDLRPCParameterNameInnerRightRear: tire6,
            };
            testStruct = [[SDLTireStatus alloc] initWithDictionary:dataDict];
        });

        it(@"should get correctly when initialized", ^{
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
        beforeEach(^{
            testStruct = [[SDLTireStatus alloc] init];
        });

        it(@"should not return nil if not set and should return unknown status", ^{
            expect(testStruct.pressureTelltale).notTo(beNil());
            expect(testStruct.pressureTelltale).to(equal(SDLWarningLightStatusNotUsed));
            expect(testStruct.leftFront).notTo(beNil());
            expect(testStruct.rightFront).notTo(beNil());
            expect(testStruct.leftRear).notTo(beNil());
            expect(testStruct.rightRear).notTo(beNil());
            expect(testStruct.innerLeftRear).notTo(beNil());
            expect(testStruct.innerRightRear).notTo(beNil());
            expect(testStruct.leftFront.status).to(equal(SDLComponentVolumeStatusUnknown));
            expect(testStruct.rightFront.status).to(equal(SDLComponentVolumeStatusUnknown));
            expect(testStruct.leftRear.status).to(equal(SDLComponentVolumeStatusUnknown));
            expect(testStruct.rightRear.status).to(equal(SDLComponentVolumeStatusUnknown));
            expect(testStruct.innerLeftRear.status).to(equal(SDLComponentVolumeStatusUnknown));
            expect(testStruct.innerRightRear.status).to(equal(SDLComponentVolumeStatusUnknown));
        });
    });
});

QuickSpecEnd
