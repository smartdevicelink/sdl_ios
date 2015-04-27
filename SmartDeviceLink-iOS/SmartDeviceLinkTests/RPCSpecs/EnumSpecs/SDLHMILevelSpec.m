//
//  SDLHMILevelSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLHMILevel.h"

QuickSpecBegin(SDLHMILevelSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLHMILevel FULL].value).to(equal(@"FULL"));
        expect([SDLHMILevel LIMITED].value).to(equal(@"LIMITED"));
        expect([SDLHMILevel BACKGROUND].value).to(equal(@"BACKGROUND"));
        expect([SDLHMILevel NONE].value).to(equal(@"NONE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLHMILevel valueOf:@"FULL"]).to(equal([SDLHMILevel FULL]));
        expect([SDLHMILevel valueOf:@"LIMITED"]).to(equal([SDLHMILevel LIMITED]));
        expect([SDLHMILevel valueOf:@"BACKGROUND"]).to(equal([SDLHMILevel BACKGROUND]));
        expect([SDLHMILevel valueOf:@"NONE"]).to(equal([SDLHMILevel NONE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLHMILevel valueOf:nil]).to(beNil());
        expect([SDLHMILevel valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLHMILevel values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLHMILevel FULL],
                        [SDLHMILevel LIMITED],
                        [SDLHMILevel BACKGROUND],
                        [SDLHMILevel NONE]] copy];
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
