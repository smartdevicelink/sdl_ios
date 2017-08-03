
#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLSystemCapabilityType.h"

QuickSpecBegin(SDLSystemCapabilityTypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLSystemCapabilityType NAVIGATION].value).to(equal(@"NAVIGATION"));
        expect([SDLSystemCapabilityType PHONE_CALL].value).to(equal(@"PHONE_CALL"));
        expect([SDLSystemCapabilityType VIDEO_STREAMING].value).to(equal(@"VIDEO_STREAMING"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLSystemCapabilityType valueOf:@"NAVIGATION"]).to(equal([SDLSystemCapabilityType NAVIGATION]));
        expect([SDLSystemCapabilityType valueOf:@"PHONE_CALL"]).to(equal([SDLSystemCapabilityType PHONE_CALL]));
        expect([SDLSystemCapabilityType valueOf:@"VIDEO_STREAMING"]).to(equal([SDLSystemCapabilityType VIDEO_STREAMING]));
    });

    it(@"Should return nil when invalid", ^ {
        expect([SDLSystemCapabilityType valueOf:nil]).to(beNil());
        expect([SDLSystemCapabilityType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLSystemCapabilityType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLSystemCapabilityType NAVIGATION],
                           [SDLSystemCapabilityType PHONE_CALL],
                           [SDLSystemCapabilityType VIDEO_STREAMING]] copy];
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
