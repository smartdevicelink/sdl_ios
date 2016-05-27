//
//  SDLWiperStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLWiperStatus.h"

QuickSpecBegin(SDLWiperStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLWiperStatus OFF].value).to(equal(@"OFF"));
        expect([SDLWiperStatus AUTO_OFF].value).to(equal(@"AUTO_OFF"));
        expect([SDLWiperStatus OFF_MOVING].value).to(equal(@"OFF_MOVING"));
        expect([SDLWiperStatus MAN_INT_OFF].value).to(equal(@"MAN_INT_OFF"));
        expect([SDLWiperStatus MAN_INT_ON].value).to(equal(@"MAN_INT_ON"));
        expect([SDLWiperStatus MAN_LOW].value).to(equal(@"MAN_LOW"));
        expect([SDLWiperStatus MAN_HIGH].value).to(equal(@"MAN_HIGH"));
        expect([SDLWiperStatus MAN_FLICK].value).to(equal(@"MAN_FLICK"));
        expect([SDLWiperStatus WASH].value).to(equal(@"WASH"));
        expect([SDLWiperStatus AUTO_LOW].value).to(equal(@"AUTO_LOW"));
        expect([SDLWiperStatus AUTO_HIGH].value).to(equal(@"AUTO_HIGH"));
        expect([SDLWiperStatus COURTESYWIPE].value).to(equal(@"COURTESYWIPE"));
        expect([SDLWiperStatus AUTO_ADJUST].value).to(equal(@"AUTO_ADJUST"));
        expect([SDLWiperStatus STALLED].value).to(equal(@"STALLED"));
        expect([SDLWiperStatus NO_DATA_EXISTS].value).to(equal(@"NO_DATA_EXISTS"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLWiperStatus valueOf:@"OFF"]).to(equal([SDLWiperStatus OFF]));
        expect([SDLWiperStatus valueOf:@"AUTO_OFF"]).to(equal([SDLWiperStatus AUTO_OFF]));
        expect([SDLWiperStatus valueOf:@"OFF_MOVING"]).to(equal([SDLWiperStatus OFF_MOVING]));
        expect([SDLWiperStatus valueOf:@"MAN_INT_OFF"]).to(equal([SDLWiperStatus MAN_INT_OFF]));
        expect([SDLWiperStatus valueOf:@"MAN_INT_ON"]).to(equal([SDLWiperStatus MAN_INT_ON]));
        expect([SDLWiperStatus valueOf:@"MAN_LOW"]).to(equal([SDLWiperStatus MAN_LOW]));
        expect([SDLWiperStatus valueOf:@"MAN_HIGH"]).to(equal([SDLWiperStatus MAN_HIGH]));
        expect([SDLWiperStatus valueOf:@"MAN_FLICK"]).to(equal([SDLWiperStatus MAN_FLICK]));
        expect([SDLWiperStatus valueOf:@"WASH"]).to(equal([SDLWiperStatus WASH]));
        expect([SDLWiperStatus valueOf:@"AUTO_LOW"]).to(equal([SDLWiperStatus AUTO_LOW]));
        expect([SDLWiperStatus valueOf:@"AUTO_HIGH"]).to(equal([SDLWiperStatus AUTO_HIGH]));
        expect([SDLWiperStatus valueOf:@"COURTESYWIPE"]).to(equal([SDLWiperStatus COURTESYWIPE]));
        expect([SDLWiperStatus valueOf:@"AUTO_ADJUST"]).to(equal([SDLWiperStatus AUTO_ADJUST]));
        expect([SDLWiperStatus valueOf:@"STALLED"]).to(equal([SDLWiperStatus STALLED]));
        expect([SDLWiperStatus valueOf:@"NO_DATA_EXISTS"]).to(equal([SDLWiperStatus NO_DATA_EXISTS]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLWiperStatus valueOf:nil]).to(beNil());
        expect([SDLWiperStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLWiperStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLWiperStatus OFF],
                        [SDLWiperStatus AUTO_OFF],
                        [SDLWiperStatus OFF_MOVING],
                        [SDLWiperStatus MAN_INT_OFF],
                        [SDLWiperStatus MAN_INT_ON],
                        [SDLWiperStatus MAN_LOW],
                        [SDLWiperStatus MAN_HIGH],
                        [SDLWiperStatus MAN_FLICK],
                        [SDLWiperStatus WASH],
                        [SDLWiperStatus AUTO_LOW],
                        [SDLWiperStatus AUTO_HIGH],
                        [SDLWiperStatus COURTESYWIPE],
                        [SDLWiperStatus AUTO_ADJUST],
                        [SDLWiperStatus STALLED],
                        [SDLWiperStatus NO_DATA_EXISTS]] copy];
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