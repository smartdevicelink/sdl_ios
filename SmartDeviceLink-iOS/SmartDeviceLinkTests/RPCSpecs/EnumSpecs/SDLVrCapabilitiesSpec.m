//
//  SDLVrCapabilitiesSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLVrCapabilities.h"

QuickSpecBegin(SDLVrCapabilitiesSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLVrCapabilities TEXT].value).to(equal(@"TEXT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVrCapabilities valueOf:@"TEXT"]).to(equal([SDLVrCapabilities TEXT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVrCapabilities valueOf:nil]).to(beNil());
        expect([SDLVrCapabilities valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLVrCapabilities values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVrCapabilities TEXT]] mutableCopy];
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