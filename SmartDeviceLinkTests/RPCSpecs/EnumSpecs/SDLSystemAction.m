//
//  SDLSystemActionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemAction.h"

QuickSpecBegin(SDLSystemActionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLSystemAction DEFAULT_ACTION].value).to(equal(@"DEFAULT_ACTION"));
        expect([SDLSystemAction STEAL_FOCUS].value).to(equal(@"STEAL_FOCUS"));
        expect([SDLSystemAction KEEP_CONTEXT].value).to(equal(@"KEEP_CONTEXT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLSystemAction valueOf:@"DEFAULT_ACTION"]).to(equal([SDLSystemAction DEFAULT_ACTION]));
        expect([SDLSystemAction valueOf:@"STEAL_FOCUS"]).to(equal([SDLSystemAction STEAL_FOCUS]));
        expect([SDLSystemAction valueOf:@"KEEP_CONTEXT"]).to(equal([SDLSystemAction KEEP_CONTEXT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLSystemAction valueOf:nil]).to(beNil());
        expect([SDLSystemAction valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLSystemAction values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLSystemAction DEFAULT_ACTION],
                        [SDLSystemAction STEAL_FOCUS],
                        [SDLSystemAction KEEP_CONTEXT]] copy];
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