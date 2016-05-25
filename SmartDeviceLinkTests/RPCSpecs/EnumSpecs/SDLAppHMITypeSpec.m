//
//  SDLAppHMITypeSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLAppHMIType.h"

QuickSpecBegin(SDLAppHMITypeSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLAppHMIType DEFAULT].value).to(equal(@"DEFAULT"));
        expect([SDLAppHMIType COMMUNICATION].value).to(equal(@"COMMUNICATION"));
        expect([SDLAppHMIType MEDIA].value).to(equal(@"MEDIA"));
        expect([SDLAppHMIType MESSAGING].value).to(equal(@"MESSAGING"));
        expect([SDLAppHMIType NAVIGATION].value).to(equal(@"NAVIGATION"));
        expect([SDLAppHMIType INFORMATION].value).to(equal(@"INFORMATION"));
        expect([SDLAppHMIType SOCIAL].value).to(equal(@"SOCIAL"));
        expect([SDLAppHMIType BACKGROUND_PROCESS].value).to(equal(@"BACKGROUND_PROCESS"));
        expect([SDLAppHMIType TESTING].value).to(equal(@"TESTING"));
        expect([SDLAppHMIType SYSTEM].value).to(equal(@"SYSTEM"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLAppHMIType valueOf:@"DEFAULT"]).to(equal([SDLAppHMIType DEFAULT]));
        expect([SDLAppHMIType valueOf:@"COMMUNICATION"]).to(equal([SDLAppHMIType COMMUNICATION]));
        expect([SDLAppHMIType valueOf:@"MEDIA"]).to(equal([SDLAppHMIType MEDIA]));
        expect([SDLAppHMIType valueOf:@"MESSAGING"]).to(equal([SDLAppHMIType MESSAGING]));
        expect([SDLAppHMIType valueOf:@"NAVIGATION"]).to(equal([SDLAppHMIType NAVIGATION]));
        expect([SDLAppHMIType valueOf:@"INFORMATION"]).to(equal([SDLAppHMIType INFORMATION]));
        expect([SDLAppHMIType valueOf:@"SOCIAL"]).to(equal([SDLAppHMIType SOCIAL]));
        expect([SDLAppHMIType valueOf:@"BACKGROUND_PROCESS"]).to(equal([SDLAppHMIType BACKGROUND_PROCESS]));
        expect([SDLAppHMIType valueOf:@"TESTING"]).to(equal([SDLAppHMIType TESTING]));
        expect([SDLAppHMIType valueOf:@"SYSTEM"]).to(equal([SDLAppHMIType SYSTEM]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLAppHMIType valueOf:nil]).to(beNil());
        expect([SDLAppHMIType valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLAppHMIType values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLAppHMIType DEFAULT],
                           [SDLAppHMIType COMMUNICATION],
                           [SDLAppHMIType MEDIA],
                           [SDLAppHMIType MESSAGING],
                           [SDLAppHMIType NAVIGATION],
                           [SDLAppHMIType INFORMATION],
                           [SDLAppHMIType SOCIAL],
                           [SDLAppHMIType BACKGROUND_PROCESS],
                           [SDLAppHMIType TESTING],
                           [SDLAppHMIType SYSTEM]] copy];
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