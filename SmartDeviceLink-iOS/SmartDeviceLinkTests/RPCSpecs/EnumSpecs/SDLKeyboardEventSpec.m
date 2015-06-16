//
//  SDLKeyboardEventSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLKeyboardEvent.h"

QuickSpecBegin(SDLKeyboardEventSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLKeyboardEvent KEYPRESS].value).to(equal(@"KEYPRESS"));
        expect([SDLKeyboardEvent ENTRY_SUBMITTED].value).to(equal(@"ENTRY_SUBMITTED"));
        expect([SDLKeyboardEvent ENTRY_CANCELLED].value).to(equal(@"ENTRY_CANCELLED"));
        expect([SDLKeyboardEvent ENTRY_ABORTED].value).to(equal(@"ENTRY_ABORTED"));
        expect([SDLKeyboardEvent ENTRY_VOICE].value).to(equal(@"ENTRY_VOICE"));
    });
});

describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLKeyboardEvent valueOf:@"KEYPRESS"]).to(equal([SDLKeyboardEvent KEYPRESS]));
        expect([SDLKeyboardEvent valueOf:@"ENTRY_SUBMITTED"]).to(equal([SDLKeyboardEvent ENTRY_SUBMITTED]));
        expect([SDLKeyboardEvent valueOf:@"ENTRY_CANCELLED"]).to(equal([SDLKeyboardEvent ENTRY_CANCELLED]));
        expect([SDLKeyboardEvent valueOf:@"ENTRY_ABORTED"]).to(equal([SDLKeyboardEvent ENTRY_ABORTED]));
        expect([SDLKeyboardEvent valueOf:@"ENTRY_VOICE"]).to(equal([SDLKeyboardEvent ENTRY_VOICE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLKeyboardEvent valueOf:nil]).to(beNil());
        expect([SDLKeyboardEvent valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});

describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLKeyboardEvent values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLKeyboardEvent KEYPRESS],
                           [SDLKeyboardEvent ENTRY_SUBMITTED],
                           [SDLKeyboardEvent ENTRY_CANCELLED],
                           [SDLKeyboardEvent ENTRY_ABORTED],
                           [SDLKeyboardEvent ENTRY_VOICE]] copy];
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
