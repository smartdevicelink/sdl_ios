//
//  SDLGearStatusSpec.m
//  SmartDeviceLinkTests
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLGearStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLGearStatusSpec)

describe(@"getter/setter tests", ^{
    context(@"initWithUserSelectedGear:actualGear:transmissionType:", ^{
        SDLGearStatus* testStruct = [[SDLGearStatus alloc] initWithUserSelectedGear:SDLPRNDLNinth actualGear:SDLPRNDLTenth transmissionType:SDLTransmissionTypeAutomatic];
        it(@"expect all properties to be set properly", ^{
            expect(testStruct.userSelectedGear).to(equal(SDLPRNDLNinth));
            expect(testStruct.actualGear).to(equal(SDLPRNDLTenth));
            expect(testStruct.transmissionType).to(equal(SDLTransmissionTypeAutomatic));
        });
    });

    context(@"initWithDictionary", ^{
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameUserSelectedGear:SDLPRNDLNinth,
                                                SDLRPCParameterNameActualGear:SDLPRNDLTenth,
                                                SDLRPCParameterNameTransmissionType:SDLTransmissionTypeAutomatic};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGearStatus* testStruct = [[SDLGearStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop
        it(@"should get correctly when initialized", ^{
            expect(testStruct.userSelectedGear).to(equal(SDLPRNDLNinth));
            expect(testStruct.actualGear).to(equal(SDLPRNDLTenth));
            expect(testStruct.transmissionType).to(equal(SDLTransmissionTypeAutomatic));
        });
    });

    context(@"init", ^{
        SDLGearStatus* testStruct = [[SDLGearStatus alloc] init];
        it(@"should return nil if not set", ^{
            expect(testStruct.userSelectedGear).to(beNil());
            expect(testStruct.actualGear).to(beNil());
            expect(testStruct.transmissionType).to(beNil());
        });
    });
});

QuickSpecEnd
