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
        expect([SDLVRCapabilities TEXT].value).to(equal(@"TEXT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLVRCapabilities valueOf:@"TEXT"]).to(equal([SDLVRCapabilities TEXT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLVRCapabilities valueOf:nil]).to(beNil());
        expect([SDLVRCapabilities valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLVRCapabilities values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLVRCapabilities TEXT]] copy];
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