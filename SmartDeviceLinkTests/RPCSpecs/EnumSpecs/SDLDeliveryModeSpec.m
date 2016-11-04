//  SDLDeliverModeSpec.m
//

#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLDeliveryMode.h"

QuickSpecBegin(SDLDeliveryModeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLDeliveryMode PROMPT].value).to(equal(@"PROMPT"));
        expect([SDLDeliveryMode DESTINATION].value).to(equal(@"DESTINATION"));
        expect([SDLDeliveryMode QUEUE].value).to(equal(@"QUEUE"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLDeliveryMode valueOf:@"PROMPT"]).to(equal([SDLDeliveryMode PROMPT]));
        expect([SDLDeliveryMode valueOf:@"DESTINATION"]).to(equal([SDLDeliveryMode DESTINATION]));
        expect([SDLDeliveryMode valueOf:@"QUEUE"]).to(equal([SDLDeliveryMode QUEUE]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLDeliveryMode valueOf:nil]).to(beNil());
        expect([SDLDeliveryMode valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLDeliveryMode values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLDeliveryMode PROMPT],
                           [SDLDeliveryMode DESTINATION],
                           [SDLDeliveryMode QUEUE],
                           ] copy];
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
