//
//  SDLECallConfirmationStatusSpec.m
//  SmartDeviceLink


#import <Foundation/Foundation.h>

#import <Quick/Quick.h>
#import <Nimble/Nimble.h>

#import "SDLECallConfirmationStatus.h"

QuickSpecBegin(SDLECallConfirmationStatusSpec)

describe(@"Individual Enum Value Tests", ^ {
    it(@"Should match internal values", ^ {
        expect([SDLECallConfirmationStatus NORMAL].value).to(equal(@"NORMAL"));
        expect([SDLECallConfirmationStatus CALL_IN_PROGRESS].value).to(equal(@"CALL_IN_PROGRESS"));
        expect([SDLECallConfirmationStatus CALL_CANCELLED].value).to(equal(@"CALL_CANCELLED"));
        expect([SDLECallConfirmationStatus CALL_COMPLETED].value).to(equal(@"CALL_COMPLETED"));
        expect([SDLECallConfirmationStatus CALL_UNSUCCESSFUL].value).to(equal(@"CALL_UNSUCCESSFUL"));
        expect([SDLECallConfirmationStatus ECALL_CONFIGURED_OFF].value).to(equal(@"ECALL_CONFIGURED_OFF"));
        expect([SDLECallConfirmationStatus CALL_COMPLETE_DTMF_TIMEOUT].value).to(equal(@"CALL_COMPLETE_DTMF_TIMEOUT"));
    });
});
describe(@"ValueOf Tests", ^ {
    it(@"Should return correct values when valid", ^ {
        expect([SDLECallConfirmationStatus valueOf:@"NORMAL"]).to(equal([SDLECallConfirmationStatus NORMAL]));
        expect([SDLECallConfirmationStatus valueOf:@"CALL_IN_PROGRESS"]).to(equal([SDLECallConfirmationStatus CALL_IN_PROGRESS]));
        expect([SDLECallConfirmationStatus valueOf:@"CALL_CANCELLED"]).to(equal([SDLECallConfirmationStatus CALL_CANCELLED]));
        expect([SDLECallConfirmationStatus valueOf:@"CALL_COMPLETED"]).to(equal([SDLECallConfirmationStatus CALL_COMPLETED]));
        expect([SDLECallConfirmationStatus valueOf:@"CALL_UNSUCCESSFUL"]).to(equal([SDLECallConfirmationStatus CALL_UNSUCCESSFUL]));
        expect([SDLECallConfirmationStatus valueOf:@"ECALL_CONFIGURED_OFF"]).to(equal([SDLECallConfirmationStatus ECALL_CONFIGURED_OFF]));
        expect([SDLECallConfirmationStatus valueOf:@"CALL_COMPLETE_DTMF_TIMEOUT"]).to(equal([SDLECallConfirmationStatus CALL_COMPLETE_DTMF_TIMEOUT]));
    });
    
    it(@"Should return nil when invalid", ^ {
        expect([SDLECallConfirmationStatus valueOf:nil]).to(beNil());
        expect([SDLECallConfirmationStatus valueOf:@"JKUYTFHYTHJGFRFGYTR"]).to(beNil());
    });
});
describe(@"Value List Tests", ^ {
    NSArray* storedValues = [SDLECallConfirmationStatus values];
    __block NSArray* definedValues;
    beforeSuite(^ {
        definedValues = [@[[SDLECallConfirmationStatus NORMAL],
                        [SDLECallConfirmationStatus CALL_IN_PROGRESS],
                        [SDLECallConfirmationStatus CALL_CANCELLED],
                        [SDLECallConfirmationStatus CALL_COMPLETED],
                        [SDLECallConfirmationStatus CALL_UNSUCCESSFUL],
                        [SDLECallConfirmationStatus ECALL_CONFIGURED_OFF],
                        [SDLECallConfirmationStatus CALL_COMPLETE_DTMF_TIMEOUT]] copy];
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