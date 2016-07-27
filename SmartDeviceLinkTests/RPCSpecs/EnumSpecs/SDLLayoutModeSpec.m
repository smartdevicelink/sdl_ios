//
//  SDLLayoutModeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLayoutMode.h"

QuickSpecBegin(SDLLayoutModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLLayoutMode ICON_ONLY].value).to(equal(@"ICON_ONLY"));
        expect([SDLLayoutMode ICON_WITH_SEARCH].value).to(equal(@"ICON_WITH_SEARCH"));
        expect([SDLLayoutMode LIST_ONLY].value).to(equal(@"LIST_ONLY"));
        expect([SDLLayoutMode LIST_WITH_SEARCH].value).to(equal(@"LIST_WITH_SEARCH"));
        expect([SDLLayoutMode KEYBOARD].value).to(equal(@"KEYBOARD"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLLayoutMode valueOf:@"ICON_ONLY"]).to(equal([SDLLayoutMode ICON_ONLY]));
        expect([SDLLayoutMode valueOf:@"ICON_WITH_SEARCH"]).to(equal([SDLLayoutMode ICON_WITH_SEARCH]));
        expect([SDLLayoutMode valueOf:@"LIST_ONLY"]).to(equal([SDLLayoutMode LIST_ONLY]));
        expect([SDLLayoutMode valueOf:@"LIST_WITH_SEARCH"]).to(equal([SDLLayoutMode LIST_WITH_SEARCH]));
        expect([SDLLayoutMode valueOf:@"KEYBOARD"]).to(equal([SDLLayoutMode KEYBOARD]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLLayoutMode valueOf:nil]).to(beNil());
        expect([SDLLayoutMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLLayoutMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLLayoutMode ICON_ONLY],
                        [SDLLayoutMode ICON_WITH_SEARCH],
                        [SDLLayoutMode LIST_ONLY],
                        [SDLLayoutMode LIST_WITH_SEARCH],
                        [SDLLayoutMode KEYBOARD]] copy];
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