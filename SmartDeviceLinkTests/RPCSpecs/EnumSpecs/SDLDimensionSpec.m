//
//  SDLDimensionSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDimension.h"

QuickSpecBegin(SDLDimensionSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLDimension NO_FIX].value).to(equal(@"NO_FIX"));
        expect([SDLDimension _2D].value).to(equal(@"2D"));
        expect([SDLDimension _3D].value).to(equal(@"3D"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLDimension valueOf:@"NO_FIX"]).to(equal([SDLDimension NO_FIX]));
        expect([SDLDimension valueOf:@"2D"]).to(equal([SDLDimension _2D]));
        expect([SDLDimension valueOf:@"3D"]).to(equal([SDLDimension _3D]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLDimension valueOf:nil]).to(beNil());
        expect([SDLDimension valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLDimension values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLDimension NO_FIX],
                        [SDLDimension _2D],
                        [SDLDimension _3D]] copy];
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