//
//  SDLGearStatusSpec.m
//  SmartDeviceLinkTests
//

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>
#import "SDLGearStatus.h"
#import "SDLRPCParameterNames.h"

QuickSpecBegin(SDLGearStatusSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
    SDLGearStatus* testStruct = [[SDLGearStatus alloc] initWithUserSelectedGear:SDLPRNDLNinth actualGear:SDLPRNDLTenth transmissionType:SDLTransmissionTypeAutomatic];

        expect(testStruct.userSelectedGear).to(equal(SDLPRNDLNinth));
        expect(testStruct.actualGear).to(equal(SDLPRNDLTenth));
        expect(testStruct.transmissionType).to(equal(SDLTransmissionTypeAutomatic));
    });

    it(@"Should get correctly when initialized", ^ {
        NSDictionary<NSString *, id> *dict = @{SDLRPCParameterNameUserSelectedGear:SDLPRNDLNinth,
                                                SDLRPCParameterNameActualGear:SDLPRNDLTenth,
                                                SDLRPCParameterNameTransmissionType:SDLTransmissionTypeAutomatic};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLGearStatus* testStruct = [[SDLGearStatus alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.userSelectedGear).to(equal(SDLPRNDLNinth));
        expect(testStruct.actualGear).to(equal(SDLPRNDLTenth));
        expect(testStruct.transmissionType).to(equal(SDLTransmissionTypeAutomatic));
    });

    it(@"Should return nil if not set", ^ {
        SDLGearStatus* testStruct = [[SDLGearStatus alloc] init];

        expect(testStruct.userSelectedGear).to(beNil());
        expect(testStruct.actualGear).to(beNil());
        expect(testStruct.transmissionType).to(beNil());
    });
});

QuickSpecEnd
