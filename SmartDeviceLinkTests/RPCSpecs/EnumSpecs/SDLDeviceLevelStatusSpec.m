//
//  SDLDeviceLevelStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeviceLevelStatus.h"

QuickSpecBegin(SDLDeviceLevelStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLDeviceLevelStatus ZERO_LEVEL_BARS].value).to(equal(@"ZERO_LEVEL_BARS"));
        expect([SDLDeviceLevelStatus ONE_LEVEL_BARS].value).to(equal(@"ONE_LEVEL_BARS"));
        expect([SDLDeviceLevelStatus TWO_LEVEL_BARS].value).to(equal(@"TWO_LEVEL_BARS"));
        expect([SDLDeviceLevelStatus THREE_LEVEL_BARS].value).to(equal(@"THREE_LEVEL_BARS"));
        expect([SDLDeviceLevelStatus FOUR_LEVEL_BARS].value).to(equal(@"FOUR_LEVEL_BARS"));
        expect([SDLDeviceLevelStatus NOT_PROVIDED].value).to(equal(@"NOT_PROVIDED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLDeviceLevelStatus valueOf:@"ZERO_LEVEL_BARS"]).to(equal([SDLDeviceLevelStatus ZERO_LEVEL_BARS]));
        expect([SDLDeviceLevelStatus valueOf:@"ONE_LEVEL_BARS"]).to(equal([SDLDeviceLevelStatus ONE_LEVEL_BARS]));
        expect([SDLDeviceLevelStatus valueOf:@"TWO_LEVEL_BARS"]).to(equal([SDLDeviceLevelStatus TWO_LEVEL_BARS]));
        expect([SDLDeviceLevelStatus valueOf:@"THREE_LEVEL_BARS"]).to(equal([SDLDeviceLevelStatus THREE_LEVEL_BARS]));
        expect([SDLDeviceLevelStatus valueOf:@"FOUR_LEVEL_BARS"]).to(equal([SDLDeviceLevelStatus FOUR_LEVEL_BARS]));
        expect([SDLDeviceLevelStatus valueOf:@"NOT_PROVIDED"]).to(equal([SDLDeviceLevelStatus NOT_PROVIDED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLDeviceLevelStatus valueOf:nil]).to(beNil());
        expect([SDLDeviceLevelStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLDeviceLevelStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLDeviceLevelStatus ZERO_LEVEL_BARS],
                        [SDLDeviceLevelStatus ONE_LEVEL_BARS],
                        [SDLDeviceLevelStatus TWO_LEVEL_BARS],
                        [SDLDeviceLevelStatus THREE_LEVEL_BARS],
                        [SDLDeviceLevelStatus FOUR_LEVEL_BARS],
                        [SDLDeviceLevelStatus NOT_PROVIDED]] copy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain(definedValues[i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain(storedValues[i]));
        }
    });
});

QuickSpecEnd
