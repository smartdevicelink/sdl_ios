//
//  SDLInteractionModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLInteractionMode.h"

QuickSpecBegin(SDLInteractionModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLInteractionMode MANUAL_ONLY].value).to(equal(@"MANUAL_ONLY"));
        expect([SDLInteractionMode VR_ONLY].value).to(equal(@"VR_ONLY"));
        expect([SDLInteractionMode BOTH].value).to(equal(@"BOTH"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLInteractionMode valueOf:@"MANUAL_ONLY"]).to(equal([SDLInteractionMode MANUAL_ONLY]));
        expect([SDLInteractionMode valueOf:@"VR_ONLY"]).to(equal([SDLInteractionMode VR_ONLY]));
        expect([SDLInteractionMode valueOf:@"BOTH"]).to(equal([SDLInteractionMode BOTH]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLInteractionMode valueOf:nil]).to(beNil());
        expect([SDLInteractionMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLInteractionMode values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLInteractionMode MANUAL_ONLY],
                        [SDLInteractionMode VR_ONLY],
                        [SDLInteractionMode BOTH]] mutableCopy];
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