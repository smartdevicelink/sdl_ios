//
//  SDLImageTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLImageType.h"

QuickSpecBegin(SDLImageTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLImageType STATIC].value).to(equal(@"STATIC"));
        expect([SDLImageType DYNAMIC].value).to(equal(@"DYNAMIC"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLImageType valueOf:@"STATIC"]).to(equal([SDLImageType STATIC]));
        expect([SDLImageType valueOf:@"DYNAMIC"]).to(equal([SDLImageType DYNAMIC]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLImageType valueOf:nil]).to(beNil());
        expect([SDLImageType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLImageType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLImageType STATIC],
                        [SDLImageType DYNAMIC]] copy];
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