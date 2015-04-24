//
//  SDLMediaClockFormatSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLMediaClockFormat.h"

QuickSpecBegin(SDLMediaClockFormatSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLMediaClockFormat CLOCK1].value).to(equal(@"CLOCK1"));
        expect([SDLMediaClockFormat CLOCK2].value).to(equal(@"CLOCK2"));
        expect([SDLMediaClockFormat CLOCK3].value).to(equal(@"CLOCK3"));
        expect([SDLMediaClockFormat CLOCKTEXT1].value).to(equal(@"CLOCKTEXT1"));
        expect([SDLMediaClockFormat CLOCKTEXT2].value).to(equal(@"CLOCKTEXT2"));
        expect([SDLMediaClockFormat CLOCKTEXT3].value).to(equal(@"CLOCKTEXT3"));
        expect([SDLMediaClockFormat CLOCKTEXT4].value).to(equal(@"CLOCKTEXT4"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLMediaClockFormat valueOf:@"CLOCK1"]).to(equal([SDLMediaClockFormat CLOCK1]));
        expect([SDLMediaClockFormat valueOf:@"CLOCK2"]).to(equal([SDLMediaClockFormat CLOCK2]));
        expect([SDLMediaClockFormat valueOf:@"CLOCK3"]).to(equal([SDLMediaClockFormat CLOCK3]));
        expect([SDLMediaClockFormat valueOf:@"CLOCKTEXT1"]).to(equal([SDLMediaClockFormat CLOCKTEXT1]));
        expect([SDLMediaClockFormat valueOf:@"CLOCKTEXT2"]).to(equal([SDLMediaClockFormat CLOCKTEXT2]));
        expect([SDLMediaClockFormat valueOf:@"CLOCKTEXT3"]).to(equal([SDLMediaClockFormat CLOCKTEXT3]));
        expect([SDLMediaClockFormat valueOf:@"CLOCKTEXT4"]).to(equal([SDLMediaClockFormat CLOCKTEXT4]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLMediaClockFormat valueOf:nil]).to(beNil());
        expect([SDLMediaClockFormat valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLMediaClockFormat values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLMediaClockFormat CLOCK1],
                        [SDLMediaClockFormat CLOCK2],
                        [SDLMediaClockFormat CLOCK3],
                        [SDLMediaClockFormat CLOCKTEXT1],
                        [SDLMediaClockFormat CLOCKTEXT2],
                        [SDLMediaClockFormat CLOCKTEXT3],
                        [SDLMediaClockFormat CLOCKTEXT4]] copy];
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
