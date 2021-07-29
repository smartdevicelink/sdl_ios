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

__block SDLSingleTireStatus* tire1 = nil;
__block SDLSingleTireStatus* tire2 = nil;
__block SDLSingleTireStatus* tire3 = nil;
__block SDLSingleTireStatus* tire4 = nil;
__block SDLSingleTireStatus* tire5 = nil;
__block SDLSingleTireStatus* tire6 = nil;

describe(@"Getter/Setter Tests", ^{

    beforeEach(^{
        tire1 = [[SDLSingleTireStatus alloc] init];
        tire2 = [[SDLSingleTireStatus alloc] init];
        tire3 = [[SDLSingleTireStatus alloc] init];
        tire4 = [[SDLSingleTireStatus alloc] init];
        tire5 = [[SDLSingleTireStatus alloc] init];
        tire6 = [[SDLSingleTireStatus alloc] init];
        // make all tires different to prevent misplacement (eg left front != right front etc.)
        tire1.pressure = @(1.0);
        tire2.pressure = @(2.0);
        tire3.pressure = @(3.0);
        tire4.pressure = @(4.0);
        tire5.pressure = @(5.0);
        tire6.pressure = @(6.0);
    });

    it(@"Should set and get correctly", ^{
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] init];
        
        testStruct.pressureTelltale = SDLWarningLightStatusOff;
        testStruct.leftFront = tire1;
        testStruct.rightFront = tire2;
        testStruct.leftRear = tire3;
        testStruct.rightRear = tire4;
        testStruct.innerLeftRear = tire5;
        testStruct.innerRightRear = tire6;
        
        expect(testStruct.pressureTelltale).to(equal(SDLWarningLightStatusOff));
        expect(testStruct.leftFront).to(equal(tire1));
        expect(testStruct.rightFront).to(equal(tire2));
        expect(testStruct.leftRear).to(equal(tire3));
        expect(testStruct.rightRear).to(equal(tire4));
        expect(testStruct.innerLeftRear).to(equal(tire5));
        expect(testStruct.innerRightRear).to(equal(tire6));
    });
    
    it(@"Should get correctly when initialized", ^{
        NSMutableDictionary* dict = [@{SDLRPCParameterNamePressureTelltale:SDLWarningLightStatusOff,
                                       SDLRPCParameterNameLeftFront:tire1,
                                       SDLRPCParameterNameRightFront:tire2,
                                       SDLRPCParameterNameLeftRear:tire3,
                                       SDLRPCParameterNameRightRear:tire4,
                                       SDLRPCParameterNameInnerLeftRear:tire5,
                                       SDLRPCParameterNameInnerRightRear:tire6} mutableCopy];
        SDLTireStatus* testStruct = [[SDLTireStatus alloc] initWithDictionary:dict];
        
        expect(testStruct.pressureTelltale).to(equal(SDLWarningLightStatusOff));
        expect(testStruct.leftFront).to(equal(tire1));
        expect(testStruct.rightFront).to(equal(tire2));
        expect(testStruct.leftRear).to(equal(tire3));
        expect(testStruct.rightRear).to(equal(tire4));
        expect(testStruct.innerLeftRear).to(equal(tire5));
        expect(testStruct.innerRightRear).to(equal(tire6));
    });
    
    context(@"Should return nil if not set", ^{
        __block SDLTireStatus* testStruct = nil;
        // default tire status (when it is set to nil)
        __block SDLSingleTireStatus* tireDefault = nil;

        beforeEach(^{
            testStruct = [[SDLTireStatus alloc] init];
            tireDefault = [[SDLSingleTireStatus alloc] init];
            tireDefault.status = SDLComponentVolumeStatusUnknown;
            tireDefault.pressure = nil;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
            testStruct.pressureTelltale = nil;
            testStruct.leftFront = nil;
            testStruct.rightFront = nil;
            testStruct.leftRear = nil;
            testStruct.rightRear = nil;
            testStruct.innerLeftRear = nil;
            testStruct.innerRightRear = nil;
#pragma clang diagnostic pop
        });

        it(@"Should return nil if not set", ^{
            expect(testStruct.pressureTelltale).to(equal(SDLWarningLightStatusNotUsed));
            expect(testStruct.leftFront).to(equal(tireDefault));
            expect(testStruct.rightFront).to(equal(tireDefault));
            expect(testStruct.leftRear).to(equal(tireDefault));
            expect(testStruct.rightRear).to(equal(tireDefault));
            expect(testStruct.innerLeftRear).to(equal(tireDefault));
            expect(testStruct.innerRightRear).to(equal(tireDefault));
        });
    });
});

QuickSpecEnd
