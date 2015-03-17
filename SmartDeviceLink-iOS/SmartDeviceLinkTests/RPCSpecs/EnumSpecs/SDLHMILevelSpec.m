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
        expect([SDLHMILevel HMI_FULL].value).to(equal(@"FULL"));
        expect([SDLHMILevel HMI_LIMITED].value).to(equal(@"LIMITED"));
        expect([SDLHMILevel HMI_BACKGROUND].value).to(equal(@"BACKGROUND"));
        expect([SDLHMILevel HMI_NONE].value).to(equal(@"NONE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLHMILevel valueOf:@"FULL"]).to(equal([SDLHMILevel HMI_FULL]));
        expect([SDLHMILevel valueOf:@"LIMITED"]).to(equal([SDLHMILevel HMI_LIMITED]));
        expect([SDLHMILevel valueOf:@"BACKGROUND"]).to(equal([SDLHMILevel HMI_BACKGROUND]));
        expect([SDLHMILevel valueOf:@"NONE"]).to(equal([SDLHMILevel HMI_NONE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLHMILevel valueOf:nil]).to(beNil());
        expect([SDLHMILevel valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLHMILevel values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLHMILevel HMI_FULL],
                        [SDLHMILevel HMI_LIMITED],
                        [SDLHMILevel HMI_BACKGROUND],
                        [SDLHMILevel HMI_NONE]] mutableCopy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain([definedValues objectAtIndex:i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain([storedValues objectAtIndex:i]));
        }
    });
});

QuickSpecEnd
