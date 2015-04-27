//
//  SDLSoftButtonTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSoftButtonType.h"

QuickSpecBegin(SDLSoftButtonTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLSoftButtonType TEXT].value).to(equal(@"TEXT"));
        expect([SDLSoftButtonType IMAGE].value).to(equal(@"IMAGE"));
        expect([SDLSoftButtonType BOTH].value).to(equal(@"BOTH"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLSoftButtonType valueOf:@"TEXT"]).to(equal([SDLSoftButtonType TEXT]));
        expect([SDLSoftButtonType valueOf:@"IMAGE"]).to(equal([SDLSoftButtonType IMAGE]));
        expect([SDLSoftButtonType valueOf:@"BOTH"]).to(equal([SDLSoftButtonType BOTH]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLSoftButtonType valueOf:nil]).to(beNil());
        expect([SDLSoftButtonType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLSoftButtonType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLSoftButtonType TEXT],
                        [SDLSoftButtonType IMAGE],
                        [SDLSoftButtonType BOTH]] copy];
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