//
//  SDLPRNDLSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLPRNDL.h"

QuickSpecBegin(SDLPRNDLSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLPRNDL PARK].value).to(equal(@"PARK"));
        expect([SDLPRNDL REVERSE].value).to(equal(@"REVERSE"));
        expect([SDLPRNDL NEUTRAL].value).to(equal(@"NEUTRAL"));
        expect([SDLPRNDL DRIVE].value).to(equal(@"DRIVE"));
        expect([SDLPRNDL SPORT].value).to(equal(@"SPORT"));
        expect([SDLPRNDL LOWGEAR].value).to(equal(@"LOWGEAR"));
        expect([SDLPRNDL FIRST].value).to(equal(@"FIRST"));
        expect([SDLPRNDL SECOND].value).to(equal(@"SECOND"));
        expect([SDLPRNDL THIRD].value).to(equal(@"THIRD"));
        expect([SDLPRNDL FOURTH].value).to(equal(@"FOURTH"));
        expect([SDLPRNDL FIFTH].value).to(equal(@"FIFTH"));
        expect([SDLPRNDL SIXTH].value).to(equal(@"SIXTH"));
        expect([SDLPRNDL SEVENTH].value).to(equal(@"SEVENTH"));
        expect([SDLPRNDL EIGHTH].value).to(equal(@"EIGHTH"));
        expect([SDLPRNDL UNKNOWN].value).to(equal(@"UNKNOWN"));
        expect([SDLPRNDL FAULT].value).to(equal(@"FAULT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLPRNDL valueOf:@"PARK"]).to(equal([SDLPRNDL PARK]));
        expect([SDLPRNDL valueOf:@"REVERSE"]).to(equal([SDLPRNDL REVERSE]));
        expect([SDLPRNDL valueOf:@"NEUTRAL"]).to(equal([SDLPRNDL NEUTRAL]));
        expect([SDLPRNDL valueOf:@"DRIVE"]).to(equal([SDLPRNDL DRIVE]));
        expect([SDLPRNDL valueOf:@"SPORT"]).to(equal([SDLPRNDL SPORT]));
        expect([SDLPRNDL valueOf:@"LOWGEAR"]).to(equal([SDLPRNDL LOWGEAR]));
        expect([SDLPRNDL valueOf:@"FIRST"]).to(equal([SDLPRNDL FIRST]));
        expect([SDLPRNDL valueOf:@"SECOND"]).to(equal([SDLPRNDL SECOND]));
        expect([SDLPRNDL valueOf:@"THIRD"]).to(equal([SDLPRNDL THIRD]));
        expect([SDLPRNDL valueOf:@"FOURTH"]).to(equal([SDLPRNDL FOURTH]));
        expect([SDLPRNDL valueOf:@"FIFTH"]).to(equal([SDLPRNDL FIFTH]));
        expect([SDLPRNDL valueOf:@"SIXTH"]).to(equal([SDLPRNDL SIXTH]));
        expect([SDLPRNDL valueOf:@"SEVENTH"]).to(equal([SDLPRNDL SEVENTH]));
        expect([SDLPRNDL valueOf:@"EIGHTH"]).to(equal([SDLPRNDL EIGHTH]));
        expect([SDLPRNDL valueOf:@"UNKNOWN"]).to(equal([SDLPRNDL UNKNOWN]));
        expect([SDLPRNDL valueOf:@"FAULT"]).to(equal([SDLPRNDL FAULT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLPRNDL valueOf:nil]).to(beNil());
        expect([SDLPRNDL valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLPRNDL values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLPRNDL PARK],
                        [SDLPRNDL REVERSE],
                        [SDLPRNDL NEUTRAL],
                        [SDLPRNDL DRIVE],
                        [SDLPRNDL SPORT],
                        [SDLPRNDL LOWGEAR],
                        [SDLPRNDL FIRST],
                        [SDLPRNDL SECOND],
                        [SDLPRNDL THIRD],
                        [SDLPRNDL FOURTH],
                        [SDLPRNDL FIFTH],
                        [SDLPRNDL SIXTH],
                        [SDLPRNDL SEVENTH],
                        [SDLPRNDL EIGHTH],
                        [SDLPRNDL UNKNOWN],
                        [SDLPRNDL FAULT]] copy];
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