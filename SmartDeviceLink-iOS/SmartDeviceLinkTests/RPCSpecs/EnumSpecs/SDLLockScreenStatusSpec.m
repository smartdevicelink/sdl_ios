//
//  SDLLockScreenStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLLockScreenStatus.h"

QuickSpecBegin(SDLLockScreenStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLLockScreenStatus OFF].value).to(equal(@"OFF"));
        expect([SDLLockScreenStatus OPTIONAL].value).to(equal(@"OPTIONAL"));
        expect([SDLLockScreenStatus REQUIRED].value).to(equal(@"REQUIRED"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLLockScreenStatus valueOf:@"OFF"]).to(equal([SDLLockScreenStatus OFF]));
        expect([SDLLockScreenStatus valueOf:@"OPTIONAL"]).to(equal([SDLLockScreenStatus OPTIONAL]));
        expect([SDLLockScreenStatus valueOf:@"REQUIRED"]).to(equal([SDLLockScreenStatus REQUIRED]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLLockScreenStatus valueOf:nil]).to(beNil());
        expect([SDLLockScreenStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLLockScreenStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLLockScreenStatus OFF],
                        [SDLLockScreenStatus OPTIONAL],
                        [SDLLockScreenStatus REQUIRED]] copy];
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