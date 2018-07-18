//
//  SDLMassageCushionFirmnessSpec.m
//  SmartDeviceLinkTests
//

#import <Foundation/Foundation.h>
#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLNames.h"
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
        NSMutableDictionary* dict = [@{SDLNameCushion:SDLMassageCushionSeatBolsters,
                                       SDLNamefirmness:@12
                                       } mutableCopy];
        SDLMassageCushionFirmness* testStruct = [[SDLMassageCushionFirmness alloc] initWithDictionary:dict];

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
