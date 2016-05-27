//
//  SDLKeypressModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeypressMode.h"

QuickSpecBegin(SDLKeypressModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLKeypressMode SINGLE_KEYPRESS].value).to(equal(@"SINGLE_KEYPRESS"));
        expect([SDLKeypressMode QUEUE_KEYPRESSES].value).to(equal(@"QUEUE_KEYPRESSES"));
        expect([SDLKeypressMode RESEND_CURRENT_ENTRY].value).to(equal(@"RESEND_CURRENT_ENTRY"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLKeypressMode valueOf:@"SINGLE_KEYPRESS"]).to(equal([SDLKeypressMode SINGLE_KEYPRESS]));
        expect([SDLKeypressMode valueOf:@"QUEUE_KEYPRESSES"]).to(equal([SDLKeypressMode QUEUE_KEYPRESSES]));
        expect([SDLKeypressMode valueOf:@"RESEND_CURRENT_ENTRY"]).to(equal([SDLKeypressMode RESEND_CURRENT_ENTRY]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLKeypressMode valueOf:nil]).to(beNil());
        expect([SDLKeypressMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLKeypressMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLKeypressMode SINGLE_KEYPRESS],
                        [SDLKeypressMode QUEUE_KEYPRESSES],
                        [SDLKeypressMode RESEND_CURRENT_ENTRY]] copy];
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