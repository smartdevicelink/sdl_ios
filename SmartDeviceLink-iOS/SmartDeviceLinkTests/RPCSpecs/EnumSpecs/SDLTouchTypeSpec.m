//
//  SDLTouchTypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLTouchType.h"

QuickSpecBegin(SDLTouchTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLTouchType BEGIN].value).to(equal(@"BEGIN"));
        expect([SDLTouchType MOVE].value).to(equal(@"MOVE"));
        expect([SDLTouchType END].value).to(equal(@"END"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLTouchType valueOf:@"BEGIN"]).to(equal([SDLTouchType BEGIN]));
        expect([SDLTouchType valueOf:@"MOVE"]).to(equal([SDLTouchType MOVE]));
        expect([SDLTouchType valueOf:@"END"]).to(equal([SDLTouchType END]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLTouchType valueOf:nil]).to(beNil());
        expect([SDLTouchType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSMutableArray* storedValues = [SDLTouchType values];
    __block NSMutableArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLTouchType BEGIN],
                        [SDLTouchType MOVE],
                        [SDLTouchType END]] mutableCopy];
    });
    
    it(@"Should contain all defined enum values", ^ {
        for (int i = 0; i < definedValues.count; i++) {
            expect(storedValues).to(contain([definedValues objectAtIndex:i]));
        }
    });
    
    it(@"Should contain only defined enum values", ^ {
        for (int i = 0; i < storedValues.count; i++) {
            expect(definedValues).to(contain([storedValues objectAtIndex:i]));
        }
    });
});

QuickSpecEnd