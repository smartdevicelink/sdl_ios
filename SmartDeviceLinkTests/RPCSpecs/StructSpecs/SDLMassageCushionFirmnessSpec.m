//
//  SDLMassageCushionFirmnessSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLRPCParameterNames.h"
#import "SDLMassageCushionFirmness.h"

QuickSpecBegin(SDLMassageCushionFirmnessSpec)

describe(@"Getter/Setter Tests", ^ {
    it(@"Should set and get correctly", ^ {
        SDLMassageCushionFirmness* testStruct = [[SDLMassageCushionFirmness alloc] init];

        testStruct.cushion = SDLMassageCushionSeatBolsters;
        testStruct.firmness = @2;

        expect(testStruct.cushion).to(equal(SDLMassageCushionSeatBolsters));
        expect(testStruct.firmness).to(equal(@2));
    });

    it(@"Should set and get correctly", ^ {
        SDLMassageCushionFirmness* testStruct = [[SDLMassageCushionFirmness alloc] initWithMassageCushion:SDLMassageCushionBackBolsters firmness:12];

        expect(testStruct.cushion).to(equal(SDLMassageCushionBackBolsters));
        expect(testStruct.firmness).to(equal(@12));
    });

    it(@"Should get correctly when initialized", ^ {
        NSMutableDictionary* dict = [@{SDLRPCParameterNameCushion:SDLMassageCushionSeatBolsters,
                                       SDLRPCParameterNameFirmness:@12
                                       } mutableCopy];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        SDLMassageCushionFirmness* testStruct = [[SDLMassageCushionFirmness alloc] initWithDictionary:dict];
#pragma clang diagnostic pop

        expect(testStruct.cushion).to(equal(SDLMassageCushionSeatBolsters));
        expect(testStruct.firmness).to(equal(@12));

    });

    it(@"Should return nil if not set", ^ {
        SDLMassageCushionFirmness* testStruct = [[SDLMassageCushionFirmness alloc] init];

        expect(testStruct.cushion).to(beNil());
        expect(testStruct.firmness).to(beNil());
    });
});

QuickSpecEnd
